import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) => switch (state) {
              FavoritesLoaded() => _favoritesLoaded(context, state),
              FavoritesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              FavoritesError() => const Center(
                  child: Text("Error while loading favorites champions"),
                ),
            });
  }

  Widget _favoritesLoaded(BuildContext context, FavoritesLoaded state) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                "Your Favorites",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: state.favoriteChampions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => ChampionButton(
                    championId: state.favoriteChampions[index].id,
                    championRepository: appModel.championRepository),
              ),
            ),
          ],
        ),
      );
}
