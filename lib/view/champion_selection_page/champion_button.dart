import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:league_of_legends_library/view/champion_page/champion_page.dart';

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
    return FutureBuilder(
        future: widget.championRepository
            .getChampionById(championId: widget.championId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Champion champion = snapshot.data!;

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChampionPage(
                        champion: champion,
                        championRepository: widget.championRepository)));
              },
              child: _buildChampionColumn(champion: champion, context: context),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildChampionColumn(
          {required Champion champion, required BuildContext context}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChampionTile(),
          const Padding(padding: EdgeInsets.all(5)),
          _buildNameText(champion: champion, context: context),
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
          child: CachedNetworkImage(
            imageUrl: widget.championRepository
                .getChampionTileUrl(championId: widget.championId),
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
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      );
}
