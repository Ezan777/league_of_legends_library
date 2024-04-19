import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/champion_page/champion_banner.dart';
import 'package:league_of_legends_library/view/champion_page/category_selector.dart';

class ChampionView extends StatefulWidget {
  final ChampionRepository championRepository;
  final Champion champion;

  const ChampionView(
      {super.key, required this.championRepository, required this.champion});

  @override
  State<ChampionView> createState() => _ChampionViewState();
}

class _ChampionViewState extends State<ChampionView> {
  @override
  Widget build(BuildContext context) {
    context
        .read<RecentlyViewedBloc>()
        .add(AddChampionToRecentlyViewed(widget.champion));

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(widget.champion.name),
        actions: [
          _buildFavoriteButton(),
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

  Widget _buildFavoriteButton() =>
      BlocBuilder<FavoritesBloc, FavoritesState>(builder: (context, state) {
        if (state is FavoritesLoaded) {
          bool isFavorite = state.favoriteChampions.contains(widget.champion);
          return IconButton(
            onPressed: () {
              if (isFavorite) {
                context.read<FavoritesBloc>().add(RemovedChampionFromFavorites(
                    removedChampion: widget.champion));
              } else {
                context.read<FavoritesBloc>().add(
                    AddedChampionToFavorites(addedChampion: widget.champion));
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      });
}
