import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:league_of_legends_library/app_bloc_observer.dart';
import 'package:league_of_legends_library/app_model.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_bloc.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_bloc.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset/password_reset_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_event.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_state.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_event.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/firebase_options.dart';
import 'package:league_of_legends_library/view/homepage/homepage.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late final AppModel appModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  appModel = await AppModel.initializeDataSource();

  Bloc.observer = const AppBlocObserver();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
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
          BlocProvider(
            create: (_) =>
                UserBloc(appModel.userRepository, appModel.authSource)
                  ..add(
                    UserStarted(),
                  ),
          ),
          BlocProvider(
            create: (_) => LoginBloc(appModel.authSource),
          ),
          BlocProvider(
            create: (_) => PasswordResetBloc(appModel.authSource),
          ),
          BlocProvider(
            create: (_) =>
                SignUpBloc(appModel.authSource, appModel.userRepository),
          ),
          BlocProvider(
            create: (_) => SummonerBloc(appModel.summonerRepository),
          ),
          BlocProvider(
            create: (_) => ChangePasswordBloc(appModel.authSource),
          ),
          BlocProvider(
            create: (_) => MatchHistoryBloc(appModel.matchRepository),
          ),
          BlocProvider(
            create: (_) =>
                DeleteUserBloc(appModel.userRepository, appModel.authSource),
          ),
        ],
        child: BlocListener<LanguageBloc, LanguageState>(
          listener: (context, languageState) {
            if (languageState is LanguageLoaded) {
              context
                  .read<RecentlyViewedBloc>()
                  .add(ChangedLanguage(languageState.language));
              context
                  .read<FavoritesBloc>()
                  .add(ApplicationLanguageChanged(languageState.language));
            }
          },
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) =>
                BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) => MaterialApp(
                title: 'League of Legends library',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AvailableLanguages.values
                    .map((language) => Locale(
                        language.getLanguageCode(), language.getCountryCode()))
                    .toList(),
                locale: languageState is LanguageLoaded
                    ? Locale(languageState.language.getLanguageCode(),
                        languageState.language.getCountryCode())
                    : const Locale("en", "US"),
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
                          seedColor: Colors.purple,
                          brightness: Brightness.dark),
                  useMaterial3: true,
                ),
                themeMode: _getTheme(themeState),
                home: const MyHomePage(title: title),
              ),
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
