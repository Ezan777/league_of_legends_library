import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/passive.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/spell.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/errors/image_not_available.dart';

class SpellButton extends StatelessWidget {
  final Passive ability;
  final ValueNotifier<Passive> chosenAbility;

  const SpellButton(
      {super.key, required this.ability, required this.chosenAbility});

  @override
  Widget build(BuildContext context) {
    chosenAbility.addListener(() {
      if (chosenAbility.value == ability) {
        Scrollable.ensureVisible(context);
      }
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: _buildButton(
          isChosen: chosenAbility.value == ability, context: context),
    );
  }

  Widget _buildButton({required bool isChosen, required BuildContext context}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () {
              chosenAbility.value = ability;
            },
            child: Semantics(
              label: ability.name,
              selected: isChosen,
              child: CachedNetworkImage(
                imageUrl: ability is Spell
                    ? ChampionRepository.getSpellTileUrl(
                        spellId: (ability as Spell).id)
                    : ability.tileUrl ?? "",
                placeholder: ((context, url) =>
                    const CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => const ImageNotAvailable(),
                height: 64,
                width: 64,
              ),
            ),
          ),
        ),
        if (isChosen)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 10,
              width: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
