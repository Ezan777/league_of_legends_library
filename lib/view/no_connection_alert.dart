import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoConnectionAlert extends StatelessWidget {
  final Function() retryAction;
  const NoConnectionAlert({super.key, required this.retryAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(AppLocalizations.of(context)?.noConnectionAvailableTitle ??
          "Connection error"),
      content: SingleChildScrollView(
        child: Text(AppLocalizations.of(context)
                ?.noConnectionAvailableDescription ??
            "You are not connected to the internet. Check your connection and try again."),
      ),
      actions: [
        TextButton(
            onPressed: retryAction,
            child: Text(AppLocalizations.of(context)?.retryButton ?? "Retry")),
        TextButton(
            onPressed: () => exit(0),
            child: Text(AppLocalizations.of(context)?.exitButton ?? "Exit")),
      ],
    );
  }
}
