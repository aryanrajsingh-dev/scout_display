String formatHms(Duration d) {
  final totalSeconds = d.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(hours)}:${two(minutes)}:${two(seconds)}';
}
