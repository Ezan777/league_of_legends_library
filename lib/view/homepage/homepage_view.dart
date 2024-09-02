import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_bloc.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_event.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_state.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/errors/connection_unavailable_view.dart';
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
      body: BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
          builder: (context, recentlyViewedState) =>
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favoritesState) => recentlyViewedState
                            is RecentlyViewedNoConnection ||
                        favoritesState is FavoritesNoConnection
                    ? ConnectionUnavailableView(retryCallback: () {
                        context
                            .read<RecentlyViewedBloc>()
                            .add(RecentlyViewedStarted());
                        context.read<FavoritesBloc>().add(FavoritesStarted());
                      })
                    : CustomScrollView(
                        slivers: [
                          _recentlyViewedTitle(context),
                          _recentlyViewed(context, recentlyViewedState),
                          _favoritesTitle(context),
                          _favoritesView(context, favoritesState),
                        ],
                      ),
              )),
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

  Widget _recentlyViewed(BuildContext context, RecentlyViewedState state) =>
      switch (state) {
        RecentlyViewedLoaded() => SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: Container(
                height: 0.35 * MediaQuery.of(context).size.height,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: state.recentlyViewedChampions.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5)),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recentlyViewedChampions.length,
                        itemBuilder: (context, index) => ChampionCard(
                            champion:
                                state.recentlyViewedChampions.toList()[index]),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)?.noRecentlyViewed ??
                                  "No recently viewed champions.",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: FilledButton(
                              onPressed: () {
                                context.read<NavigationBloc>().add(
                                    const SetNavigationPage(
                                        BodyPages.championPage));
                              },
                              child: Text(AppLocalizations.of(context)
                                      ?.seeAllChampionsLabel ??
                                  "See all champions"),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        RecentlyViewedLoading() => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        RecentlyViewedError() => SliverToBoxAdapter(
            child: Center(
              child: Text(AppLocalizations.of(context)?.errorRecentlyViewed ??
                  "Error while loading recently viewed champions, please try again"),
            ),
          ),
        RecentlyViewedNoConnection() => SliverToBoxAdapter(
            child: Column(
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 120,
                ),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<RecentlyViewedBloc>(context)
                          .add(RecentlyViewedStarted());
                    },
                    child: Text(
                        AppLocalizations.of(context)?.retryButton ?? "Retry")),
              ],
            ),
          ),
      };

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

  Widget _favoritesView(BuildContext context, FavoritesState state) =>
      switch (state) {
        FavoritesLoaded() => state.favoriteChampions.isNotEmpty
            ? SliverGrid.builder(
                itemCount: state.favoriteChampions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => ChampionButton(
                    championId: state.favoriteChampions[index].id,
                    championRepository: appModel.championRepository),
              )
            : SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(AppLocalizations.of(context)
                            ?.noFavoritesSaved ??
                        "No favorites champion found. To save a champion as a favorite one tap on the heart icon that you can find in the champion page."),
                  ),
                ),
              ),
        FavoritesLoading() => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        FavoritesError() => SliverToBoxAdapter(
            child: Center(
              child: Text(AppLocalizations.of(context)?.errorFavorites ??
                  "Error while loading favorites champions, please try again"),
            ),
          ),
        FavoritesNoConnection() => SliverToBoxAdapter(
            child: Column(
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 120,
                ),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<FavoritesBloc>(context)
                          .add(FavoritesStarted());
                    },
                    child: Text(
                        AppLocalizations.of(context)?.retryButton ?? "Retry")),
              ],
            ),
          ),
      };
}
