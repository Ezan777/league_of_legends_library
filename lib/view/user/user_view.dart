import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/view/user/login_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("League of Legends library"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                context.read<UserBloc>().add(UserStarted());
              }
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) => switch (state) {
            UserLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            UserLogged() => Column(
                children: [
                  Text(state.appUser.name),
                  Text(state.appUser.summonerName),
                  FilledButton(
                      onPressed: () {
                        context.read<UserBloc>().add(LogoutButtonPressed());
                      },
                      child: Text(
                          AppLocalizations.of(context)?.logout ?? "Logout"))
                ],
              ),
            NoUserLogged() => const LoginView(),
            UserError() => Center(
                child: Text(state.error.toString()),
              ),
          },
        ),
      ),
    );
  }
}
