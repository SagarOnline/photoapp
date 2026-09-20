import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

class InviteCodeGenerator {
  InviteCodeGenerator(this._client);

  final SupabaseClient _client;

  static const String allowedCharacters =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static bool isValidInviteCode(String value) {
    if (value.length != 8) {
      return false;
    }

    return value.split('').every((character) => allowedCharacters.contains(character));
  }

  String generateCode([math.Random? random]) {
    final generator = random ?? math.Random();
    final buffer = StringBuffer();

    for (var index = 0; index < 8; index++) {
      buffer.write(allowedCharacters[generator.nextInt(allowedCharacters.length)]);
    }

    return buffer.toString();
  }

  Future<String> generate() async {
    final usedCodes = await _fetchExistingInviteCodes();
    final random = math.Random();

    for (var attempt = 0; attempt < 100; attempt++) {
      final candidate = generateCode(random);
      if (!usedCodes.contains(candidate)) {
        return candidate;
      }
    }

    throw StateError('Unable to generate a unique invite code after 100 attempts.');
  }

  Future<Set<String>> _fetchExistingInviteCodes() async {
    final response = await _client.from('hives').select('invite_code');

    final existingCodes = <String>{};

    for (final row in response) {
      final inviteCode = row['invite_code'];
      if (inviteCode is String) {
        existingCodes.add(inviteCode);
      }
    }

    return existingCodes;
  }
}
