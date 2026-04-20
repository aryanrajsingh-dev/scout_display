import 'dart:async';

//import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/sync_time.dart';

class TimeSyncNotifier extends StateNotifier<Duration> {
  final SyncTime syncTime;

  Timer? _timer;
  bool _syncInFlight = false;

  TimeSyncNotifier(this.syncTime) : super(Duration.zero);

  /// Start polling server time repeatedly until [stop] (or dispose) is called.
  void start({Duration interval = const Duration(seconds: 1)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => sync());
    sync();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> sync() async {
    if (_syncInFlight) return;
    _syncInFlight = true;

    print("Triggering time sync");

    try {
      final offset = await syncTime();

      final deviceTime = DateTime.now();
      final correctedTime = deviceTime.add(offset);

      print("Offset        : $offset");
      print("Device time   : $deviceTime");
      print("Corrected time: $correctedTime");

      state = offset;

      print("Offset stored in state: $state");
    } finally {
      _syncInFlight = false;
    }
  }

  DateTime get correctedTime {
    return DateTime.now().add(state);
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}