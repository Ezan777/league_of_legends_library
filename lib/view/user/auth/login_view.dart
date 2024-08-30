import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_event.dart';
import 'package:league_of_legends_library/bloc/user/login/login_state.dart';
import 'package:league_of_legends_library/bloc/user/password_reset/password_reset_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset/password_reset_state.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:league_of_legends_library/view/errors/connection_unavailable_view.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';
import 'package:league_of_legends_library/view/user/auth/password_reset_page.dart';
import 'package:league_of_legends_library/view/user/auth/sign_up_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    reloadPage() {
      context.read<LoginBloc>().add(LoginStarted());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("League of Legends library"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginError) {
                if (state.error is InvalidCredentials) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        AppLocalizations.of(context)?.wrongCredentials ??
                            "Invalid credentials"),
                  ));
                }
              }
            },
          ),
          BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                context
                    .read<LoginBloc>()
                    .add(LoginButtonPressed(state.email, state.password));
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (UserState is NoUserLogged) {
                context.read<LoginBloc>().add(LoginStarted());
              }
            },
          ),
          BlocListener<PasswordResetBloc, PasswordResetState>(
            listener: (context, state) {
              if (state is PasswordResetSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                            ?.passwordResetSuccess(state.email) ??
                        "Email sent successfully to: ${state.email}"),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => switch (state) {
            LoginLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            LoginInitial() ||
            LoginSuccess() =>
              _loginScreen(context, emailController, passwordController),
            LoginError() => switch (state.error) {
                InvalidCredentials() =>
                  _loginScreen(context, emailController, passwordController),
                InternetConnectionUnavailable() =>
                  ConnectionUnavailableView(retryCallback: reloadPage),
                _ => GenericErrorView(
                    error: state.error,
                    retryCallback: reloadPage,
                  ),
              },
          },
        ),
      ),
    );
  }

  Widget _loginScreen(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    final formKey = GlobalKey<FormState>();
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    submitForm() {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        context.read<LoginBloc>().add(
            LoginButtonPressed(emailController.text, passwordController.text));
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)?.login ?? "Login",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) => value == null ||
                          value.isEmpty ||
                          !emailRegex.hasMatch(value)
                      ? AppLocalizations.of(context)?.invalidMailAddressError ??
                          "Please insert a valid email address"
                      : null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)?.emailLabel ?? "Email",
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  onFieldSubmitted: (value) {
                    submitForm();
                  },
                  autofillHints: const [AutofillHints.password],
                  validator: (value) => value == null || value.isEmpty
                      ? AppLocalizations.of(context)?.emptyPassword ??
                          "Please enter your password"
                      : null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)?.passwordLabel ??
                        "Password",
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PasswordResetPage(),
                        ));
                      },
                      child: Text(
                          AppLocalizations.of(context)?.forgotPassword ??
                              "Reset password"),
                    )
                  ],
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 120, minHeight: 48),
                  child: FilledButton(
                    onPressed: submitForm,
                    child: Text(AppLocalizations.of(context)?.login ?? "Login"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 120, minHeight: 48),
                  child: FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ));
                    },
                    child:
                        Text(AppLocalizations.of(context)?.signUp ?? "Sign up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
