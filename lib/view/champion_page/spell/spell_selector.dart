import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/spell.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_button.dart';

class SpellSelector extends StatefulWidget {
  final Champion champion;
  final ValueNotifier<Spell> chosenSpell;

  const SpellSelector(
      {super.key, required this.champion, required this.chosenSpell});

  @override
  State<SpellSelector> createState() => _SpellSelectorState();
}

class _SpellSelectorState extends State<SpellSelector> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: widget.champion.spells.length,
      itemBuilder: (context, index) => SpellButton(
        spell: widget.champion.spells[index],
        chosenSpell: widget.chosenSpell,
      ),
      separatorBuilder: (context, index) =>
          const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
    );
  }
}
