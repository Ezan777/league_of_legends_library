import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class ChampionBanner extends StatefulWidget {
  final String basePath = "assets/";
  final String championId;
  final ChampionRepository championRepository;
  const ChampionBanner(
      {super.key, required this.championId, required this.championRepository});

  @override
  State<ChampionBanner> createState() => _ChampionBannerState();
}

class _ChampionBannerState extends State<ChampionBanner> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.championRepository.getChampionById(championId: widget.championId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Champion champion = snapshot.data!;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.championRepository.getChampionTileUrl(championId: widget.championId), height: 160, width: 160,),
                Padding(padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(champion.name, style: Theme.of(context).textTheme.headlineLarge,), Text(champion.title, style: Theme.of(context).textTheme.headlineSmall,)],
                ),),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
