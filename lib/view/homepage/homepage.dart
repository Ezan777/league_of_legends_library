import 'package:flutter/material.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';
import 'package:league_of_legends_library/view/homepage/favorites_view.dart';
import 'package:league_of_legends_library/view/homepage/recently_viewed_view.dart';

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

  // TODO: Add a custom sliver list to homepage to improve scrolling
  Widget _buildHomePage() => Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("League of Legends library"),
        ),
        body: const Column(
          children: [
            RecentlyViewedView(),
            FavoritesView(),
          ],
        ),
      );
}
