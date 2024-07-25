import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_event.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(),
        nameController = TextEditingController(),
        surnameController = TextEditingController(),
        summonerNameController = TextEditingController(),
        passwordController = TextEditingController(),
        passwordCheckController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.signUp ?? "Sign up"),
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            }
          } else if (state is SignUpError) {
            String? errorMessage;
            if (state.error is FirebaseAuthException) {
              errorMessage = (state.error as FirebaseAuthException).message;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // TODO could improve error messages with translations
                content: Text(
                    errorMessage ?? "Something went wrong, please try again "),
              ),
            );
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) => switch (state) {
            SignUpInitial() || SignUpSuccess() || SignUpError() => _signUpForm(
                context,
                formKey,
                emailController,
                nameController,
                surnameController,
                summonerNameController,
                passwordController,
                passwordCheckController),
            SignUpLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
          },
        ),
      ),
    );
  }

  Widget _signUpForm(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController emailController,
      TextEditingController nameController,
      TextEditingController surnameController,
      TextEditingController summonerNameController,
      TextEditingController passwordController,
      TextEditingController passwordCheckController) {
    submitForm() {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        context.read<SignUpBloc>().add(SignUpButtonPressed(
              emailController.text,
              passwordController.text,
              summonerNameController.text,
              nameController.text,
              surnameController.text,
            ));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.signUp ?? "Sign Up",
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
                height: 30,
              ),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptyName ??
                        "Please enter your name"
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)?.nameLabel ?? "Name",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: surnameController,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptySurname ??
                        "Please enter your surname"
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)?.surnameLabel ?? "Surname",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: summonerNameController,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptySummonerName ??
                        "Please enter your summoner name"
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)?.summonerNameLabel ??
                      "Summoner name",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter a password"
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)?.passwordLabel ?? "Password",
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
                onFieldSubmitted: (value) => submitForm(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)?.repeatPasswordLabel ??
                          "Repeat password",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              FilledButton(
                  onPressed: submitForm,
                  child:
                      Text(AppLocalizations.of(context)?.signUp ?? "Sign up")),
            ],
          ),
        ),
      ),
    );
  }
}
