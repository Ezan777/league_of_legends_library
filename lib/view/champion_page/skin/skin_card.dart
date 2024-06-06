import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_event.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/skin.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkinCard extends StatelessWidget {
  final Champion champion;
  final Skin skin;

  const SkinCard({super.key, required this.champion, required this.skin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkinsBloc, SkinState>(
      builder: (context, state) => switch (state) {
        SkinsLoaded() => GestureDetector(
            onTap: () {
              context.read<SkinsBloc>().add(AddSkinToChampion(champion, skin));
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Container(
                height: 0.3 * MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(26)),
                  border: (state.championIdActiveSkin[champion.id] ?? 0) ==
                          skin.skinCode
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 6)
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: ChampionRepository.getFullChampionImageUrl(
                            championId: champion.id, skinCode: skin.skinCode),
                        progressIndicatorBuilder: (context, string, _) =>
                            const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                skin.name != "default"
                                    ? skin.name
                                    : champion.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              if ((state.championIdActiveSkin[champion.id] ??
                                      0) ==
                                  skin.skinCode)
                                Text(
                                  "(${AppLocalizations.of(context)?.inUseSkin ?? "(In use)"})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SkinsLoading() => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
        SkinsError() => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)?.skinsError ??
                  "Unable to load champion skins, please try again"),
            ),
          )
      },
    );
  }
}
