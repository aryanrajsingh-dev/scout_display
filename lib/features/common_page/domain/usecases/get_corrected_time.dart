class GetCorrectedTime {
  final Duration offset;
  GetCorrectedTime(this.offset);

  DateTime call(){
    return DateTime.now().add(offset);
  }
}