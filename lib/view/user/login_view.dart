import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_event.dart';
import 'package:league_of_legends_library/bloc/user/login/login_state.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_state.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';
import 'package:league_of_legends_library/view/user/form_error_box.dart';
import 'package:league_of_legends_library/view/user/password_reset_page.dart';
import 'package:league_of_legends_library/view/user/sign_up_page.dart';
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

    return MultiBlocListener(
      listeners: [
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
          LoginError() => _loginScreen(
              context, emailController, passwordController,
              error: state.error),
        },
      ),
    );
  }

  Widget _loginScreen(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController, {
    Object? error,
  }) {
    final formKey = GlobalKey<FormState>();
    bool areCredentialsWrong = error is InvalidCredentials;

    submitForm() {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        context.read<LoginBloc>().add(
            LoginButtonPressed(emailController.text, passwordController.text));
      }
    }

    if (error != null && !areCredentialsWrong) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.loginErrorAlertTitle ??
                "Login error"),
            content: Text(
                AppLocalizations.of(context)?.loginErrorAlertDescription ??
                    "An error occurred during login, please try again later"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
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
              if (areCredentialsWrong)
                FormErrorBox(
                    errorMessage:
                        AppLocalizations.of(context)?.wrongCredentials ??
                            "Wrong credentials"),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null ||
                        value.isEmpty ||
                        !value.contains("@")
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
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter your password"
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)?.passwordLabel ?? "Password",
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
                    child: Text(AppLocalizations.of(context)?.forgotPassword ??
                        "Reset password"),
                  )
                ],
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120, minHeight: 48),
                child: FilledButton(
                  onPressed: submitForm,
                  child: Text(AppLocalizations.of(context)?.login ?? "Login"),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120, minHeight: 48),
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
    );
  }
}
