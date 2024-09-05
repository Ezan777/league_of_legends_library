import 'package:flutter/material.dart';

class ImageNotAvailable extends StatelessWidget {
  final Object? error;
  const ImageNotAvailable({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.error,
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
