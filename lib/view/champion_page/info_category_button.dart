import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoCategoryButton extends StatefulWidget {
  final ValueNotifier<InfoCategory> chosenCategory;
  final InfoCategory category;
  const InfoCategoryButton(
      {super.key, required this.chosenCategory, required this.category});

  @override
  State<InfoCategoryButton> createState() => _InfoCategoryButtonState();
}

class _InfoCategoryButtonState extends State<InfoCategoryButton> {
  @override
  Widget build(BuildContext context) {
    bool isChosen = widget.chosenCategory.value == widget.category;

    /* widget.chosenCategory.addListener(() {
      setState(() {});
    }); */

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 175),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: _buildButton(isChosen: isChosen, context: context),
    );
  }

  Widget _buildButton({required bool isChosen, required BuildContext context}) {
    if (isChosen) {
      return Container(
        key: const ValueKey("ChosenCategoryButton"),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
        ),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              widget.chosenCategory.value = widget.category;
            });
          },
          child: Text(
            widget.category.getLocalizedDisplayName(context),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      );
    } else {
      return Container(
        key: const ValueKey("UnchosenCategoryButton"),
        decoration: const BoxDecoration(
          color: null,
        ),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              widget.chosenCategory.value = widget.category;
            });
          },
          child: Text(
            widget.category.getLocalizedDisplayName(context),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      );
    }
  }
}

enum InfoCategory {
  lore("Lore"),
  abilities("Spells"),
  tips("Tips");

  const InfoCategory(this.name);

  final String name;

  String getLocalizedDisplayName(BuildContext context) => switch (this) {
        InfoCategory.lore => AppLocalizations.of(context)?.loreLabel ?? name,
        InfoCategory.abilities =>
          AppLocalizations.of(context)?.spellsLabel ?? name,
        InfoCategory.tips => AppLocalizations.of(context)?.tipsLabel ?? name,
      };

  @override
  String toString() => name;
}
