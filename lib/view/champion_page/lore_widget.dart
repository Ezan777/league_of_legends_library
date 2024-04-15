import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';

class LoreWidget extends StatefulWidget {
  final Champion champion;
  const LoreWidget({super.key, required this.champion});

  @override
  State<LoreWidget> createState() => _LoreWidgetState();
}

class _LoreWidgetState extends State<LoreWidget> {
  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30.0, verticalPadding = 22.0;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: _buildLoreText(context: context, champion: widget.champion),
    );
  }

  Widget _buildLoreText(
          {required BuildContext context, required Champion champion}) =>
      Text(
        champion.lore,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      );
}
