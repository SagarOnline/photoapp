import 'package:flutter/material.dart';

import '../models/hive.dart';

class HiveTile extends StatelessWidget {
  const HiveTile({
    required this.hive,
    super.key,
  });

  final Hive hive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = hive.coverImage != null && hive.coverImage!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(24),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: hasImage
                  ? Image.network(
                      hive.coverImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _PlaceholderPreview(theme: theme);
                      },
                    )
                  : _PlaceholderPreview(theme: theme),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: theme.colorScheme.surface,
              child: Text(
                hive.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPreview extends StatelessWidget {
  const _PlaceholderPreview({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.photo_library_outlined,
          size: 46,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
