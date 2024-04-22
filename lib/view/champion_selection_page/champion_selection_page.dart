import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/search/impl_search_delegate.dart';

class ChampionSelectionPage extends StatefulWidget {
  final ChampionRepository championRepository;
  const ChampionSelectionPage({super.key, required this.championRepository});

  @override
  State<ChampionSelectionPage> createState() => _ChampionSelectionPageState();
}

class _ChampionSelectionPageState extends State<ChampionSelectionPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.championRepository.getAllChampionIds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<String> championsId = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: ImplSearchDelegate(
                              searchable: championsId,
                              textController: _textController));
                    },
                    icon: const Icon(Icons.search))
              ],
              title: const Text("Choose a champion"),
            ),
            body: _buildChampionsGrid(championsId: championsId),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _buildChampionsGrid({required List<String> championsId}) =>
      GridView.builder(
          itemCount: championsId.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisExtent: 200),
          itemBuilder: (context, index) => ChampionButton(
              championId: championsId[index],
              championRepository: widget.championRepository),);
}
