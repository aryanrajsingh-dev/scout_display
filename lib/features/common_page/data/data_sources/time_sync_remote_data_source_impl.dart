import 'dart:io';
import 'time_sync_remote_data_source.dart';

class TimeSyncRemoteDataSourceImpl
    implements TimeSyncRemoteDataSource {
  final String host;
  final int port;

  TimeSyncRemoteDataSourceImpl({
    required this.host,
    required this.port,
  });

  @override
  Future<DateTime> fetchServerTime() async {
    final socket = await Socket.connect(host, port);

    socket.write("GET_TIME");

    final response = await socket.first;
    socket.destroy();

    final timeString = String.fromCharCodes(response).trim();

    return DateTime.parse(timeString);
  }
}