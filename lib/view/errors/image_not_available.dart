import 'package:flutter/material.dart';

class ImageNotAvailable extends StatelessWidget {
  const ImageNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.wifi_off,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
