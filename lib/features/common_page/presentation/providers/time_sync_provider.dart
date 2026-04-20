import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/sync_time.dart';
import '../notifier/time_sync_notifier.dart';
import '../../data/repositories/time_sync_repository_impl.dart';
import '../../data/data_sources/time_sync_remote_data_source_impl.dart';
import '../../data/data_sources/time_sync_remote_data_source.dart';

final timeSyncRemoteProvider = Provider<TimeSyncRemoteDataSource>((ref) {
  return TimeSyncRemoteDataSourceImpl(host: "127.0.0.1", port: 5000);
});

// Repository
final timeSyncRepositoryProvider = Provider((ref) {
  return TimeSyncRepositoryImpl(
    remoteDataSource: ref.read(timeSyncRemoteProvider),
  );
});

//  Usecase
final syncTimeProvider = Provider((ref) {
  return SyncTime(ref.read(timeSyncRepositoryProvider));
});

// Notifier
final timeSyncNotifierProvider =
    StateNotifierProvider<TimeSyncNotifier, Duration>(
      (ref) => TimeSyncNotifier(ref.read(syncTimeProvider)),
    );
