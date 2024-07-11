import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/champion_page/info_category_button.dart';

class LoreWidget extends StatefulWidget {
  final Champion champion;
  final InfoCategory category = InfoCategory.lore;
  final Function(InfoCategory) onSwipeRight, onSwipeLeft;
  const LoreWidget(
      {super.key,
      required this.champion,
      required this.onSwipeRight,
      required this.onSwipeLeft});

  @override
  State<LoreWidget> createState() => _LoreWidgetState();
}

class _LoreWidgetState extends State<LoreWidget> {
  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30.0, verticalPadding = 22.0;
    double? nStartX, nStartY;

    return GestureDetector(
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
              widget.onSwipeRight(widget.category);
            }

            if (endX > startX) {
              widget.onSwipeLeft(widget.category);
            }
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: _buildLoreText(context: context, champion: widget.champion),
      ),
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
