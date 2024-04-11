import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';

class ChampionSelectionPage extends StatefulWidget {
  final ChampionRepository championRepository;
  const ChampionSelectionPage({super.key, required this.championRepository});

  @override
  State<ChampionSelectionPage> createState() => _ChampionSelectionPageState();
}

class _ChampionSelectionPageState extends State<ChampionSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.championRepository.getAllChampionIds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<String> championsId = snapshot.data!;

          return _buildChampionsGrid(championsId: championsId);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildChampionsGrid({required List<String> championsId}) =>
      GridView.builder(
          itemCount: championsId.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: ((context, index) => ChampionButton(
              championId: championsId[index],
              championRepository: widget.championRepository)));
}
