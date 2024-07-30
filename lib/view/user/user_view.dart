import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_event.dart';
import 'package:league_of_legends_library/bloc/user/login/login_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/data/riot_api.dart';
import 'package:league_of_legends_library/view/user/auth/login_view.dart';
import 'package:league_of_legends_library/view/user/summoner/summoner_view.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.read<UserBloc>().add(UserStarted());
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLogged) {
              context.read<SummonerBloc>().add(SummonerStarted(
                  state.appUser.summonerName,
                  state.appUser.tagLine,
                  RiotServer.fromServerCode(state.appUser.serverCode)));
            }
          },
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => switch (state) {
          UserLoading() || UpdatingUserData() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserLogged() => const SummonerView(),
          NoUserLogged() => const LoginView(),
          UserError() => Center(
              child: Text(state.error.toString()),
            ),
        },
      ),
    );
  }
}
