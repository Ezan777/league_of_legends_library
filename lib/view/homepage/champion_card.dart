import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_page/champion_view.dart';

class ChampionCard extends StatelessWidget {
  final Champion champion;

  const ChampionCard({super.key, required this.champion});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkinsBloc, SkinState>(
      builder: (context, state) => switch (state) {
        SkinsLoaded() => GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChampionView(
                        champion: champion,
                        skinCode: state.championIdActiveSkin[champion.id] ?? 0,
                      )));
            },
            child: SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: ChampionRepository.getFullChampionImageUrl(
                          championId: champion.id,
                          skinCode:
                              state.championIdActiveSkin[champion.id] ?? 0),
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
                        child: Text(
                          champion.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
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
        SkinsError() => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Unable to get champion skin"),
            ),
          )
      },
    );
  }
}
