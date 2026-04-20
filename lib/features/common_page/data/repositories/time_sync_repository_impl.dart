import '../../domain/repositories/time_sync_repository.dart';
import '../data_sources/time_sync_remote_data_source.dart';

class TimeSyncRepositoryImpl implements TimeSyncRepository {
  final TimeSyncRemoteDataSource remoteDataSource;

  TimeSyncRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DateTime> getServerTime(){
    return remoteDataSource.fetchServerTime();
  }
}