import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericErrorView extends StatelessWidget {
  final Object? error;
  final Function()? retryCallback;
  const GenericErrorView({
    super.key,
    this.error,
    this.retryCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String title =
        AppLocalizations.of(context)?.genericErrorTitle ?? "Error occurred";
    String message = AppLocalizations.of(context)?.genericErrorDescription ??
        "An error occurred, please try again later";
    final String retryLabel =
        AppLocalizations.of(context)?.retryButton ?? "Retry";

    /* if (error is Exception) {
      message += " Error: $error";
    } */

    return switch (error) {
      _ => _genericError(context, theme, title, message, retryLabel,
          retryCallback: retryCallback),
    };
  }

  Widget _genericError(BuildContext context, ThemeData theme, String title,
          String message, String retryLabel,
          {Function()? retryCallback}) =>
      Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
            if (retryCallback != null)
              FilledButton(onPressed: retryCallback, child: Text(retryLabel)),
          ],
        ),
      );
}
