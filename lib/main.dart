import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/data/server.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = "League library";

    return DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => MaterialApp(
              title: 'League of Legends library',
              theme: ThemeData(
                fontFamily: "BeaufortforLOL",
                colorScheme: lightDynamic ??
                    ColorScheme.fromSeed(
                        seedColor: Colors.greenAccent,
                        brightness: Brightness.light),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkDynamic ??
                    ColorScheme.fromSeed(
                        seedColor: Colors.purple, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system,
              home: const MyHomePage(title: title),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChampionSelectionPage(
        championRepository: ChampionRepository(remoteDataSource: Server()));
  }
}
