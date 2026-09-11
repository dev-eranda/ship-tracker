import 'package:flutter/material.dart';

/// Recent-search entry rendered as an M3 InputChip — the correct M3
/// chip variant for "user-entered/removable data" (as opposed to
/// FilterChip for toggled filters or ActionChip for triggered actions).
class RecentSearchChip extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecentSearchChip({
    super.key,
    required this.term,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: const Icon(Icons.history, size: 18),
      label: Text(term),
      onPressed: onTap,
      onDeleted: onDelete,
      deleteIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
