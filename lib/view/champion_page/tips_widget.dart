import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/champion.dart';

class TipsWidget extends StatelessWidget {
  // FIXME: Tips are broken in data dragon needs to find something also
  final Champion champion;

  const TipsWidget({super.key, required this.champion});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: champion.allyTips
            .map((tip) => _buildTip(tip: tip, context: context))
            .toList(),
      ),
    );
  }

  Widget _buildTip({required String tip, required BuildContext context}) =>
      Text(tip);
}
