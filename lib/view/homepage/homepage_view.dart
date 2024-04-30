import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/homepage/champion_card.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("League of Legends library"),
      ),
      body: CustomScrollView(
        slivers: [
          _recentlyViewedTitle(context),
          _recentlyViewed(),
          _favoritesTitle(context),
          _favoritesView(),
        ],
      ),
    );
  }

  Widget _recentlyViewedTitle(BuildContext context) => SliverAppBar(
        title: Text(
          AppLocalizations.of(context)?.recentlyViewedTitle ??
              "Recently viewed",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        ),
      );

  Widget _recentlyViewed() =>
      BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
        builder: (context, state) => switch (state) {
          RecentlyViewedLoaded() => SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                height: 275,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.recentlyViewedChampions.length,
                  itemBuilder: (context, index) => ChampionCard(
                      champion: state.recentlyViewedChampions.toList()[index]),
                ),
              ),
            ),
          RecentlyViewedLoading() => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          RecentlyViewedError() => const SliverToBoxAdapter(
              child: Center(
                child: Text("Error while loading favorites champions"),
              ),
            ),
        },
      );

  Widget _favoritesTitle(BuildContext context) => SliverAppBar(
        pinned: true,
        title: Text(
          AppLocalizations.of(context)?.favoritesTitle ?? "Your Favorites",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        ),
      );

  Widget _favoritesView() => BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesLoaded() => SliverGrid.builder(
              itemCount: state.favoriteChampions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) => ChampionButton(
                  championId: state.favoriteChampions[index].id,
                  championRepository: appModel.championRepository),
            ),
          FavoritesLoading() => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          FavoritesError() => const SliverToBoxAdapter(
              child: Center(
                child: Text("Error while loading favorites champions"),
              ),
            ),
        },
      );
}
