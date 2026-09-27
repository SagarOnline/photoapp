import 'package:flutter/foundation.dart';

@immutable
class HiveMedia {
  const HiveMedia({
    required this.id,
    required this.hiveId,
    required this.fileUrl,
    required this.mediaType,
    required this.uploadedAt,
    required this.uploadedBy,
    this.thumbnailUrl,
  });

  final String id;
  final String hiveId;
  final String fileUrl;
  final String? thumbnailUrl;
  final String mediaType;
  final DateTime uploadedAt;
  final String uploadedBy;

  /// Creates a media item from the versioned API response.
  factory HiveMedia.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final hiveId = json['hiveId'];
    final fileUrl = json['fileUrl'];
    final mediaType = json['mediaType'];
    final uploadedAt = json['uploadedAt'];
    final uploadedBy = json['uploadedBy'];
    if (id is! String ||
        hiveId is! String ||
        fileUrl is! String ||
        mediaType is! String ||
        uploadedAt is! String ||
        uploadedBy is! String) {
      throw const FormatException('Media response is missing required fields.');
    }
    final parsedDate = DateTime.tryParse(uploadedAt);
    if (parsedDate == null) {
      throw const FormatException('Media upload time is invalid.');
    }
    final thumbnailUrl = json['thumbnailUrl'];
    return HiveMedia(
      id: id,
      hiveId: hiveId,
      fileUrl: fileUrl,
      thumbnailUrl: thumbnailUrl is String ? thumbnailUrl : null,
      mediaType: mediaType,
      uploadedAt: parsedDate,
      uploadedBy: uploadedBy,
    );
  }
}
