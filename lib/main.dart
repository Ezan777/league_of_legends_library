import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/app_bloc_observer.dart';
import 'package:league_of_legends_library/app_model.dart';
import 'package:league_of_legends_library/bloc/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites_events.dart';
import 'package:league_of_legends_library/view/homepage/homepage.dart';

late final AppModel appModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appModel = await AppModel.initializeDataSource();
  Bloc.observer = const AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = "League library";

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  FavoritesBloc(championRepository: appModel.championRepository)
                    ..add(FavoritesStarted())),
        ],
        child: MaterialApp(
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
            fontFamily: "BeaufortforLOL",
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                    seedColor: Colors.purple, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: title),
        ),
      ),
    );
  }
}
