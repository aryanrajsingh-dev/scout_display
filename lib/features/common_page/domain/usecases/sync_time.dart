//import 'dart:developer';
import '../repositories/time_sync_repository.dart';

class SyncTime {
  final TimeSyncRepository repository;

  SyncTime(this.repository);

  Future<Duration> call() async {
    final serverTime = await repository.getServerTime();
    final deviceTime = DateTime.now();

    final offset = serverTime.difference(deviceTime);
    //final correctedTime = deviceTime.add(offset);

    print('Time Sync Started');
    print('Server Time: ${serverTime.toLocal()}');
    // print('Device Time   : $deviceTime');
    // print('Offset        : $offset');
    // print('Corrected Time: $correctedTime');

    return offset;
  }
}