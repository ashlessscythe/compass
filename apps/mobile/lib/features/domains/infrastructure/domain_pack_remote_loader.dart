import 'dart:convert';

import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:http/http.dart' as http;

/// Fetches domain pack manifests from getcompass.space API URLs.
class DomainPackRemoteLoader {
  DomainPackRemoteLoader({http.Client? client})
      : _client = client ?? http.Client();

  static final _pathPattern = RegExp(r'^/api/domains/[a-z0-9_-]+$');

  final http.Client _client;

  static const userAgent = 'CompassInventory/0.5 (getcompass.space)';

  /// Validates and normalizes a Compass install URL.
  Result<Uri> parseInstallUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Enter a domain pack URL'),
      );
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return const Result.failure(
        Failure.validation(message: 'Invalid URL'),
      );
    }
    if (uri.scheme != 'https') {
      return const Result.failure(
        Failure.validation(message: 'Pack URL must use HTTPS'),
      );
    }
    if (uri.host != AppConstants.domain) {
      return const Result.failure(
        Failure.validation(
          message: 'Only getcompass.space domain pack URLs are supported',
        ),
      );
    }
    if (!_pathPattern.hasMatch(uri.path)) {
      return const Result.failure(
        Failure.validation(
          message: 'URL must look like https://getcompass.space/api/domains/{packId}',
        ),
      );
    }
    return Result.success(uri);
  }

  Future<Result<({DomainPack pack, String rawJson})>> fetchPackFromUrl(
    String url,
  ) async {
    final parsed = parseInstallUrl(url);
    if (parsed.isFailure) {
      return Result.failure(parsed.failureOrNull!);
    }
    final uri = parsed.valueOrNull!;

    try {
      final response = await _client.get(
        uri,
        headers: const {
          'User-Agent': userAgent,
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 404) {
        return const Result.failure(
          Failure.validation(message: 'Domain pack not found at this URL'),
        );
      }
      if (response.statusCode != 200) {
        return Result.failure(
          Failure.unexpected(
            message: 'Server returned HTTP ${response.statusCode}',
          ),
        );
      }
      final body = response.body.trim();
      if (body.isEmpty) {
        return const Result.failure(
          Failure.validation(message: 'Empty response from server'),
        );
      }
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) {
        return const Result.failure(
          Failure.validation(message: 'Response is not a JSON object'),
        );
      }
      final validation = _validateManifest(json);
      if (validation != null) {
        return Result.failure(Failure.validation(message: validation));
      }
      return Result.success(
        (pack: DomainPack.fromJson(json), rawJson: body),
      );
    } on FormatException {
      return const Result.failure(
        Failure.validation(message: 'Response is not valid JSON'),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Could not download domain pack. Check your connection.',
          cause: error,
        ),
      );
    }
  }

  String? _validateManifest(Map<String, dynamic> json) {
    for (final key in ['id', 'moduleId', 'version', 'displayName']) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        return 'Manifest is missing required field: $key';
      }
    }
    if (json['assetTypes'] is! List || (json['assetTypes'] as List).isEmpty) {
      return 'Manifest must include at least one asset type';
    }
    return null;
  }
}
