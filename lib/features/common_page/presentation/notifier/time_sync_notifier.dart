//import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/sync_time.dart';

class TimeSyncNotifier extends StateNotifier<Duration> {
  final SyncTime syncTime;

  TimeSyncNotifier(this.syncTime) : super(Duration.zero);

  Future<void> sync() async {
    print("Triggering time sync");

    final offset = await syncTime(); 

    final deviceTime = DateTime.now();
    final correctedTime = deviceTime.add(offset);

    print("Offset        : $offset");
    print("Device time   : $deviceTime");
    print("Corrected time: $correctedTime");

    state = offset;

    print("Offset stored in state: $state");
  }

  DateTime get correctedTime {
    return DateTime.now().add(state);
  }
}