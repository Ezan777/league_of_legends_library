import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/rank.dart';
import 'package:league_of_legends_library/view/user/summoner/rank_container.dart';

class RankSelector extends StatefulWidget {
  final List<Rank> ranks;

  const RankSelector({super.key, required this.ranks});

  @override
  State<RankSelector> createState() => _RankSelectorState();
}

class _RankSelectorState extends State<RankSelector> {
  late final ValueNotifier<Rank> selectedRank =
      ValueNotifier(widget.ranks.first);

  @override
  Widget build(BuildContext context) {
    final ranks = widget.ranks;
    selectedRank.addListener(
      () {
        setState(() {});
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
                    child: rank == selectedRank.value
                        ? FilledButton.icon(
                            onPressed: () {
                              selectedRank.value = rank;
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
                              selectedRank.value = rank;
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
          child: _buildRankContainer(),
        ),
      ],
    );
  }

  Widget _buildRankContainer() {
    final ranks = widget.ranks;
    RankContainer rankContainer;

    if (ranks.length == 1) {
      rankContainer = RankContainer(rank: selectedRank.value);
    } else {
      rankContainer = selectedRank.value.queueType == QueueType.soloDuo
          ? RankContainer(
              key: Key(selectedRank.value.queueType.name),
              rank: selectedRank.value,
              onSwipeRight: () {
                selectedRank.value = ranks.last;
              })
          : RankContainer(
              key: Key(selectedRank.value.queueType.name),
              rank: selectedRank.value,
              onSwipeLeft: () {
                selectedRank.value = ranks.first;
              },
            );
    }

    return rankContainer;
  }
}
