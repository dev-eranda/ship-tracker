import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
            child: Text('Support page', style: theme.textTheme.titleLarge),
          ),
        ),
      ),
    );
  }
}
