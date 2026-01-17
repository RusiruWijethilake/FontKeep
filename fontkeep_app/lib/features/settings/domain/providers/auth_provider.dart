import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fontkeep_app/features/settings/data/repositories/auth_repository.dart';
import 'package:fontkeep_app/features/settings/domain/models/sync_config.dart';

import '../../../../core/storage/secure_storage_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(storage);
});

// 2. Auth State (SyncConfig)
final syncConfigProvider =
    StateNotifierProvider<SyncConfigNotifier, SyncConfig>((ref) {
      return SyncConfigNotifier(ref);
    });

class SyncConfigNotifier extends StateNotifier<SyncConfig> {
  final Ref ref;

  SyncConfigNotifier(this.ref) : super(const SyncConfig()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final repo = ref.read(authRepositoryProvider);
    final clientId = await repo.getClientId();
    final isLoggedIn = await repo.isLoggedIn();

    state = state.copyWith(
      clientId: clientId?.identifier,
      clientSecret: clientId?.secret,
      isEnabled: isLoggedIn,
    );
  }

  Future<void> saveKeys(String id, String secret) async {
    await ref.read(authRepositoryProvider).saveCustomCredentials(id, secret);
    state = state.copyWith(clientId: id, clientSecret: secret);
  }

  Future<void> signIn() async {
    try {
      await ref.read(authRepositoryProvider).signIn();
      state = state.copyWith(isEnabled: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = state.copyWith(isEnabled: false);
  }
}
