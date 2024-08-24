import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_bloc.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_event.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController(),
        passwordCheckController = TextEditingController(),
        oldPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.changePasswordPageTitle ??
            "Change your password"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) => switch (userState) {
                UserLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                UpdatingUserData() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                UserLogged() => MultiBlocListener(
                      listeners: [
                        BlocListener<ChangePasswordBloc, ChangePasswordState>(
                          listener: (context, state) {
                            if (state is PasswordChanged) {
                              Navigator.of(context).pop();
                            } else if (state is ChangePasswordError) {
                              String message = AppLocalizations.of(context)
                                      ?.changePasswordError ??
                                  "An error has occurred please try again";
                              if (state.error is InvalidCredentials) {
                                message = AppLocalizations.of(context)
                                        ?.oldPasswordIsWrong ??
                                    "Old password is not correct";
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(message),
                              ));
                            }
                          },
                        ),
                      ],
                      child:
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                              builder: (context, changePasswordState) =>
                                  switch (changePasswordState) {
                                    ChangePasswordIdle() ||
                                    PasswordChanged() ||
                                    ChangePasswordError() =>
                                      _changePasswordForm(
                                          context,
                                          formKey,
                                          oldPasswordController,
                                          passwordController,
                                          passwordCheckController, () {
                                        if (formKey.currentState != null &&
                                            formKey.currentState!.validate()) {
                                          context
                                              .read<ChangePasswordBloc>()
                                              .add(ChangePassword(
                                                  userState.appUser.email,
                                                  passwordController.text,
                                                  oldPasswordController.text));
                                        }
                                      }),
                                    ChangingPassword() => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  })),
                NoUserLogged() || UserError() => const GenericErrorView(),
              }),
    );
  }

  Widget _changePasswordForm(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController oldPasswordController,
      TextEditingController passwordController,
      TextEditingController passwordCheckController,
      Function() onSubmit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: oldPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter a password"
                    : null,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)?.passwordLabel ??
                        "Password"),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter a password";
                  } else if (value.length < 6) {
                    return AppLocalizations.of(context)?.shortPasswordMessage ??
                        "Password should have at least 6 characters";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)?.newPasswordLabel ??
                      "New password",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: passwordCheckController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter a password";
                  } else if (passwordController.text !=
                      passwordCheckController.text) {
                    return AppLocalizations.of(context)?.notMatchingPasswords ??
                        "Passwords doesn't match";
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) => onSubmit(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)?.repeatNewPassword ??
                      "Repeat new password",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              FilledButton(
                onPressed: onSubmit,
                child: Text(
                    AppLocalizations.of(context)?.changeYourPasswordLabel ??
                        "Change password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
