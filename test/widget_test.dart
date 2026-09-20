// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photoapp/features/hives/models/hive.dart';
import 'package:photoapp/features/hives/providers/hives_provider.dart';
import 'package:photoapp/features/hives/repository/hives_repository.dart';
import 'package:photoapp/main.dart';

class FakeHiveRepository implements HiveRepository {
  @override
  Future<Hive> createHive({String name = 'New HIve'}) async {
    return Hive(
      id: 'hive-1',
      name: name,
      inviteCode: 'ABCD1234',
      coverImage: null,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<Hive>> getHives() async {
    return [
      Hive(
        id: 'hive-1',
        name: 'Goa Trip 2026',
        inviteCode: 'GOA2026',
        coverImage: null,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];
  }

  @override
  Future<void> joinHive(String inviteCode) async {
    // no-op for test coverage.
  }
}

void main() {
  testWidgets('HIves screen loads with the app shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hivesRepositoryProvider.overrideWithValue(FakeHiveRepository()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Goa Trip 2026'), findsOneWidget);
  });
}
