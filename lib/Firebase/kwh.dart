class Kwh {
  DateTime sec;
  final dynamic ec;
  final dynamic cur_hour_energy;
  final dynamic all_energy;
  final dynamic thirty_day_enrgy;

  Kwh(this.sec, this.ec, this.cur_hour_energy, this.all_energy,
      this.thirty_day_enrgy);
  factory Kwh.fromMap(Map<dynamic, dynamic> dataMap) {
    return Kwh(
        DateTime.parse(dataMap['Time']),
        dataMap['EC'],
        dataMap['current_hour_energy'],
        dataMap['all_energy'],
        dataMap['thirty_day_energy']);
  }
}
