import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_event.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final resetFromKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.passwordResetLabel ??
            "Password reset"),
      ),
      body: SingleChildScrollView(
        child: BlocListener<PasswordResetBloc, PasswordResetState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
                context.read<PasswordResetBloc>().add(ResetPasswordView());
              }
            } else if (state is PasswordResetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Something went wrong, please try again"),
                ),
              );
            }
          },
          child: BlocBuilder<PasswordResetBloc, PasswordResetState>(
            builder: (context, state) => switch (state) {
              PasswordResetInitial() || PasswordResetError() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: resetFromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null ||
                                  value.isEmpty ||
                                  !value.contains("@")
                              ? AppLocalizations.of(context)
                                      ?.invalidMailAddressError ??
                                  "Please insert a valid email address"
                              : null,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)?.emailLabel ??
                                    "Email",
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        FilledButton(
                          onPressed: () {
                            if (resetFromKey.currentState != null &&
                                resetFromKey.currentState!.validate()) {
                              context.read<PasswordResetBloc>().add(
                                  PasswordResetButtonPressed(
                                      emailController.text));
                            }
                          },
                          child: Text(
                              AppLocalizations.of(context)?.send ?? "Send"),
                        ),
                      ],
                    ),
                  ),
                ),
              PasswordResetLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              PasswordResetSuccess() => _successfullySentPasswordReset(),
            },
          ),
        ),
      ),
    );
  }

  // TODO fix alignment
  Widget _successfullySentPasswordReset() => const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check),
            Text("Email sent successfully"),
          ],
        ),
      );
}
