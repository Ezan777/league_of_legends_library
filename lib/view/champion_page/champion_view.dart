import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/champion_page/champion_banner.dart';
import 'package:league_of_legends_library/view/champion_page/category_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChampionView extends StatefulWidget {
  final Champion champion;
  final int skinCode;

  const ChampionView(
      {super.key, required this.champion, required this.skinCode});

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
                    skinCode: widget.skinCode,
                  ),
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
            tooltip: isFavorite
                ? (AppLocalizations.of(context)?.removeFromFavoritesTooltip ??
                    "Remove from favorites")
                : (AppLocalizations.of(context)?.addToFavoriteTooltip ??
                    "Add to favorites"),
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
