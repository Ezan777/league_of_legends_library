import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:league_of_legends_library/view/champion_page/champion_view.dart';

class ChampionButton extends StatefulWidget {
  final String championId;
  final ChampionRepository championRepository;
  const ChampionButton(
      {super.key, required this.championId, required this.championRepository});

  @override
  State<ChampionButton> createState() => _ChampionButtonState();
}

class _ChampionButtonState extends State<ChampionButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkinsBloc, SkinState>(
      builder: (context, state) => switch (state) {
        SkinsLoaded() => FutureBuilder(
            future: widget.championRepository
                .getChampionById(championId: widget.championId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Champion champion = snapshot.data!;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChampionView(
                              champion: champion,
                              skinCode:
                                  state.championIdActiveSkin[champion.id] ?? 0,
                            )));
                  },
                  child: _buildChampionColumn(
                      champion: champion,
                      context: context,
                      skinCode:
                          state.championIdActiveSkin[widget.championId] ?? 0),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        SkinsLoading() => const CircularProgressIndicator(),
        SkinsError() => const Center(
            child: Text("Unable to retrieve champion data"),
          )
      },
    );
  }

  Widget _buildChampionColumn(
          {required Champion champion,
          required BuildContext context,
          required int skinCode}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChampionTile(context, skinCode),
          const Padding(padding: EdgeInsets.all(5)),
          _buildNameText(champion: champion, context: context),
        ],
      );

  Widget _buildChampionTile(BuildContext context, int skinCode) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: ChampionRepository.getChampionTileUrl(
                championId: widget.championId, skinCode: skinCode),
            placeholder: (context, url) => const CircularProgressIndicator(),
            height: 90,
            width: 90,
          ),
        ),
      );

  Widget _buildNameText(
          {required Champion champion, required BuildContext context}) =>
      Text(
        champion.name,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      );
}
