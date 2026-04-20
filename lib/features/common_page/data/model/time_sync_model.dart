class TimeSyncModel {
  final DateTime serverTime;
  TimeSyncModel({required this.serverTime});

  factory TimeSyncModel.fromJson(Map<String, dynamic> json) {
    return TimeSyncModel(
      serverTime: DateTime.parse(json['server_time']),
    );
  }
}
