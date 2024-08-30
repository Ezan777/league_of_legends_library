import 'dart:math';

import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/summoner.dart';
import 'package:league_of_legends_library/view/user/summoner/rank_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:text_scroll/text_scroll.dart';

class RankSelector extends StatefulWidget {
  final Summoner summoner;
  final ValueNotifier<QueueType> selectedQueue;

  const RankSelector(
      {super.key, required this.summoner, required this.selectedQueue});

  @override
  State<RankSelector> createState() => _RankSelectorState();
}

class _RankSelectorState extends State<RankSelector> {
  @override
  Widget build(BuildContext context) {
    buttonLabel(QueueType queueType) => TextScroll(
          queueType == QueueType.soloDuo
              ? AppLocalizations.of(context)?.rankedSoloLabel ?? "Ranked Solo"
              : AppLocalizations.of(context)?.rankedFlexLabel ?? "Ranked Flex",
          velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
          pauseBetween: const Duration(milliseconds: 1600),
          selectable: false,
          intervalSpaces: 5,
          numberOfReps: 3,
          mode: TextScrollMode.endless,
        );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: QueueType.values
              .map((queueType) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: SizedBox(
                      width: min(0.4 * MediaQuery.of(context).size.width, 150),
                      child: queueType == widget.selectedQueue.value
                          ? FilledButton.icon(
                              onPressed: () {
                                widget.selectedQueue.value = queueType;
                              },
                              icon: Icon(queueType == QueueType.soloDuo
                                  ? Icons.person
                                  : Icons.group),
                              label: buttonLabel(queueType),
                            )
                          : OutlinedButton.icon(
                              onPressed: () {
                                widget.selectedQueue.value = queueType;
                              },
                              icon: Icon(queueType == QueueType.soloDuo
                                  ? Icons.person
                                  : Icons.group),
                              label: buttonLabel(queueType),
                            ),
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

  Widget _buildRankContainer(BuildContext context) =>
      widget.selectedQueue.value == QueueType.soloDuo
          ? RankContainer(
              key: Key(widget.selectedQueue.value.name),
              rank: widget.summoner.ranks[widget.selectedQueue.value],
              onSwipeRight: () {
                widget.selectedQueue.value = QueueType.flex;
              })
          : RankContainer(
              key: Key(widget.selectedQueue.value.name),
              rank: widget.summoner.ranks[widget.selectedQueue.value],
              onSwipeLeft: () {
                widget.selectedQueue.value = QueueType.soloDuo;
              },
            );
}
