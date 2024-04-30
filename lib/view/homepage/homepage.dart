import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_bloc.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_event.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_state.dart';
import 'package:league_of_legends_library/main.dart';
import 'package:league_of_legends_library/view/champion_selection_page/champion_selection_page.dart';
import 'package:league_of_legends_library/view/homepage/homepage_view.dart';
import 'package:league_of_legends_library/view/settings/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
        builder: ((context, state) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                items:
                    // Implementing items like this ensure that the index will match the desired type of page
                    BodyPages.values
                        .map((page) => BodyPagesItem.getBottomNavigationBarItem(
                            context, page))
                        .toList(),
                onTap: (index) {
                  context
                      .read<NavigationBloc>()
                      .add(SetNavigationPage(BodyPages.values[index]));
                },
                currentIndex: state.selectedPage.index,
              ),
              body: _buildBody(state.selectedPage),
            )));
  }

  Widget _buildBody(BodyPages selectedPage) => switch (selectedPage) {
        BodyPages.homepage => const HomepageView(),
        BodyPages.championPage => ChampionSelectionPage(
            championRepository: appModel.championRepository),
        BodyPages.settings => const SettingsView(),
      };
}

extension BodyPagesItem on BodyPages {
  static BottomNavigationBarItem getBottomNavigationBarItem(
          BuildContext context, BodyPages page) =>
      switch (page) {
        BodyPages.homepage => BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: AppLocalizations.of(context)?.homeLabel ?? "Home"),
        BodyPages.championPage => BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: AppLocalizations.of(context)?.championsLabel ?? "Champions"),
        BodyPages.settings => BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)?.settingsLabel ?? "Settings"),
      };
}
