import 'package:flutter/material.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No result found"),
    );
  }
}
