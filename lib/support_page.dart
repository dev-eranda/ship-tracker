import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: ListView.builder(
        reverse: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Align(
              alignment: .centerRight,
              child: Container(
                margin: const .all(8.0),
                padding: const .all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: .circular(8.0),
                ),
                child: Text(
                  'Hello',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            );
          }
          return Align(
            alignment: .centerLeft,
            child: Container(
              margin: const .all(8.0),
              padding: const .all(8.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: .circular(8.0),
              ),
              child: Text(
                'Hi!',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
