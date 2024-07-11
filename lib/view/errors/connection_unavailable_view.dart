import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectionUnavailableView extends StatelessWidget {
  final Function() retryCallback;
  const ConnectionUnavailableView({super.key, required this.retryCallback});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 120,
                  color: theme.colorScheme.onErrorContainer,
                ),
                Text(
                  AppLocalizations.of(context)?.noConnectionAvailableTitle ??
                      "Connection unavailable",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)
                          ?.noConnectionAvailableDescription ??
                      "It seems that you are not connected to the internet. Please check your connection and try again.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FilledButton(
            onPressed: retryCallback,
            child: Text(AppLocalizations.of(context)?.retryButton ?? "Retry"),
          ),
        ],
      ),
    );
  }
}
