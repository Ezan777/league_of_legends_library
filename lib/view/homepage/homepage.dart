import 'package:flutter/material.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_button.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';


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
            _buildFavoritesChampion(
                championsId: appModel.championRepository.favoritesChampions),
          ],
        ),
      );

  Widget _buildFavoritesChampion({required List<String> championsId}) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 17), child: 
            Text("Your Favorites", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),),),
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
