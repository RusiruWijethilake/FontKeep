import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:fontkeep_app/features/sync/data/repositories/transfer_repository.dart';

import '../../data/repositories/discovery_repository.dart';
import '../models/nearby_device.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository();
});

final nearbyDevicesProvider = StreamProvider.autoDispose<List<NearbyDevice>>((
  ref,
) {
  final repo = ref.watch(discoveryRepositoryProvider);
  return repo.nearbyDevices;
});

final syncControllerProvider = StateNotifierProvider<SyncController, bool>((
  ref,
) {
  return SyncController(ref);
});

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final fontRepo = ref.watch(fontRepositoryProvider);
  return TransferRepository(db, fontRepo, ref.watch(loggerProvider));
});

class SyncController extends StateNotifier<bool> {
  late DiscoveryRepository _discoveryRepo;
  late TransferRepository _transferRepo;
  late LoggerService _loggerService;
  final Ref ref;

  SyncController(this.ref) : super(false) {
    _discoveryRepo = ref.read(discoveryRepositoryProvider);
    _transferRepo = ref.read(transferRepositoryProvider);
    _loggerService = ref.read(loggerProvider);
  }

  Future<void> toggleScan() async {
    if (state) {
      await _discoveryRepo.stop();
      await _transferRepo.stopServer();
      state = false;
    } else {
      await _transferRepo.startServer();
      await _discoveryRepo.start(_loggerService);
      state = true;
    }
  }

  Future<void> stopDiscovery() async {
    if (state) {
      await _discoveryRepo.stop();
      await _transferRepo.stopServer();
      state = false;
    }
  }

  @override
  void dispose() {
    ref.read(discoveryRepositoryProvider).stop();
    ref.read(transferRepositoryProvider).stopServer();
    super.dispose();
  }
}
