import '../../../services/api_client.dart';
import '../models/hive.dart';

abstract class HiveRepository {
  Future<Hive> createHive({String name});
  Future<List<Hive>> getHives();
  Future<void> joinHive(String inviteCode);
}

class ApiHiveRepository implements HiveRepository {
  const ApiHiveRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Hive> createHive({String name = 'New Hive'}) async {
    final payload = await _apiClient.post('hives', body: {'name': name});
    return Hive.fromJson(payload);
  }

  @override
  Future<List<Hive>> getHives() async {
    final response = await _apiClient.get('hives');
    final rows = response['items'];
    if (rows is! List) {
      throw const FormatException('Hive response is invalid.');
    }
    return rows
        .map((row) => Hive.fromJson(Map<String, Object?>.from(row as Map)))
        .toList(growable: false);
  }

  @override
  Future<void> joinHive(String inviteCode) async {
    await _apiClient.post('hives/join', body: {'inviteCode': inviteCode});
  }
}
