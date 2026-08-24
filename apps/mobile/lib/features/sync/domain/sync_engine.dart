import 'package:compass/features/sync/domain/sync_change.dart';
import 'package:compass/features/sync/infrastructure/sync_api_client.dart';
import 'package:compass/features/sync/infrastructure/sync_local_store.dart';

class SyncResult {
  const SyncResult({
    required this.pushed,
    required this.pulled,
    required this.cursor,
    this.errorMessage,
  });

  final int pushed;
  final int pulled;
  final String cursor;
  final String? errorMessage;

  bool get ok => errorMessage == null;
}

/// Push outbox then pull remote changes (LWW apply).
class SyncEngine {
  SyncEngine({
    required SyncLocalStore store,
    required SyncApiClient api,
  })  : _store = store,
        _api = api;

  final SyncLocalStore _store;
  final SyncApiClient _api;

  Future<SyncResult> syncNow() async {
    final state = await _store.readState();
    final token = state.sessionToken;
    if (token == null || token.isEmpty) {
      return const SyncResult(
        pushed: 0,
        pulled: 0,
        cursor: '',
        errorMessage: 'Sign in to sync.',
      );
    }
    _api.sessionToken = token;

    try {
      if (!state.hasCompletedInitialSync) {
        final pending = await _store.pendingChanges();
        if (pending.isEmpty) {
          await _store.enqueueFullSnapshot();
        }
      }

      final outbox = await _store.pendingChanges();
      var pushed = 0;
      if (outbox.isNotEmpty) {
        final pushBody = await _api.push(outbox);
        if (pushBody['ok'] != true) {
          return SyncResult(
            pushed: 0,
            pulled: 0,
            cursor: state.cursor,
            errorMessage: pushBody['message'] as String? ?? 'Push failed',
          );
        }
        pushed = (pushBody['applied'] as num?)?.toInt() ?? outbox.length;
        await _store.clearOutboxIds(
          outbox.map((c) => c.localId).whereType<int>(),
        );
      }

      final pullBody = await _api.pull(state.cursor);
      if (pullBody['ok'] != true) {
        return SyncResult(
          pushed: pushed,
          pulled: 0,
          cursor: state.cursor,
          errorMessage: pullBody['message'] as String? ?? 'Pull failed',
        );
      }

      final rawChanges = pullBody['changes'] as List<dynamic>? ?? const [];
      final changes = rawChanges
          .map(
            (e) => SyncChange.fromWire(Map<String, dynamic>.from(e as Map)),
          )
          .toList(growable: false);

      var sawLocation = false;
      for (final change in changes) {
        if (change.entityType == SyncEntityType.location) {
          sawLocation = true;
        }
        await _store.applyRemote(change);
      }
      if (sawLocation) {
        await _store.recomputeAllLocationPaths();
      }

      final cursor = pullBody['cursor'] as String? ?? state.cursor;
      await _store.advanceCursor(
        cursor: cursor,
        markInitialComplete: true,
      );

      return SyncResult(
        pushed: pushed,
        pulled: changes.length,
        cursor: cursor,
      );
    } on Object catch (error) {
      return SyncResult(
        pushed: 0,
        pulled: 0,
        cursor: state.cursor,
        errorMessage: error.toString(),
      );
    }
  }
}
