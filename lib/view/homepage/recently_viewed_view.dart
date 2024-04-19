import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_page/champion_view.dart';

class RecentlyViewedView extends StatelessWidget {
  const RecentlyViewedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
      builder: (context, state) => switch (state) {
        RecentlyViewedLoaded() =>
          _isLoaded(context, state.recentlyViewedChampions.toList()),
        RecentlyViewedLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        RecentlyViewedError() => const Center(
            child: Text("Unable to retrieve recently viewed champions"),
          )
      },
    );
  }

  Widget _isLoaded(BuildContext context, List<Champion> champions) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: Text(
              "Recently viewed",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: 275,
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              scrollDirection: Axis.horizontal,
              itemCount: champions.length,
              itemBuilder: (context, index) =>
                  _championCard(context, champions[index]),
            ),
          ),
        ],
      );

  Widget _championCard(BuildContext context, Champion champion) =>
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChampionView(
                  champion: champion,
                  championRepository: appModel.championRepository)));
        },
        child: SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: ChampionRepository.getFullChampionImageUrl(
                      championId: champion.id),
                  fit: BoxFit.cover,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      champion.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
