import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/data/server.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/search/no_result_widget.dart';

class SuggestionOrSearchResult extends StatelessWidget {
  final List<String> searchable;
  final String query;
  final TextEditingController textController;

  const SuggestionOrSearchResult(
      {super.key,
      required this.searchable,
      required this.query,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = query.isEmpty
        ? searchable
        : searchable
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (suggestions.isEmpty) return const NoResultWidget();

    if (query != "") {
      suggestions.sort((a, b) => a
          .toLowerCase()
          .indexOf(query.toLowerCase())
          .compareTo(b.toLowerCase().indexOf(query.toLowerCase())));
    }

    return GridView.builder(
        itemCount: suggestions.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: ((context, index) => ChampionButton(
            championId: suggestions[index],
            championRepository:
                ChampionRepository(remoteDataSource: Server()))));
  }
}
