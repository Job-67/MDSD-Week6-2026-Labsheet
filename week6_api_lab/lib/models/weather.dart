class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // ดึงค่าจาก object ย่อย 'main' ออกมาก่อน (ต้อง cast เป็น Map<String, dynamic>)
    // และ cast ตัวเลขผ่าน num ก่อนเรียก .toDouble() เสมอ
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 'weather' เป็น List ต้องดึงสมาชิกตัวแรกออกมาก่อน
    final weatherList = json['weather'] as List<dynamic>;
    final firstWeather = weatherList.first as Map<String, dynamic>;
    final description = firstWeather['description'] as String;

    final cityName = json['name'] as String;

    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}
