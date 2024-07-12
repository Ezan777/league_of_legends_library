import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/view/champion_page/info_category_button.dart';

class TipsWidget extends StatelessWidget {
  final Champion champion;
  final InfoCategory category = InfoCategory.tips;
  final Function(InfoCategory) onSwipeRight, onSwipeLeft;

  const TipsWidget(
      {super.key,
      required this.champion,
      required this.onSwipeLeft,
      required this.onSwipeRight});

  @override
  Widget build(BuildContext context) {
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
              onSwipeRight(category);
            }

            if (endX > startX) {
              onSwipeLeft(category);
            }
          }
        }

        nStartX = null;
        nStartY = null;
      },
      child: champion.allyTips.isNotEmpty && champion.enemyTips.isNotEmpty
          ? Column(
              children: [
                // Build ally tips
                if (champion.allyTips.isNotEmpty)
                  _buildTipsContainer(
                      context: context,
                      tips: champion.allyTips,
                      title: AppLocalizations.of(context)
                              ?.playingAsChampion(champion.name) ??
                          "Playing as ${champion.name}:",
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onTertiaryContainer),
                const Padding(padding: EdgeInsets.only(top: 20)),
                // Build enemy tips
                if (champion.enemyTips.isNotEmpty)
                  _buildTipsContainer(
                      context: context,
                      tips: champion.enemyTips,
                      title: AppLocalizations.of(context)
                              ?.playingAgainstChampion(champion.name) ??
                          "Playing against ${champion.name}",
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      textColor:
                          Theme.of(context).colorScheme.onErrorContainer),
              ],
            )
          : Center(
              child: Text(AppLocalizations.of(context)?.noTipsAvailable ??
                  "No tips available."),
            ),
    );
  }

  Widget _buildTipsContainer(
          {required BuildContext context,
          required List<dynamic> tips,
          Color? backgroundColor,
          Color? textColor,
          required String title}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ] +
                tips
                    .map((tip) => _buildTipRow(tip: tip, textColor: textColor))
                    .toList()),
      );

  Widget _buildTipRow({required String tip, Color? textColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: textColor),
            width: 8,
            height: 8,
          ),
          const Padding(padding: EdgeInsets.only(right: 15)),
          Expanded(
            child: Text(
              tip,
            ),
          ),
        ]),
      );
}
