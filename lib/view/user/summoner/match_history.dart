import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_event.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_state.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/league_match.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/participant.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/summoner.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchHistory extends StatelessWidget {
  final QueueType queueType;
  final Summoner summoner;
  const MatchHistory(this.summoner, this.queueType, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchHistoryBloc, MatchHistoryState>(
      builder: (context, matchesState) => switch (matchesState) {
        MatchHistoryLoading() => _loading(),
        MatchHistoryError() => SliverToBoxAdapter(
            child: GenericErrorView(
              error: matchesState.error,
              retryCallback: () {
                context.read<MatchHistoryBloc>().add(MatchHistoryStarted(
                    RiotRegion.fromServer(
                            RiotServer.fromServerCode(summoner.serverCode))
                        .name,
                    summoner.puuid));
              },
            ),
          ),
        MatchHistoryLoaded() =>
          _buildView(context, summoner.puuid, matchesState),
      },
    );
  }

  Widget _buildView(
      BuildContext context, String summonerPuuid, MatchHistoryLoaded state) {
    final matches = state.matches[queueType];
    if (matches != null) {
      return _buildList(context, matches, summonerPuuid);
    } else {
      return state.isLoadingOtherMatches
          ? _loading()
          : _noMatchesFound(context);
    }
  }

  Widget _loading() => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );

  Widget _noMatchesFound(BuildContext context) => SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Center(
            child: Text(
              AppLocalizations.of(context)?.noMatchesFound ??
                  "No matches found for this queue.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );

  Widget _buildList(
      BuildContext context, List<LeagueMatch> matches, String summonerPuuid) {
    final winnerColor = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(87, 13, 228, 31)
        : const Color.fromARGB(133, 3, 117, 13);
    final onWinnerColor = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(244, 1, 41, 4)
        : const Color.fromARGB(244, 204, 240, 207);
    final loserColor = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(85, 252, 136, 136)
        : const Color.fromARGB(232, 109, 45, 45);
    final onLoserColor = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(255, 97, 23, 23)
        : const Color.fromARGB(255, 252, 213, 213);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < matches.length) {
          final participant = matches[index]
              .participants
              .firstWhere((participant) => participant.puuid == summonerPuuid);
          return _buildMatchBanner(
            context,
            matches[index],
            summonerPuuid,
            participant.isWinner ? winnerColor : loserColor,
            participant.isWinner ? onWinnerColor : onLoserColor,
          );
        } else {
          return null;
        }
      }, childCount: matches.length),
    );
  }

  Widget _buildMatchBanner(BuildContext context, LeagueMatch match,
      String summonerPuuid, Color containerColor, Color onContainerColor) {
    final maxWidth =
        min(0.9 * MediaQuery.of(context).size.width, 575).toDouble();
    final participant = match.participants
        .firstWhere((participant) => participant.puuid == summonerPuuid);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      padding: const EdgeInsets.all(5),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: onContainerColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                participant.isWinner
                    ? AppLocalizations.of(context)?.wonMatchLabel ?? "WIN"
                    : AppLocalizations.of(context)?.lostMatchLabel ?? "LOSS",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onContainerColor,
                    ),
              ),
              Text(
                match.gameDurationString,
                semanticsLabel: AppLocalizations.of(context)
                        ?.durationSemanticLabel(match.gameDurationString) ??
                    "Duration: ${match.gameDurationString}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onContainerColor,
                    ),
              ),
              Text(
                match.gameCreationDateString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onContainerColor,
                    ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Champion Tile
              _championTile(context, maxWidth, participant),
              // Summoner's spells
              _summonerSpells(maxWidth, participant),
              // KDA and CS
              Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  children: [
                    Text(
                      "${participant.kills}/${participant.deaths}/${participant.assists}",
                      semanticsLabel: AppLocalizations.of(context)
                              ?.kdaSemanticLabel(participant.kills,
                                  participant.deaths, participant.assists) ??
                          "${participant.kills} kills, ${participant.deaths} deaths, ${participant.assists} assists",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: onContainerColor,
                          ),
                    ),
                    Text(
                      "${participant.minionsKilled.toString()} CS",
                      semanticsLabel: AppLocalizations.of(context)
                          ?.minionsKilledSemanticLabel(
                              participant.minionsKilled),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: onContainerColor,
                          ),
                    ),
                  ],
                ),
              ),
              // Items
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: participant.itemsIconUri
                              .sublist(0, 3)
                              .map((itemIconUri) =>
                                  _itemTile(context, maxWidth, itemIconUri))
                              .toList(),
                        ),
                        Row(
                          children: participant.itemsIconUri
                              .sublist(3)
                              .map((itemIconUri) =>
                                  _itemTile(context, maxWidth, itemIconUri))
                              .toList(),
                        ),
                      ],
                    ),
                    _itemTile(context, maxWidth, participant.trinketIconUri),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _championTile(
          BuildContext context, double maxWidth, Participant participant) =>
      Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          width: 0.24 * maxWidth,
          height: 0.25 * maxWidth,
          child: Stack(
            children: [
              Container(
                  width: 0.23 * maxWidth,
                  height: 0.23 * maxWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade900,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: participant.championIconUri),
                  ),
                ),
              Positioned(
                top: 0.19 * maxWidth,
                left: 0.07 * maxWidth,
                child: Container(
                  width: 0.1 * maxWidth,
                  height: 0.06 * maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade900,
                    border: Border.all(
                      color: Colors.yellowAccent.shade700,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      participant.championLevel.toString(),
                      semanticsLabel: "${AppLocalizations.of(context)?.matchBannerChampionTileSemanticLabel(participant.championId) ?? "Playing as: ${participant.championId}"}, ${AppLocalizations.of(context)
                              ?.championLevelSemantic(
                                  participant.championLevel) ??
                          "Level: ${participant.championLevel}"}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _summonerSpells(double maxWidth, Participant participant) => Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: participant.summonerSpellsIconUri
              .map(
                (summonerSpellIconUri) => Padding(
                  padding: const EdgeInsets.all(2),
                  child: SizedBox(
                    width: 0.09 * maxWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(imageUrl: summonerSpellIconUri),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _itemTile(BuildContext context, double maxWidth, String itemIconUri) =>
      Container(
        margin: const EdgeInsets.all(2),
        width: 0.08 * maxWidth,
        height: 0.08 * maxWidth,
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: itemIconUri)),
      );
}
