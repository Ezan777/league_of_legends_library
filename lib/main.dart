import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/app_bloc_observer.dart';
import 'package:league_of_legends_library/app_model.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_event.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_state.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_event.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/view/homepage/homepage.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

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
            create: (_) => LanguageBloc(
                settingRepository: appModel.settingRepository)
              ..add(
                LanguageStarted(
                    AvailableLanguages.fromLanguageCode(Platform.localeName)),
              ),
          ),
          BlocProvider(
            create: (_) => FavoritesBloc(
                championRepository: appModel.championRepository,
                language:
                    AvailableLanguages.fromLanguageCode(Platform.localeName))
              ..add(FavoritesStarted()),
          ),
          BlocProvider(
            create: (_) => RecentlyViewedBloc(
                championRepository: appModel.championRepository,
                language:
                    AvailableLanguages.fromLanguageCode(Platform.localeName))
              ..add(RecentlyViewedStarted()),
          ),
          BlocProvider(
            create: (_) => NavigationBloc(),
          ),
          BlocProvider(
            create: (_) =>
                SkinsBloc(championRepository: appModel.championRepository)
                  ..add(SkinsStarted()),
          ),
          BlocProvider(
            create: (_) =>
                ThemeBloc(settingRepository: appModel.settingRepository)
                  ..add(
                    ThemeStarted(),
                  ),
          ),
        ],
        child: BlocListener<LanguageBloc, LanguageState>(
          listener: (context, state) {
            if (state is LanguageLoaded) {
              context
                  .read<RecentlyViewedBloc>()
                  .add(ChangedLanguage(state.language));
              context
                  .read<FavoritesBloc>()
                  .add(ApplicationLanguageChanged(state.language));
            }
          },
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) => MaterialApp(
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
              themeMode: _getTheme(state),
              home: const MyHomePage(title: title),
            ),
          ),
        ),
      ),
    );
  }

  ThemeMode _getTheme(ThemeState state) {
    return state is ThemeLoaded
        ? state.themeMode.toMaterialThemeMode()
        : ThemeMode.system;
  }
}
