import '../../../services/api_client.dart';
import '../models/hive_media.dart';

class GalleryPage {
  const GalleryPage({required this.items, required this.nextCursor});

  final List<HiveMedia> items;
  final String? nextCursor;
}

class GalleryRepository {
  const GalleryRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Loads one member-authorized page of a Hive gallery.
  Future<GalleryPage> getPage(
    String hiveId, {
    int limit = 30,
    String? cursor,
  }) async {
    final query = <String, String>{'limit': '$limit'};
    if (cursor != null) query['cursor'] = cursor;
    final suffix = Uri(queryParameters: query).query;
    final response = await _apiClient.get(
      'hives/${Uri.encodeComponent(hiveId)}/media?$suffix',
    );
    final rawItems = response['items'];
    if (rawItems is! List) {
      throw const FormatException('Gallery response is invalid.');
    }
    final nextCursor = response['nextCursor'];
    return GalleryPage(
      items: rawItems
          .map(
            (item) =>
                HiveMedia.fromJson(Map<String, Object?>.from(item as Map)),
          )
          .toList(growable: false),
      nextCursor: nextCursor is String ? nextCursor : null,
    );
  }
}
