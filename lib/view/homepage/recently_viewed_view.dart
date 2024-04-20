import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/homepage/champion_card.dart';

class RecentlyViewedView extends StatelessWidget {
  const RecentlyViewedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _recentlyViewedTitle(context),
        BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
          builder: (context, state) => switch (state) {
            RecentlyViewedLoaded() =>
              _isLoaded(state.recentlyViewedChampions.toList()),
            RecentlyViewedLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RecentlyViewedError() => const Center(
                child: Text("Unable to retrieve recently viewed champions"),
              )
          },
        ),
      ],
    );
  }

  Widget _isLoaded(List<Champion> champions) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: 275,
            child: champions.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5)),
                    scrollDirection: Axis.horizontal,
                    itemCount: champions.length,
                    itemBuilder: (context, index) =>
                        ChampionCard(champion: champions[index]),
                  )
                : const Center(
                    child: Text("No recently viewed champions."),
                  ),
          ),
        ],
      );

  Widget _recentlyViewedTitle(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 17),
        child: Text(
          "Recently viewed",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        ),
      );
}
