import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_bloc.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_state.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_event.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/view/user/change_password_page.dart';
import 'package:league_of_legends_library/view/user/delete_user_page.dart';

class EditUserData extends StatefulWidget {
  const EditUserData({super.key});

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  bool isDataBeingEdited = false;
  final formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();
  RiotServer? chosenServer;
  final nameController = TextEditingController(),
      surnameController = TextEditingController(),
      summonerNameController = TextEditingController(),
      tagLineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 325),
    );
    animation = Tween<double>(begin: 0, end: 50).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(listener: (context, state) {
          if (state is UserLogged) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  AppLocalizations.of(context)?.dataUpdateSuccessfully ??
                      "Data updated successfully"),
            ));
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.somethingWentWrong(state.error?.toString() ?? "") ??
                  "Something went wrong while updating your data"),
            ));
          } else if (state is NoUserLogged) {
            Navigator.of(context).pop();
          }
        }),
        BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is PasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)?.passwordChangedMessage ??
                        "Password changed successfully"),
              ));
            }
          },
        ),
        BlocListener<DeleteUserBloc, DeleteUserState>(
          listener: (context, state) {
            if (state is DeleteUserSuccess) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => switch (state) {
          UserLoading() => const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          UserLogged() => Scaffold(
              appBar: AppBar(
                title: Text(state.appUser.summonerName),
              ),
              body: _userData(context, state.appUser),
            ),
          UpdatingUserData() => Scaffold(
              appBar: AppBar(
                title: Text(state.newUser.summonerName),
              ),
              body: _userData(
                context,
                state.newUser,
                isDataBeingUpdated: true,
              ),
            ),
          NoUserLogged() || UserError() => Scaffold(
              appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context)?.editAccountInfoLabel ??
                        "Account info"),
              ),
              body: GenericErrorView(
                retryCallback: () =>
                    context.read<UserBloc>().add(UserStarted()),
              ),
            ),
        },
      ),
    );
  }

  Widget _userData(BuildContext context, AppUser user,
      {bool isDataBeingUpdated = false}) {
    final RegExp specialCharOrNumberRegex =
        RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    chosenServer ??= RiotServer.fromServerCode(user.serverCode);

    if (nameController.text == "") nameController.text = user.name;
    if (surnameController.text == "") surnameController.text = user.surname;
    if (summonerNameController.text == "") {
      summonerNameController.text = user.summonerName;
    }
    if (tagLineController.text == "") tagLineController.text = user.tagLine;

    resetTextControllers() {
      nameController.text = user.name;
      surnameController.text = user.surname;
      summonerNameController.text = user.summonerName;
      tagLineController.text = user.tagLine;
    }

    submitForm() {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        context.read<UserBloc>().add(UpdateUserData(
              AppUser(
                  id: user.id,
                  email: user.email,
                  summonerName: summonerNameController.text,
                  tagLine: tagLineController.text,
                  serverCode: chosenServer!.serverCode,
                  name: nameController.text,
                  surname: surnameController.text),
            ));
      }
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)?.accountInfoTitle ??
                    "Account info",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _textUserData(
                    context,
                    AppLocalizations.of(context)?.nameLabel ?? "Name",
                    nameController,
                    (value) {
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
                  ),
                  _textUserData(
                    context,
                    AppLocalizations.of(context)?.surnameLabel ?? "Surname",
                    surnameController,
                    (value) {
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
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _textUserData(
                    context,
                    AppLocalizations.of(context)?.summonerNameLabel ??
                        "Summoner Name",
                    summonerNameController,
                    (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)?.emptySummonerName ??
                            "Please enter your summoner name"
                        : null,
                  ),
                  _textUserData(
                    context,
                    AppLocalizations.of(context)?.tagLine ?? "Tagline",
                    tagLineController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)?.emptyTagLine ??
                            "Please enter your account tagline";
                      } else {
                        return null;
                      }
                    },
                    prefix: const Text("#"),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 0.38 * MediaQuery.of(context).size.width,
                child: DropdownButtonFormField<RiotServer>(
                  key: dropdownState,
                  value: chosenServer,
                  decoration: InputDecoration(
                    label: Text(
                        AppLocalizations.of(context)?.serverDropDownLabel ??
                            "Server"),
                  ),
                  validator: (value) => value == null || chosenServer == null
                      ? AppLocalizations.of(context)?.emptyServer ??
                          "Please select a server"
                      : null,
                  onChanged: isDataBeingEdited
                      ? (value) {
                          setState(() {
                            chosenServer = value ?? RiotServer.europeWest;
                          });
                        }
                      : null,
                  items: RiotServer.values
                      .map((server) => DropdownMenuItem(
                            value: server,
                            child: Semantics(
                              selected: chosenServer == server,
                              child: Row(
                                children: [
                                  if (chosenServer == server)
                                    Container(
                                      height: 6,
                                      width: 6,
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(
                                                isDataBeingEdited ? 255 : 125),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                    ),
                                  Text(server.serverCode),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: isDataBeingUpdated
                    ? const CircularProgressIndicator.adaptive()
                    : isDataBeingEdited
                        ? _editingButtons(context, user, () {
                            submitForm();
                            setState(() {
                              isDataBeingEdited = false;
                            });
                            animationController.reverse();
                          }, () {
                            setState(() {
                              isDataBeingEdited = false;
                              dropdownState.currentState?.didChange(
                                  RiotServer.fromServerCode(user.serverCode));
                            });
                            resetTextControllers();
                            animationController.reverse();
                          })
                        : FilledButton(
                            key: ValueKey<bool>(isDataBeingEdited),
                            onPressed: () {
                              setState(() {
                                isDataBeingEdited = true;
                              });
                              animationController.forward();
                            },
                            child: Text(AppLocalizations.of(context)
                                    ?.editAccountInfoLabel ??
                                "Edit data"),
                          ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context)?.authenticationDataTitle ??
                    "Authentication",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                AppLocalizations.of(context)?.currentlyLoggedInAs(user.email) ??
                    "Currently logged in as: ${user.email}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()));
                },
                child: SizedBox(
                  width: min(0.5 * MediaQuery.of(context).size.width, 150),
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)?.changeYourPasswordLabel ??
                            "Change password"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: () {
                  context.read<DeleteUserBloc>().add(DeleteUserStarted(user));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeleteUserPage()));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.error),
                  textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                            fontWeight: FontWeight.w500,
                          )),
                ),
                child: SizedBox(
                  width: min(0.5 * MediaQuery.of(context).size.width, 150),
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)?.deleteUserButtonLabel ??
                            "Delete your account"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _textUserData(BuildContext context, String label,
          TextEditingController controller, String? Function(String?) validator,
          {Widget? prefix}) =>
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 175),
        child: isDataBeingEdited
            ? SizedBox(
                key: ValueKey<bool>(isDataBeingEdited),
                width: 0.42 * MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: controller,
                  enabled: isDataBeingEdited,
                  validator: validator,
                  decoration: InputDecoration(
                    prefix: prefix,
                    suffixIcon: const Icon(
                      Icons.edit,
                    ),
                    label: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            : SizedBox(
                key: ValueKey<bool>(isDataBeingEdited),
                width: 0.42 * MediaQuery.of(context).size.width,
                child: Semantics(
                  label: "$label, ${controller.text}",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(125),
                        ),
                      ),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        controller.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(125),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );

  Widget _editingButtons(BuildContext context, AppUser user, Function() onSave,
      Function() onCancel) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: FilledButton(
              onPressed: onSave,
              child: Container(
                width: 0.3 * MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxWidth: 140),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.saveChanges ?? "Save changes",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: animation.value,
            child: OutlinedButton(
              onPressed: onCancel,
              child: Container(
                width: 0.3 * MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxWidth: 140),
                child: Center(
                  child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
