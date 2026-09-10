import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';
import '../providers/vessel_provider.dart';

class VesselFilterChips extends ConsumerWidget {
  const VesselFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(activeFiltersProvider);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: VesselType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = VesselType.values[index];
          final isActive = activeFilters.contains(type);

          return FilterChip(
            label: Text(type.label),
            selected: isActive,
            onSelected: (selected) {
              final current = {...ref.read(activeFiltersProvider)};
              if (selected) {
                current.add(type);
              } else {
                current.remove(type);
              }
              ref.read(activeFiltersProvider.notifier).state = current;
            },
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.15),
            checkmarkColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
              ),
            ),
          );
        },
      ),
    );
  }
}
