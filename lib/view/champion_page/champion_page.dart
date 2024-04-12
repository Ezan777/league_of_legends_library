import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_page/champion_banner.dart';
import 'package:league_of_legends_library/view/champion_page/lore_widget.dart';

class ChampionPage extends StatefulWidget {
  final String championId;
  final ChampionRepository championRepository;
  final Champion champion;

  const ChampionPage(
      {super.key,
      required this.championId,
      required this.championRepository,
      required this.champion});

  @override
  State<ChampionPage> createState() => _ChampionPageState();
}

class _ChampionPageState extends State<ChampionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.championId),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Center(
              child: Column(
                children: [
                  ChampionBanner(
                      championId: widget.championId,
                      championRepository: widget.championRepository),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: LoreWidget(champion: widget.champion),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
