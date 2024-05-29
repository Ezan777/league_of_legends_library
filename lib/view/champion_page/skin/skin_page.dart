import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/champion_page/skin/skin_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkinPage extends StatelessWidget {
  final Champion champion;
  const SkinPage({super.key, required this.champion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.skinTitle ?? "Skins"),
      ),
      body: BlocBuilder<SkinsBloc, SkinState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ListView.separated(
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SkinCard(
                        champion: champion, skin: champion.skins[index]),
                  ),
              separatorBuilder: (_, index) => const SizedBox(height: 20),
              itemCount: champion.skins.length),
        ),
      ),
    );
  }
}
