class Amps {
  DateTime sec;
  final dynamic cur;
  final dynamic vol;

  Amps(this.sec, this.cur, this.vol);
  factory Amps.fromMap(Map<dynamic, dynamic> dataMap) {
    return Amps(DateTime.parse(dataMap['Time']), dataMap['current'],
        dataMap['voltage']);
  }
}
