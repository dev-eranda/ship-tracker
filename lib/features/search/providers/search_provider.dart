import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';
import '../../map/providers/vessel_provider.dart';

/// Current text typed into the search bar.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Active type filter for the search/list screen (single-select here,
/// unlike the map's multi-select chips — a list view benefits from a
/// simpler "one category at a time" mental model). Null = All.
final searchTypeFilterProvider = StateProvider<VesselType?>((ref) => null);

/// Recently searched terms, most recent first. Capped at 8 entries.
/// In a later phase this can be persisted with Hive/SharedPreferences;
/// for now it lives in memory for the session.
final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>(
      (ref) => RecentSearchesNotifier(),
    );

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]);

  static const _maxEntries = 8;

  void add(String term) {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    final updated = [
      trimmed,
      ...state.where((t) => t.toLowerCase() != trimmed.toLowerCase()),
    ];
    state = updated.take(_maxEntries).toList();
  }

  void remove(String term) {
    state = state.where((t) => t != term).toList();
  }

  void clear() => state = [];
}

/// Matches a vessel against a free-text query across name, MMSI, and IMO.
/// Case-insensitive, partial match.
bool _matchesQuery(Vessel vessel, String query) {
  if (query.isEmpty) return true;
  final q = query.toLowerCase();
  return vessel.name.toLowerCase().contains(q) ||
      vessel.mmsi.contains(q) ||
      (vessel.imo?.contains(q) ?? false);
}

/// Final filtered + searched vessel list for this screen.
final searchResultsProvider = Provider<List<Vessel>>((ref) {
  final allVessels = ref.watch(vesselListProvider);
  final query = ref.watch(searchQueryProvider);
  final typeFilter = ref.watch(searchTypeFilterProvider);

  return allVessels.where((v) {
    final matchesType = typeFilter == null || v.type == typeFilter;
    final matchesText = _matchesQuery(v, query);
    return matchesType && matchesText;
  }).toList();
});
