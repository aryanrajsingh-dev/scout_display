class TimeSync{
  final DateTime serverTime;
  final Duration offset;

TimeSync({
  required this.serverTime,
  required this.offset,
});

DateTime get correctedTime => DateTime.now().add(offset);
}