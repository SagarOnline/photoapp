import '../../../services/supabase_service.dart';
import '../models/hive.dart';

abstract class HiveRepository {
  Future<Hive> createHive({String name});
  Future<List<Hive>> getHives();
  Future<void> joinHive(String inviteCode);
}

class SupabaseHiveRepository implements HiveRepository {
  const SupabaseHiveRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<Hive> createHive({String name = 'New HIve'}) async {
    final payload = await _supabaseService.createHive(name: name);
    return Hive.fromJson(payload);
  }

  @override
  Future<List<Hive>> getHives() async {
    final rows = await _supabaseService.getHives();
    return rows
        .map(Hive.fromJson)
        .toList(growable: false);
  }

  @override
  Future<void> joinHive(String inviteCode) async {
    await _supabaseService.joinHive(inviteCode);
  }
}
