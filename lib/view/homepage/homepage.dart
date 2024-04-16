import 'package:flutter/material.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPage _navigationIndex = BodyPage.homepage;

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
            _navigationIndex = BodyPage.values[index];
          });
        },
        currentIndex: _navigationIndex.index,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() => switch (_navigationIndex) {
        BodyPage.homepage => const Center(
            child: Text("Homepage"),
          ),
        BodyPage.championPage => ChampionSelectionPage(
            championRepository: appModel.championRepository),
        BodyPage.settings => const Center(
            child: Text("Settings"),
          ),
      };
}

enum BodyPage {
  homepage,
  championPage,
  settings,
}
