import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/errors/connection_unavailable_view.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';
import 'package:league_of_legends_library/view/search/impl_search_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              title: Text(AppLocalizations.of(context)
                      ?.championSelectionPageScaffoldTitle ??
                  "Choose a champion"),
            ),
            body: _buildChampionsGrid(championsId: championsId),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: ImplSearchDelegate(
                          searchable: championsId,
                          textController: _textController));
                },
                child: const Icon(Icons.search)),
          );
        } else if (snapshot.hasError) {
          log("Error: ${snapshot.error.toString()}");
          if (snapshot.error is InternetConnectionUnavailable) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("League of Legends library"),
              ),
              body: ConnectionUnavailableView(retryCallback: () {
                setState(() {});
              }),
            );
          } else {
            return const GenericErrorView();
          }
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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, mainAxisExtent: 200),
        itemBuilder: (context, index) => ChampionButton(
            championId: championsId[index],
            championRepository: widget.championRepository),
      );
}
