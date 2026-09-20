import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/supabase_service.dart';
import '../models/hive.dart';
import '../repository/hives_repository.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final hivesRepositoryProvider = Provider<HiveRepository>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return SupabaseHiveRepository(service);
});

final hivesControllerProvider =
    AsyncNotifierProvider<HivesController, List<Hive>>(() {
  return HivesController();
});

class HivesController extends AsyncNotifier<List<Hive>> {
  @override
  Future<List<Hive>> build() async {
    final repository = ref.read(hivesRepositoryProvider);
    return repository.getHives();
  }

  Future<void> refreshHives() async {
    final repository = ref.read(hivesRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.getHives());
  }

  Future<void> createHive(String name) async {
    final repository = ref.read(hivesRepositoryProvider);
    if (name.trim().isEmpty) {
      throw const FormatException('HIve name cannot be empty.');
    }

    final createdHive = await repository.createHive(name: name);
    final existingHives = state.value ?? const <Hive>[];
    state = AsyncValue.data([createdHive, ...existingHives]);
  }

  Future<void> joinHive(String inviteCode) async {
    final repository = ref.read(hivesRepositoryProvider);
    final trimmedCode = inviteCode.trim();

    if (trimmedCode.isEmpty) {
      throw const FormatException('Invite code cannot be empty.');
    }

    await repository.joinHive(trimmedCode);
    await refreshHives();
  }
}
