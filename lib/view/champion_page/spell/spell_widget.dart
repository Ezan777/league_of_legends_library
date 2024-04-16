import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/passive.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_info.dart';
import 'package:league_of_legends_library/view/champion_page/spell/spell_selector.dart';

class SpellWidget extends StatefulWidget {
  final Champion champion;
  final ValueNotifier<Passive> chosenAbility;

  SpellWidget({super.key, required this.champion})
      : chosenAbility = ValueNotifier(champion.passive);

  @override
  State<SpellWidget> createState() => _SpellWidgetState();
}

class _SpellWidgetState extends State<SpellWidget> {
  @override
  Widget build(BuildContext context) {
    widget.chosenAbility.addListener(() {
      setState(() {});
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
                ability: widget.chosenAbility.value),
          ),
        ),
      ],
    );
  }
}
