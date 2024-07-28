import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/rank.dart';

class RankContainer extends StatelessWidget {
  final Rank rank;
  const RankContainer({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    final bool isTierWithRank = rank.tier != "Master" &&
        rank.tier != "Grandmaster" &&
        rank.tier != "Challenger";
    String containerLabel = "";

    if (rank.queueType == QueueType.soloDuo) {
      containerLabel = "Solo/Duo";
    } else if (rank.queueType == QueueType.flex) {
      containerLabel = "Flex";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      constraints: const BoxConstraints(maxHeight: 320, maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  containerLabel,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: rank.tierIconUri,
            width: 164,
            height: 164,
          ),
          Text(
            rank.tier + (isTierWithRank ? " ${rank.rank}" : ""),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          Text(
            "${rank.leaguePoints} LP",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          )
        ],
      ),
    );
  }
}
