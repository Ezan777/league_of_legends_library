import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class ChampionBanner extends StatefulWidget {
  final String basePath = "assets/";
  final Champion champion;
  final ChampionRepository championRepository;
  const ChampionBanner(
      {super.key, required this.championRepository, required this.champion});

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
          _buildChampionTile(),
          _buildNameText(champion: champion, context: context),
          _buildTitleText(champion: champion, context: context),
        ],
      );

  Widget _buildChampionTile() => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            widget.championRepository
                .getChampionTileUrl(championId: widget.champion.id),
            height: 140,
            width: 140,
          ),
        ),
      );

  Widget _buildNameText(
          {required Champion champion, required BuildContext context}) =>
      Text(
        champion.name,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      );
}
