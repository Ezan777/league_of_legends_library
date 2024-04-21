import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_page/skin/skin_page.dart';

class ChampionBanner extends StatefulWidget {
  final Champion champion;
  final ChampionRepository championRepository;
  final int skinCode;
  const ChampionBanner(
      {super.key,
      required this.championRepository,
      required this.champion,
      required this.skinCode});

  @override
  State<ChampionBanner> createState() => _ChampionBannerState();
}

class _ChampionBannerState extends State<ChampionBanner> {
  @override
  Widget build(BuildContext context) {
    return _buildChampionColumn(champion: widget.champion, context: context);
  }

  Widget _buildChampionColumn(
          {required Champion champion, required BuildContext context}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChampionTile(context, widget.skinCode),
          _buildNameText(champion: champion, context: context),
          _buildTitleText(champion: champion, context: context),
        ],
      );

  Widget _buildChampionTile(BuildContext context, int skinCode) =>
      BlocBuilder<SkinsBloc, SkinState>(
        builder: (context, state) => switch (state) {
          SkinsLoaded() => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SkinPage(champion: widget.champion),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.championRepository.getChampionTileUrl(
                            championId: widget.champion.id,
                            skinCode: state
                                    .championIdActiveSkin[widget.champion.id] ??
                                0),
                        height: 140,
                        width: 140,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 95,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SkinsLoading() => const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(),
              ),
            ),
          SkinsError() => const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text("Unable to retrieve skin"),
              ),
            )
        },
      );

  Widget _buildNameText(
          {required Champion champion, required BuildContext context}) =>
      Text(
        champion.name,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      );

  Widget _buildTitleText(
          {required Champion champion, required BuildContext context}) =>
      Text(
        champion.title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      );
}
