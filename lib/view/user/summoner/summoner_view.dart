import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/view/errors/image_not_available.dart';
import 'package:league_of_legends_library/view/user/edit_user_data.dart';
import 'package:text_scroll/text_scroll.dart';

class SummonerView extends StatelessWidget {
  const SummonerView({super.key});

  @override
  Widget build(BuildContext context) {
    void viewAccountInfo() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EditUserData(),
        ),
      );
    }

    void logoutPressed() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)?.logout ?? "Logout"),
          content: Text(AppLocalizations.of(context)?.logoutAlertContent ??
              "Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                context.read<UserBloc>().add(LogoutButtonPressed());
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.logout ?? "Logout"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
            )
          ],
        ),
      );
    }

    final List<SummonerViewAction> actions = [
      SummonerViewAction(
          AppLocalizations.of(context)?.viewAccountInfo ??
              "View your account info",
          viewAccountInfo),
      SummonerViewAction(
          AppLocalizations.of(context)?.logout ?? "Logout", logoutPressed),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("League of Legends library"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => actions
                .map(
                  (action) => PopupMenuItem(
                    onTap: action.callback,
                    child: Text(action.label),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: BlocBuilder<SummonerBloc, SummonerState>(
        builder: (context, state) => switch (state) {
          SummonerLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          SummonerSuccess() => _buildView(context, state),
          SummonerError() => _errorBox(context),
        },
      ),
    );
  }

  Widget _buildView(BuildContext context, SummonerSuccess state) => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: state.summoner.profileIconUri,
                        progressIndicatorBuilder: (context, uri, progress) => const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const ImageNotAvailable(),
                        height: 128,
                        width: 128,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextScroll(
                          state.summoner.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(50, 0)),
                          pauseBetween: const Duration(milliseconds: 1600),
                          selectable: true,
                          intervalSpaces: 6,
                          mode: TextScrollMode.endless,
                        ),
                        Text(
                          "#${state.summoner.tag}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                                  ?.summonerLevel(state.summoner.level) ??
                              "Level: ${state.summoner.level}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      );

  Widget _errorBox(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error,
                  size: 64,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                Text(
                  AppLocalizations.of(context)?.summonerErrorBoxContent ??
                      "Something went wrong while loading summoner info, please try again.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
              ],
            ),
          ),
          FilledButton(
              onPressed: () {
                context.read<UserBloc>().add(LogoutButtonPressed());
              },
              child: const Text("Login again")),
        ],
      );
}

class SummonerViewAction {
  final String label;
  final Function() callback;

  const SummonerViewAction(this.label, this.callback);
}
