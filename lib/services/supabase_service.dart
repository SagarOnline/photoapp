import 'package:supabase_flutter/supabase_flutter.dart';

import 'invite_code_generator.dart';

class SupabaseService {
  SupabaseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client,
        _inviteCodeGenerator = InviteCodeGenerator(client ?? Supabase.instance.client);

  final SupabaseClient _client;
  final InviteCodeGenerator _inviteCodeGenerator;

  SupabaseClient get client => _client;

  Future<List<Map<String, dynamic>>> getHives() async {
    final response = await _client
        .from('hives')
        .select()
        .order('created_at', ascending: false);

    final rows = response as List<dynamic>;
    return rows
        .map<Map<String, dynamic>>((row) => Map<String, dynamic>.from(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> createHive({String name = 'New HIve'}) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const FormatException('HIve name cannot be empty.');
    }

    final inviteCode = await _inviteCodeGenerator.generate();

    final response = await _client
        .from('hives')
        .insert({
          'name': trimmedName,
          'invite_code': inviteCode,
          'cover_image': null,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> joinHive(String inviteCode) async {
    final trimmedCode = inviteCode.trim();
    if (trimmedCode.isEmpty) {
      throw const FormatException('Invite code cannot be empty.');
    }

    final response = await _client
        .from('hives')
        .select()
        .eq('invite_code', trimmedCode)
        .maybeSingle();

    if (response == null) {
      throw const FormatException('Invite code was not found.');
    }

    final hiveId = response['id'];
    if (hiveId is! String || hiveId.isEmpty) {
      throw const FormatException('HIve record is invalid.');
    }

    await _client.from('members').insert({
      'hive_id': hiveId,
      'user_id': null,
      'guest_name': 'Guest',
      'joined_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

}
