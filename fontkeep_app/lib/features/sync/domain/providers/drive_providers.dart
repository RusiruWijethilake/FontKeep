import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/features/settings/domain/providers/auth_provider.dart';

import '../../../library/domain/providers/library_providers.dart';
import '../../data/repositories/drive_repository.dart';

final driveRepositoryProvider = Provider<DriveRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final db = ref.watch(appDatabaseProvider);
  final fontRepo = ref.watch(fontRepositoryProvider);

  return DriveRepository(authRepo, db, fontRepo);
});
