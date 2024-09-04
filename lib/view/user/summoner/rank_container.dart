import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';

class RankContainer extends StatelessWidget {
  final Rank? rank;
  final Function()? onSwipeRight, onSwipeLeft;
  const RankContainer(
      {super.key, required this.rank, this.onSwipeLeft, this.onSwipeRight});

  @override
  Widget build(BuildContext context) {
    if (rank != null) {
      return _rankView(context, rank!);
    } else {
      return _unrankedView(context);
    }
  }

  Widget _rankView(BuildContext context, Rank rank) {
    double? nStartX, nStartY;
    final bool isTierWithRank = rank.tier != "Master" &&
        rank.tier != "Grandmaster" &&
        rank.tier != "Challenger";

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        nStartX = details.localPosition.dx;
        nStartY = details.localPosition.dy;
      },
      onHorizontalDragCancel: () {
        nStartX = null;
        nStartY = null;
      },
      onHorizontalDragEnd: (details) {
        final startX = nStartX;
        final startY = nStartY;
        if (startX != null && startY != null) {
          double endX = details.localPosition.dx,
              endY = details.localPosition.dy;
          int acceptableHorizontalSwipeConstraint = 45,
              acceptableVerticalSwipeConstraint = 175;

          if ((startX - endX).abs() >= acceptableHorizontalSwipeConstraint &&
              (startY - endY).abs() <= acceptableVerticalSwipeConstraint) {
            if (endX < startX) {
              if (onSwipeRight != null) {
                onSwipeRight!();
              }
            }

            if (endX > startX) {
              if (onSwipeLeft != null) {
                onSwipeLeft!();
              }
            }
          }
        }

        nStartX = null;
        nStartY = null;
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: rank.tierIconUri,
              width: 128,
              height: 128,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    rank.tier + (isTierWithRank ? " ${rank.rank}" : ""),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  Text(
                    "${rank.leaguePoints} LP",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
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

  Widget _unrankedView(BuildContext context) {
    double? nStartX, nStartY;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        nStartX = details.localPosition.dx;
        nStartY = details.localPosition.dy;
      },
      onHorizontalDragCancel: () {
        nStartX = null;
        nStartY = null;
      },
      onHorizontalDragEnd: (details) {
        final startX = nStartX;
        final startY = nStartY;
        if (startX != null && startY != null) {
          double endX = details.localPosition.dx,
              endY = details.localPosition.dy;
          int acceptableHorizontalSwipeConstraint = 45,
              acceptableVerticalSwipeConstraint = 175;

          if ((startX - endX).abs() >= acceptableHorizontalSwipeConstraint &&
              (startY - endY).abs() <= acceptableVerticalSwipeConstraint) {
            if (endX < startX) {
              if (onSwipeRight != null) {
                onSwipeRight!();
              }
            }

            if (endX > startX) {
              if (onSwipeLeft != null) {
                onSwipeLeft!();
              }
            }
          }
        }

        nStartX = null;
        nStartY = null;
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45),
          child: Text(
            "Unranked",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ),
    );
  }
}
