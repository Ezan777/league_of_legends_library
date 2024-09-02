import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_event.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({super.key});

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.deleteAccountPageTitle ??
            "Delete your account"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteUserBloc, DeleteUserState>(
            listener: (context, state) {
              if (state is DeleteUserError) {
                String message = "Something went wrong, try again";
                if (state.error is InvalidCredentials) {
                  message = AppLocalizations.of(context)?.wrongCredentials ??
                      "Wrong credentials";
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                ));
              } else if (state is DeleteUserSuccess) {
                context.read<UserBloc>().add(LogoutButtonPressed());
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        child: BlocBuilder<DeleteUserBloc, DeleteUserState>(
          builder: (context, state) => switch (state) {
            DeleteUserIdle() => SingleChildScrollView(
                child: _credentialsForm(
                  context,
                  formKey,
                  state.loggedUser,
                  passwordController,
                ),
              ),
            DeleteUserSuccess() => Center(
                child: Text(AppLocalizations.of(context)?.userDeletedSuccess ??
                    "Deleted"),
              ),
            DeleteUserLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            DeleteUserError() => _credentialsForm(
                context,
                formKey,
                state.appUser,
                passwordController,
              ),
          },
        ),
      ),
    );
  }

  Widget _credentialsForm(
    BuildContext context,
    GlobalKey<FormState> formKey,
    AppUser loggedUser,
    TextEditingController passwordController,
  ) {
    onSubmit() async {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text(
                AppLocalizations.of(context)?.deleteConfirmDialogTitle ??
                    "Are you sure?"),
            content: Text(
                AppLocalizations.of(context)?.deleteConfirmDialogDescription ??
                    "Are you sure you want to delete your account?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<DeleteUserBloc>().add(DeleteUser(
                      loggedUser, loggedUser.email, passwordController.text));
                },
                child: Text(AppLocalizations.of(context)
                        ?.deleteConfirmDialogConfirmActionLabel ??
                    "Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
              ),
            ],
          ),
        );
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
              const SizedBox(
                height: 20,
              ),
              Text(
                loggedUser.email,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) => onSubmit(),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.emptyPassword ??
                        "Please enter a password";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context)?.passwordLabel ?? "Password",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              FilledButton(
                onPressed: onSubmit,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.error),
                  textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                            fontWeight: FontWeight.w500,
                          )),
                ),
                child: Text(
                    AppLocalizations.of(context)?.deleteUserButtonLabel ??
                        "Delete your account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
