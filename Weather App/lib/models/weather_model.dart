class WeatherModel {
  final String gun;
  final String ikon;
  final String durum;
  final String derece;
  final String min;
  final String max;
  final String gece;
  final String nem;

  WeatherModel(
    this.gun,
    this.ikon,
    this.durum,
    this.derece,
    this.min,
    this.max,
    this.gece,
    this.nem,
  );

  WeatherModel.fromJson(Map<String, dynamic> json)
    : gun = json['day'].toString(),
      ikon = json['icon'].toString(),
      durum = json['description'].toString(),
      derece = json['degree'].toString(),
      min = json['min'].toString(),
      max = json['max'].toString(),
      gece = json['night'].toString(),
      nem = json['humidity'].toString();
}
