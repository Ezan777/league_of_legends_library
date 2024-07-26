import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummonerView extends StatelessWidget {
  const SummonerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummonerBloc, SummonerState>(
      builder: (context, state) => switch (state) {
        SummonerLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        SummonerSuccess() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    FilledButton(
                      onPressed: () {
                        context.read<UserBloc>().add(LogoutButtonPressed());
                      },
                      child: Text(
                          AppLocalizations.of(context)?.logout ?? "Logout"),
                    ),
                    Text(state.summoner.name),
                  ] +
                  state.summoner.ranks.map((rank) => Text(rank.tier)).toList(),
            ),
          ),
        SummonerError() => Center(
            child: Text(state.error?.toString() ?? "Error"),
          ),
      },
    );
  }
}
