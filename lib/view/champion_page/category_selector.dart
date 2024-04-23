import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/champion_page/info_category_button.dart';
import 'package:league_of_legends_library/view/champion_page/lore_widget.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_widget.dart';
import 'package:league_of_legends_library/view/champion_page/tips_widget.dart';

/// This widget lets the user choose what information of the champions he likes to view
class CategorySelector extends StatefulWidget {
  final Champion champion;

  const CategorySelector({super.key, required this.champion});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  // FIXME In some languages the info button overflows
  final ValueNotifier<InfoCategory> _chosenCategory =
      ValueNotifier(InfoCategory.lore);

  @override
  Widget build(BuildContext context) {
    _chosenCategory.addListener(() {
      setState(() {});
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildCategoriesButton(),
        ),
        _buildInfoView(),
      ],
    );
  }

  List<Widget> _buildCategoriesButton() => InfoCategory.values
      .map((category) => InfoCategoryButton(
          chosenCategory: _chosenCategory, category: category))
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
          child: switch (_chosenCategory.value) {
            InfoCategory.lore => LoreWidget(champion: widget.champion),
            InfoCategory.abilities => SpellWidget(
                champion: widget.champion,
              ),
            InfoCategory.tips => TipsWidget(
                champion: widget.champion,
              ),
          },
        ),
      );
}
