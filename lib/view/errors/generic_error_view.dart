import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericErrorView extends StatelessWidget {
  const GenericErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)?.genericErrorTitle ??
                  "Error occurred",
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.onError),
            ),
            Text(
              AppLocalizations.of(context)?.genericErrorDescription ??
                  "An error occurred, please try again later",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
