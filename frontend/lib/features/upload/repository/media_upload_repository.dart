import '../../../services/api_client.dart';

class MediaUploadRepository {
  const MediaUploadRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Uploads already-compressed media through a member-authorized R2 URL.
  Future<Map<String, Object?>> upload({
    required String hiveId,
    required String fileName,
    required String contentType,
    required List<int> compressedBytes,
    required String mediaType,
  }) async {
    final authorization = await _apiClient.post(
      'hives/${Uri.encodeComponent(hiveId)}/media/upload-authorization',
      body: {
        'fileName': fileName,
        'contentType': contentType,
        'sizeBytes': compressedBytes.length,
      },
    );
    final uploadUrl = authorization['uploadUrl'];
    final objectKey = authorization['objectKey'];
    if (uploadUrl is! String || objectKey is! String) {
      throw const FormatException('Upload authorization response is invalid.');
    }
    await _apiClient.uploadAuthorizedBytes(
      uploadUri: Uri.parse(uploadUrl),
      bytes: compressedBytes,
      contentType: contentType,
    );
    return _apiClient.post(
      'hives/${Uri.encodeComponent(hiveId)}/media',
      body: {'objectKey': objectKey, 'mediaType': mediaType},
    );
  }
}
