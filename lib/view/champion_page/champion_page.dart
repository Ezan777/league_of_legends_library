import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_page/champion_banner.dart';
import 'package:league_of_legends_library/view/champion_page/category_selector.dart';

class ChampionPage extends StatefulWidget {
  final ChampionRepository championRepository;
  final Champion champion;

  const ChampionPage(
      {super.key, required this.championRepository, required this.champion});

  @override
  State<ChampionPage> createState() => _ChampionPageState();
}

class _ChampionPageState extends State<ChampionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.champion.name),
        actions: [
          IconButton(
              onPressed: () async {
                final bool isSuccess;
                if (widget.champion.isFavorite) {
                  isSuccess = await appModel.championRepository
                      .removeFavoriteChampion(championId: widget.champion.id);
                  if (isSuccess) {
                    widget.champion.isFavorite = false;
                  }
                } else {
                  isSuccess = await appModel.championRepository
                      .setFavoriteChampion(championId: widget.champion.id);
                  if (isSuccess) {
                    widget.champion.isFavorite = true;
                  }
                }

                if (!isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text("An error occurred"),
                      ),
                    ),
                  );
                }
                setState(() {});
              },
              icon: Icon(
                widget.champion.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Center(
              child: Column(
                children: [
                  ChampionBanner(
                      champion: widget.champion,
                      championRepository: widget.championRepository),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 12, right: 12),
                    child: CategorySelector(
                      champion: widget.champion,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
