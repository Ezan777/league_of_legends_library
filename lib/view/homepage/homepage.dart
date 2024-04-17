import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_page/champion_page.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';
import 'package:league_of_legends_library/view/homepage/carousel.dart';

enum BodyPages {
  homepage,
  championPage,
  settings,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPages _navigationIndex = BodyPages.homepage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Champions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (index) {
          setState(() {
            _navigationIndex = BodyPages.values[index];
          });
        },
        currentIndex: _navigationIndex.index,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() => switch (_navigationIndex) {
        BodyPages.homepage => _buildHomePage(),
        BodyPages.championPage => ChampionSelectionPage(
            championRepository: appModel.championRepository),
        BodyPages.settings => const Center(
            child: Text("Settings"),
          ),
      };

  Widget _buildHomePage() => Scaffold(
        appBar: AppBar(
          title: const Text("League of Legends library"),
        ),
        body: Column(
          children: [
            _buildRecentlyViewedChampions(
                championsId:
                    appModel.championRepository.recentlyViewedChampions,
                context: context),
            _buildFavoritesChampion(
                championsId: appModel.championRepository.favoritesChampions,
                context: context),
          ],
        ),
      );

  Widget _buildRecentlyViewedChampions(
          {required List<String> championsId, required BuildContext context}) =>
      Column(
        children: [
          Text(
            "Recently viewed",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          FutureBuilder(
            future: appModel.championRepository
                .getChampionsById(championsIds: championsId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: double.maxFinite,
                  height: 250,
                  padding: const EdgeInsets.all(10),
                  child: Carousel(
                    visible: 3,
                    borderRadius: 20,
                    slideAnimationDuration: 500,
                    childClick: (childIndex) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChampionPage(
                              champion: snapshot.data![childIndex],
                              championRepository:
                                  appModel.championRepository)));
                    },
                    children: snapshot.data!
                        .map((champion) => {
                              "image":
                                  ChampionRepository.getFullChampionImageUrl(
                                      championId: champion.id),
                              "title": champion.name
                            })
                        .toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Unable to retrieve recently viewed champions."),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      );

  Widget _buildFavoritesChampion(
          {required List<String> championsId, required BuildContext context}) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                "Your Favorites",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: championsId.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => ChampionButton(
                    championId: championsId[index],
                    championRepository: appModel.championRepository),
              ),
            ),
          ],
        ),
      );
}
