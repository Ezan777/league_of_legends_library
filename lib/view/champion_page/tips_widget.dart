import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipsWidget extends StatelessWidget {
  final Champion champion;

  const TipsWidget({super.key, required this.champion});

  @override
  Widget build(BuildContext context) {
    if (champion.allyTips.isEmpty && champion.enemyTips.isEmpty) {
      return const Center(
        child: Text("No tips available."),
      );
    }

    return Column(
      children: [
        // Build ally tips
        if (champion.allyTips.isNotEmpty)
          _buildTipsContainer(
              context: context,
              tips: champion.allyTips,
              title: AppLocalizations.of(context)
                      ?.playingAsChampion(champion.name) ??
                  "Playing as ${champion.name}:",
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              textColor: Theme.of(context).colorScheme.onTertiaryContainer),
        const Padding(padding: EdgeInsets.only(top: 20)),
        // Build enemy tips
        if (champion.enemyTips.isNotEmpty)
          _buildTipsContainer(
              context: context,
              tips: champion.enemyTips,
              title: AppLocalizations.of(context)
                      ?.playingAgainstChampion(champion.name) ??
                  "Playing against ${champion.name}",
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              textColor: Theme.of(context).colorScheme.onErrorContainer),
      ],
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
