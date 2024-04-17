import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/passive.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_button.dart';

class SpellSelector extends StatefulWidget {
  final Champion champion;
  final ValueNotifier<Passive> chosenAbility;

  const SpellSelector(
      {super.key, required this.champion, required this.chosenAbility});

  @override
  State<SpellSelector> createState() => _SpellSelectorState();
}

class _SpellSelectorState extends State<SpellSelector> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: widget.champion.spells.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SpellButton(
              ability: widget.champion.passive,
              chosenAbility: widget.chosenAbility);
        } else {
          return SpellButton(
            ability: widget.champion.spells[index - 1],
            chosenAbility: widget.chosenAbility,
          );
        }
      },
      separatorBuilder: (context, index) =>
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
    );
  }
}
