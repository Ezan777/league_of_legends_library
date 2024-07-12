import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/passive.dart';
import 'package:league_of_legends_library/core/model/spell.dart';
import 'package:league_of_legends_library/view/champion_page/info_category_button.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_info.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_selector.dart';

class SpellWidget extends StatefulWidget {
  final Champion champion;
  final InfoCategory category = InfoCategory.abilities;
  final Function(InfoCategory) onSwipeRight, onSwipeLeft;
  final ValueNotifier<Passive> chosenAbility;
  final Function(Passive)? onSpellChange;

  SpellWidget(
      {super.key,
      required this.champion,
      required this.onSwipeRight,
      required this.onSwipeLeft,
      this.onSpellChange,
      Passive? chosenSpell})
      : chosenAbility = ValueNotifier(chosenSpell ?? champion.passive);

  @override
  State<SpellWidget> createState() => _SpellWidgetState();
}

class _SpellWidgetState extends State<SpellWidget> {
  @override
  Widget build(BuildContext context) {
    widget.chosenAbility.addListener(() {
      setState(() {});
      final callback = widget.onSpellChange;
      if (callback != null) {
        callback(widget.chosenAbility.value);
      }
    });

    return Column(
      children: [
        SizedBox(
          height: 90,
          child: SpellSelector(
              champion: widget.champion, chosenAbility: widget.chosenAbility),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 275),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
            ),
            child: SpellInfo(
              key: ValueKey(widget.chosenAbility.value.name),
              ability: widget.chosenAbility.value,
              onSwipeRight: _nextSpell,
              onSwipeLeft: _previousSpell,
            ),
          ),
        ),
      ],
    );
  }

  void _nextSpell() {
    final currentSpell = widget.chosenAbility.value;

    if (widget.champion.passive == currentSpell) {
      widget.chosenAbility.value = widget.champion.spells[0];
    } else if (currentSpell != widget.champion.spells.last) {
      widget.chosenAbility.value = widget.champion
          .spells[widget.champion.spells.indexOf(currentSpell as Spell) + 1];
    } else {
      widget.onSwipeRight(widget.category);
    }
  }

  void _previousSpell() {
    final currentSpell = widget.chosenAbility.value;

    if (widget.champion.passive != currentSpell &&
        widget.champion.spells.indexOf(currentSpell as Spell) != 0) {
      widget.chosenAbility.value = widget
          .champion.spells[widget.champion.spells.indexOf(currentSpell) - 1];
    } else if (widget.champion.passive != currentSpell &&
        widget.champion.spells.first == currentSpell) {
      widget.chosenAbility.value = widget.champion.passive;
    } else if (widget.champion.passive == currentSpell) {
      widget.onSwipeLeft(widget.category);
    }
  }
}
