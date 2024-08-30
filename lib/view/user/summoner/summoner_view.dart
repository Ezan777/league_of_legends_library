import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_event.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_event.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_state.dart';
import 'package:league_of_legends_library/bloc/user/user_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';
import 'package:league_of_legends_library/data/summoner_data_source.dart';
import 'package:league_of_legends_library/view/errors/connection_unavailable_view.dart';
import 'package:league_of_legends_library/view/errors/generic_error_view.dart';
import 'package:league_of_legends_library/view/errors/image_not_available.dart';
import 'package:league_of_legends_library/view/user/edit_user_data.dart';
import 'package:league_of_legends_library/view/user/summoner/match_history.dart';
import 'package:league_of_legends_library/view/user/summoner/rank_selector.dart';
import 'package:text_scroll/text_scroll.dart';

class SummonerView extends StatefulWidget {
  final ValueNotifier<QueueType> selectedQueue =
      ValueNotifier(QueueType.soloDuo);
  SummonerView({super.key});

  @override
  State<SummonerView> createState() => _SummonerViewState();
}

class _SummonerViewState extends State<SummonerView> {
  @override
  Widget build(BuildContext context) {
    widget.selectedQueue.addListener(() {
      setState(() {});
    });

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
      body: MultiBlocListener(
          listeners: [
            BlocListener<SummonerBloc, SummonerState>(
              listener: (context, state) {
                if (state is SummonerSuccess) {
                  context.read<MatchHistoryBloc>().add(MatchHistoryStarted(
                      RiotRegion.fromServer(RiotServer.fromServerCode(
                              state.summoner.serverCode))
                          .name,
                      state.summoner.puuid));
                }
              },
            ),
          ],
          child: BlocBuilder<SummonerBloc, SummonerState>(
            builder: (context, state) => switch (state) {
              SummonerLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              SummonerSuccess() => _buildView(context, state),
              SummonerError() => _errorBox(context, state.error),
            },
          )),
    );
  }

  Widget _buildView(BuildContext context, SummonerSuccess state) {
    const collapsedHeight = 75.0;

    return Center(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: top == collapsedHeight ? 1.0 : 0,
                    child: _buildCollapsedInfo(context, state),
                  ),
                  background: _buildSummonerInfo(context, state),
                );
              },
            ),
            expandedHeight: 175,
            collapsedHeight: collapsedHeight,
          ),
          SliverToBoxAdapter(
            child: RankSelector(
              summoner: state.summoner,
              selectedQueue: widget.selectedQueue,
            ),
          ),
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)?.matchHistoryListTitle ??
                  "Match history",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          MatchHistory(state.summoner, widget.selectedQueue.value),
        ],
      ),
    );
  }

  Widget _buildCollapsedInfo(BuildContext context, SummonerSuccess state) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                progressIndicatorBuilder: (context, uri, progress) =>
                    const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const ImageNotAvailable(),
                height: 45,
                width: 45,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: TextScroll(
              state.summoner.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              pauseBetween: const Duration(milliseconds: 1600),
              selectable: true,
              intervalSpaces: 6,
              mode: TextScrollMode.endless,
            ),
          ),
        ],
      );

  Widget _buildSummonerInfo(BuildContext context, SummonerSuccess state) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                progressIndicatorBuilder: (context, uri, progress) =>
                    const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const ImageNotAvailable(),
                height: 128,
                width: 128,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextScroll(
                  state.summoner.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  pauseBetween: const Duration(milliseconds: 1600),
                  selectable: true,
                  intervalSpaces: 6,
                  mode: TextScrollMode.endless,
                ),
                Text(
                  "#${state.summoner.tag}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Text(
                  AppLocalizations.of(context)
                          ?.summonerLevel(state.summoner.level) ??
                      "Level: ${state.summoner.level}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                )
              ],
            ),
          ),
        ],
      );

  Widget _errorBox(BuildContext context, Object? error) => BlocBuilder<UserBloc,
          UserState>(
      builder: (context, state) => switch (state) {
            UserLogged() => switch (error) {
                InternetConnectionUnavailable() =>
                  ConnectionUnavailableView(retryCallback: () {
                    context.read<SummonerBloc>().add(SummonerStarted(
                        state.appUser.summonerName,
                        state.appUser.tagLine,
                        RiotServer.fromServerCode(state.appUser.serverCode)));
                  }),
                SummonerNotFound() => Column(
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                      ?.summonerErrorBoxContent ??
                                  "Something went wrong while loading summoner info, please try again. - Error: ${error.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const EditUserData()),
                            );
                          },
                          child: Text(AppLocalizations.of(context)
                                  ?.editAccountInfoLabel ??
                              "Edit your account info")),
                    ],
                  ),
                _ => GenericErrorView(
                    error: error,
                    retryCallback: () {
                      context.read<SummonerBloc>().add(SummonerStarted(
                          state.appUser.summonerName,
                          state.appUser.tagLine,
                          RiotServer.fromServerCode(state.appUser.serverCode)));
                    },
                  ),
              },
            NoUserLogged() || UserError() => GenericErrorView(
                retryCallback: () {
                  context.read<UserBloc>().add(UserStarted());
                },
              ),
            UserLoading() || UpdatingUserData() => const Center(
                child: CircularProgressIndicator(),
              ),
          });
}

class SummonerViewAction {
  final String label;
  final Function() callback;

  const SummonerViewAction(this.label, this.callback);
}
