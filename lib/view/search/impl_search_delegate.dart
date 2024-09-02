import 'package:flutter/material.dart';
import 'package:league_of_legends_library/view/search/suggestion_or_search_result.dart';

class ImplSearchDelegate extends SearchDelegate {
  final TextEditingController textController;
  List<String> searchable;

  ImplSearchDelegate({required this.searchable, required this.textController}) {
    textController.addListener(() {
      query = textController.text;
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Manage actions like clearing the search query
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: Icon(Icons.adaptive.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return SuggestionOrSearchResult(
      searchable: searchable,
      query: query,
      textController: textController,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionOrSearchResult(
      searchable: searchable,
      query: query,
      textController: textController,
    );
  }
}
