import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/champion.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/passive.dart';
import 'package:league_of_legends_library/view/champion_page/info_category_button.dart';
import 'package:league_of_legends_library/view/champion_page/lore_widget.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_widget.dart';
import 'package:league_of_legends_library/view/champion_page/tips_widget.dart';

class CategorySelector extends StatefulWidget {
  final Champion champion;

  const CategorySelector({super.key, required this.champion});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final ValueNotifier<InfoCategory> chosenCategory =
      ValueNotifier(InfoCategory.lore);
  Passive? _lastSpellChosen;

  @override
  Widget build(BuildContext context) {
    chosenCategory.addListener(() {
      setState(() {});
    });

    return Column(
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 5,
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          children: _buildCategoriesButton(),
        ),
        _buildInfoView(),
      ],
    );
  }

  List<Widget> _buildCategoriesButton() => InfoCategory.values
      .map((category) => InfoCategoryButton(
          chosenCategory: chosenCategory, category: category))
      .toList();

  Widget _buildInfoView() => Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 10),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .animate(animation),
              child: child,
            ),
          ),
          child: switch (chosenCategory.value) {
            InfoCategory.lore => LoreWidget(
                champion: widget.champion,
                onSwipeRight: _nextCategory,
                onSwipeLeft: _previousCategory,
              ),
            InfoCategory.abilities => SpellWidget(
                champion: widget.champion,
                onSwipeLeft: _previousCategory,
                onSwipeRight: _nextCategory,
                onSpellChange: _onNewSpellChosen,
                chosenSpell: _lastSpellChosen,
              ),
            InfoCategory.tips => TipsWidget(
                champion: widget.champion,
                onSwipeLeft: _previousCategory,
                onSwipeRight: _nextCategory,
              ),
          },
        ),
      );

  void _nextCategory(InfoCategory widgetCategory) {
    if (InfoCategory.values.last != widgetCategory) {
      chosenCategory.value =
          InfoCategory.values[InfoCategory.values.indexOf(widgetCategory) + 1];
    }
  }

  void _previousCategory(InfoCategory widgetCategory) {
    if (InfoCategory.values.first != widgetCategory) {
      chosenCategory.value =
          InfoCategory.values[InfoCategory.values.indexOf(widgetCategory) - 1];
    }
  }

  void _onNewSpellChosen(Passive newSpell) {
    _lastSpellChosen = newSpell;
  }
}
