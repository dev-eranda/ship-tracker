import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';
import '../providers/search_provider.dart';
import '../widgets/vessel_list_tile.dart';
import '../widgets/recent_search_chip.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    final query = value.trim();
    ref.read(searchQueryProvider.notifier).state = query;
    if (query.isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).add(query);
    }
    _searchController.closeView(query);
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(searchTypeFilterProvider);
    final recentSearches = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search vessels')),
      body: Column(
        children: [
          // ── M3 SearchAnchor: expands into a full search view ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SearchAnchor(
              searchController: _searchController,
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  hintText: 'Vessel name, MMSI, or IMO',
                  leading: const Icon(Icons.search),
                  trailing: query.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          ),
                        ]
                      : null,
                  onTap: () => controller.openView(),
                  onChanged: (value) {
                    // Live-filter as the user types, without waiting for submit.
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  onSubmitted: _submitSearch,
                );
              },
              suggestionsBuilder: (context, controller) {
                // M3 SearchAnchor suggestion list = recent searches here.
                if (recentSearches.isEmpty) {
                  return [
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('No recent searches yet'),
                    ),
                  ];
                }
                return recentSearches.map((term) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(term),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(recentSearchesProvider.notifier).remove(term);
                        controller.closeView(controller.text);
                      },
                    ),
                    onTap: () => _submitSearch(term),
                  );
                }).toList();
              },
            ),
          ),

          // ── Recent search chips (visible when query is empty) ──
          if (query.isEmpty && recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: recentSearches.map((term) {
                    return RecentSearchChip(
                      term: term,
                      onTap: () => _submitSearch(term),
                      onDelete: () => ref
                          .read(recentSearchesProvider.notifier)
                          .remove(term),
                    );
                  }).toList(),
                ),
              ),
            ),

          const SizedBox(height: 4),

          // ── M3 FilterChip row for vessel type filter ──
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: typeFilter == null,
                    onSelected: (_) =>
                        ref.read(searchTypeFilterProvider.notifier).state =
                            null,
                  ),
                ),
                ...VesselType.values.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.label),
                      selected: typeFilter == type,
                      onSelected: (selected) {
                        ref.read(searchTypeFilterProvider.notifier).state =
                            selected ? type : null;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 16),

          // ── Results count ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${results.length} vessel${results.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // ── Results list ──
          Expanded(
            child: results.isEmpty
                ? _EmptyState(query: query)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final vessel = results[index];
                      return VesselListTile(
                        vessel: vessel,
                        onTap: () {
                          // TODO (Phase 4): Navigator.pushNamed(context, '/vessel-detail', arguments: vessel);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;

  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sailing_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              query.isEmpty
                  ? 'No vessels match this filter'
                  : 'No results for "$query"',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
