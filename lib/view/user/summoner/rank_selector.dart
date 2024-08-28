import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_event.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/summoner.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';
import 'package:league_of_legends_library/view/user/summoner/rank_container.dart';

class RankSelector extends StatefulWidget {
  final Summoner summoner;
  final ValueNotifier<Rank> selectedRank;

  const RankSelector(
      {super.key, required this.summoner, required this.selectedRank});

  @override
  State<RankSelector> createState() => _RankSelectorState();

  void loadMatchHistory(BuildContext context) {
    context.read<MatchHistoryBloc>().add(MatchHistoryStarted(
        RiotRegion.fromServer(RiotServer.fromServerCode(summoner.serverCode))
            .name,
        summoner.puuid,
        selectedRank.value.queueType,
        count: 8));
  }
}

class _RankSelectorState extends State<RankSelector> {
  @override
  Widget build(BuildContext context) {
    final summoner = widget.summoner;
    final ranks = summoner.ranks;

    widget.loadMatchHistory(context);
    widget.selectedRank.addListener(
      () {
        setState(() {});
        widget.loadMatchHistory(context);
      },
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ranks
              .map((rank) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: rank == widget.selectedRank.value
                        ? FilledButton.icon(
                            onPressed: () {
                              widget.selectedRank.value = rank;
                            },
                            icon: Icon(rank.queueType == QueueType.soloDuo
                                ? Icons.person
                                : Icons.group),
                            label: Text(rank.queueType == QueueType.soloDuo
                                ? "Ranked Solo"
                                : "Ranked Flex"),
                          )
                        : OutlinedButton.icon(
                            onPressed: () {
                              widget.selectedRank.value = rank;
                            },
                            icon: Icon(rank.queueType == QueueType.soloDuo
                                ? Icons.person
                                : Icons.group),
                            label: Text(rank.queueType == QueueType.soloDuo
                                ? "Ranked Solo"
                                : "Ranked Flex"),
                          ),
                  ))
              .toList(),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .animate(animation),
              child: child,
            ),
          ),
          child: _buildRankContainer(context),
        ),
      ],
    );
  }

  Widget _buildRankContainer(BuildContext context) {
    final ranks = widget.summoner.ranks;
    RankContainer rankContainer;

    if (ranks.length == 1) {
      rankContainer = RankContainer(rank: widget.selectedRank.value);
    } else {
      rankContainer = widget.selectedRank.value.queueType == QueueType.soloDuo
          ? RankContainer(
              key: Key(widget.selectedRank.value.queueType.name),
              rank: widget.selectedRank.value,
              onSwipeRight: () {
                widget.selectedRank.value = ranks.last;
              })
          : RankContainer(
              key: Key(widget.selectedRank.value.queueType.name),
              rank: widget.selectedRank.value,
              onSwipeLeft: () {
                widget.selectedRank.value = ranks.first;
              },
            );
    }

    return rankContainer;
  }
}
