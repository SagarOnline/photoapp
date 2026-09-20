import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/hives_provider.dart';
import '../widgets/hive_tile.dart';
import '../widgets/create_hive_sheet.dart';
import '../widgets/join_hive_sheet.dart';

class HivesScreen extends ConsumerWidget {
  const HivesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hivesState = ref.watch(hivesControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: switch (hivesState) {
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncError(:final error) => _ErrorState(
                message: error.toString(),
                onRetry: () => ref.read(hivesControllerProvider.notifier).refreshHives(),
              ),
            AsyncData(:final value) => value.isEmpty
                ? _EmptyHivesState(
                    onCreate: () => _showCreateSheet(context),
                    onJoin: () => _showJoinSheet(context),
                  )
                : _HivesDashboard(
                  hives: value,
                    onCreate: () => _showCreateSheet(context),
                    onJoin: () => _showJoinSheet(context),
                  ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => const CreateHiveSheet(),
    );
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => const JoinHiveSheet(),
    );
  }
}

class _HivesDashboard extends StatelessWidget {
  const _HivesDashboard({
    required this.hives,
    required this.onCreate,
    required this.onJoin,
  });

  final List<dynamic> hives;
  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Welcome back!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: onCreate,
              tooltip: 'Add new HIve',
              icon: const Icon(Icons.add_circle_rounded, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Your memories',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onJoin,
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Join'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            itemCount: hives.length,
            padding: const EdgeInsets.only(bottom: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final hive = hives[index];
              return HiveTile(hive: hive);
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyHivesState extends StatelessWidget {
  const _EmptyHivesState({
    required this.onCreate,
    required this.onJoin,
  });

  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'No HIves yet',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Create a new event HIve or join one from a shared invite code.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Create a HIve'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onJoin,
                icon: const Icon(Icons.group_add_outlined),
                label: const Text('Join with invite code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load HIves',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
