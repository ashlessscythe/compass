import 'package:compass/core/constants/sync_build_config.dart';
import 'package:compass/core/utils/id_generator.dart';
import 'package:compass/features/sync/domain/sync_engine.dart';
import 'package:compass/features/sync/infrastructure/sync_api_client.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const _deviceIdKey = 'compass_sync_device_id';

final syncApiClientProvider = Provider<SyncApiClient>((ref) {
  return SyncApiClient(baseUrl: compassApiBaseUrl);
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    store: ref.watch(syncLocalStoreProvider),
    api: ref.watch(syncApiClientProvider),
  );
});

class SyncSessionSnapshot {
  const SyncSessionSnapshot({
    required this.signedIn,
    required this.userId,
    required this.lastSuccessAt,
    required this.apiConfigured,
  });

  final bool signedIn;
  final String? userId;
  final DateTime? lastSuccessAt;
  final bool apiConfigured;
}

final syncSessionProvider =
    FutureProvider<SyncSessionSnapshot>((ref) async {
  final store = ref.watch(syncLocalStoreProvider);
  final state = await store.readState();
  return SyncSessionSnapshot(
    signedIn: state.sessionToken != null && state.sessionToken!.isNotEmpty,
    userId: state.userId,
    lastSuccessAt: state.lastSuccessAt,
    apiConfigured: compassApiBaseUrl.isNotEmpty,
  );
});

class SyncAuthController {
  SyncAuthController(this._ref);

  final Ref _ref;

  bool get canUseDevAuth => isDevSyncAuthEnabled;

  Future<String> _deviceId() async {
    if (compassSyncDevDeviceId.isNotEmpty) {
      return compassSyncDevDeviceId;
    }
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final id = IdGenerator.v4();
    await prefs.setString(_deviceIdKey, id);
    return id;
  }

  Future<String?> signInWithApple() async {
    if (compassApiBaseUrl.isEmpty) {
      return 'Set COMPASS_API_BASE_URL to enable sync.';
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final token = credential.identityToken;
      if (token == null || token.isEmpty) {
        return 'Apple did not return an identity token.';
      }
      final nameParts = [
        credential.givenName,
        credential.familyName,
      ].whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty);
      final fullName = nameParts.isEmpty ? null : nameParts.join(' ');
      final api = _ref.read(syncApiClientProvider);
      final body = await api.authApple(
        identityToken: token,
        fullName: fullName,
      );
      if (body['ok'] != true) {
        return body['message'] as String? ?? 'Apple sign-in failed.';
      }
      await _ref.read(syncLocalStoreProvider).saveSession(
            sessionToken: body['sessionToken'] as String,
            userId: body['userId'] as String,
          );
      _ref.invalidate(syncSessionProvider);
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return null;
      }
      return e.message;
    } on Object catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInDev() async {
    if (!canUseDevAuth) {
      return 'Dev sync auth is not configured.';
    }
    try {
      final api = _ref.read(syncApiClientProvider);
      final body = await api.authDev(
        secret: compassSyncDevSecret,
        deviceId: await _deviceId(),
      );
      if (body['ok'] != true) {
        return body['message'] as String? ?? 'Dev sign-in failed.';
      }
      await _ref.read(syncLocalStoreProvider).saveSession(
            sessionToken: body['sessionToken'] as String,
            userId: body['userId'] as String,
          );
      _ref.invalidate(syncSessionProvider);
      return null;
    } on Object catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _ref.read(syncLocalStoreProvider).clearSession();
    _ref.read(syncApiClientProvider).sessionToken = null;
    _ref.invalidate(syncSessionProvider);
  }

  Future<SyncResult> syncNow() async {
    final result = await _ref.read(syncEngineProvider).syncNow();
    _ref.invalidate(syncSessionProvider);
    return result;
  }
}

final syncAuthControllerProvider = Provider<SyncAuthController>((ref) {
  return SyncAuthController(ref);
});
