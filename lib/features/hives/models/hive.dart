import 'package:flutter/foundation.dart';

@immutable
class Hive {
  const Hive({
    required this.id,
    required this.name,
    required this.inviteCode,
    this.coverImage,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String inviteCode;
  final String? coverImage;
  final DateTime createdAt;

  factory Hive.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final name = json['name'];
    final inviteCode = json['invite_code'] ?? json['inviteCode'];
    final coverImage = json['cover_image'] ?? json['coverImage'];
    final createdAt = json['created_at'] ?? json['createdAt'];

    if (id is! String || name is! String || inviteCode is! String) {
      throw const FormatException('HIve payload is missing required fields.');
    }

    return Hive(
      id: id,
      name: name,
      inviteCode: inviteCode,
      coverImage: coverImage is String ? coverImage : null,
      createdAt: createdAt is String
          ? DateTime.tryParse(createdAt) ?? DateTime.now()
          : createdAt is DateTime
              ? createdAt
              : DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'invite_code': inviteCode,
      'cover_image': coverImage,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Hive copyWith({
    String? id,
    String? name,
    String? inviteCode,
    String? coverImage,
    DateTime? createdAt,
  }) {
    return Hive(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
