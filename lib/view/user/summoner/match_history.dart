import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_state.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_state.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/participant.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';

class MatchHistory extends StatelessWidget {
  const MatchHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummonerBloc, SummonerState>(
      builder: (context, summonerState) => switch (summonerState) {
        SummonerLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        SummonerError() => const GenericErrorView(),
        SummonerSuccess() => BlocBuilder<MatchHistoryBloc, MatchHistoryState>(
            builder: (context, matchesState) => switch (matchesState) {
              MatchHistoryLoading() => const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              MatchHistoryError() => const GenericErrorView(),
              MatchHistoryLoaded() =>
                _buildView(context, summonerState.summoner.puuid, matchesState),
            },
          ),
      },
    );
  }

  Widget _buildView(
      BuildContext context, String summonerPuuid, MatchHistoryLoaded state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < state.matches.length) {
          final participant = state.matches[index].participants
              .firstWhere((participant) => participant.puuid == summonerPuuid);
          return _buildMatchBanner(context, participant);
        } else {
          return null;
        }
      }),
    );
  }

  Widget _buildMatchBanner(BuildContext context, Participant participant) {
    final maxWidth = 0.85 * MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            // Champion Tile
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Summoner's name and spells
            Padding(
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
                            child: CachedNetworkImage(
                                imageUrl: summonerSpellIconUri),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // KDA and CS
            Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  Text(
                    "${participant.kills}/${participant.deaths}/${participant.assists}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    "${participant.minionsKilled.toString()} CS",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15,
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
            // Gold earned
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: Colors.yellow.shade800,
                    ),
                text: "${(participant.goldEarned / 1000).toStringAsFixed(1)} k",
                children: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 0.01 * maxWidth,
                  )),
                  WidgetSpan(
                    child: Icon(
                      Icons.paid_outlined,
                      color: Colors.yellow.shade800,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
