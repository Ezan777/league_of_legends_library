import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_event.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  RiotServer? chosenServer;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(),
      nameController = TextEditingController(),
      surnameController = TextEditingController(),
      summonerNameController = TextEditingController(),
      tagLineController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordCheckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                content: Text(errorMessage ??
                    "Something went wrong, please try again - Error: ${state.error}"),
              ),
            );
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) => switch (state) {
            SignUpInitial() ||
            SignUpSuccess() ||
            SignUpError() =>
              _signUpForm(context),
            SignUpLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
          },
        ),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    final RegExp specialCharOrNumberRegex =
        RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    submitForm() {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        context.read<SignUpBloc>().add(SignUpButtonPressed(
            emailController.text,
            passwordController.text,
            summonerNameController.text,
            tagLineController.text,
            chosenServer ?? RiotServer.europeWest,
            nameController.text,
            surnameController.text));
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
                height: 30,
              ),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptyName ??
                        "Please enter your name";
                  } else if (specialCharOrNumberRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.invalidName ??
                        "Please insert a valid name";
                  } else {
                    return null;
                  }
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptySurname ??
                        "Please enter your surname";
                  } else if (specialCharOrNumberRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.invalidSurname ??
                        "Please insert a valid surname";
                  } else {
                    return null;
                  }
                },
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
                controller: tagLineController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptyTagLine ??
                        "Please enter your account tagline";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  prefix: const Text("#"),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)?.tagLine ?? "Tagline",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _serverDropDownMenu(context),
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
                  } else if (value.length < 6) {
                    return AppLocalizations.of(context)?.shortPasswordMessage ??
                        "Password should have at least 6 characters";
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

  Widget _serverDropDownMenu(BuildContext context) =>
      DropdownButtonFormField<RiotServer>(
        value: chosenServer,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)?.serverDropDownLabel ??
              "Select your server"),
        ),
        validator: (value) => value == null
            ? AppLocalizations.of(context)?.emptyServer ??
                "Please select a server"
            : null,
        onChanged: (value) {
          setState(() {
            chosenServer = value ?? RiotServer.europeWest;
          });
        },
        items: RiotServer.values
            .map((server) => DropdownMenuItem(
                  value: server,
                  child: Row(
                    children: [
                      if (chosenServer == server)
                        Container(
                          height: 6,
                          width: 6,
                          margin: const EdgeInsets.only(right: 10, left: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      Text(server.serverCode),
                    ],
                  ),
                ))
            .toList(),
      );
}
