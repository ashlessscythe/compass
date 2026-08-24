import 'dart:convert';

import 'package:compass/features/sync/domain/sync_change.dart';
import 'package:http/http.dart' as http;

/// HTTP client for Compass sync API (mirrors @compass/api contracts).
class SyncApiClient {
  SyncApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _http;
  String? sessionToken;

  Uri _uri(String path, [Map<String, String>? query]) {
    final root = baseUrl.replaceAll(RegExp(r'/$'), '');
    return Uri.parse('$root$path').replace(queryParameters: query);
  }

  Map<String, String> _headers({bool json = true, bool auth = false}) {
    final headers = <String, String>{};
    if (json) {
      headers['Content-Type'] = 'application/json';
    }
    final token = sessionToken;
    if (auth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> authApple({
    required String identityToken,
    String? fullName,
  }) async {
    final response = await _http.post(
      _uri('/api/auth/apple'),
      headers: _headers(),
      body: jsonEncode({
        'identityToken': identityToken,
        if (fullName != null) 'fullName': fullName,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> authDev({
    required String secret,
    required String deviceId,
  }) async {
    final response = await _http.post(
      _uri('/api/auth/dev'),
      headers: _headers(),
      body: jsonEncode({
        'secret': secret,
        'deviceId': deviceId,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> push(List<SyncChange> changes) async {
    final response = await _http.post(
      _uri('/api/sync/push'),
      headers: _headers(auth: true),
      body: jsonEncode({
        'changes': changes.map((c) => c.toWire()).toList(growable: false),
      }),
    );
    if (response.statusCode == 401) {
      throw StateError('Sync session expired');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> pull(String since) async {
    final response = await _http.get(
      _uri('/api/sync/pull', {'since': since}),
      headers: _headers(json: false, auth: true),
    );
    if (response.statusCode == 401) {
      throw StateError('Sync session expired');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> status() async {
    final response = await _http.get(
      _uri('/api/sync/status'),
      headers: _headers(json: false, auth: true),
    );
    if (response.statusCode == 401) {
      throw StateError('Sync session expired');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
