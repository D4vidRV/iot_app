class Dht11Data {
  double temperature;
  double humidity;
  DateTime date;

  Dht11Data(
      {required this.temperature, required this.humidity, required this.date});

  Dht11Data copyWith({
    double? temperature,
    double? humidity,
    DateTime? date,
  }) =>
      Dht11Data(
          temperature: temperature ?? this.temperature,
          humidity: humidity ?? this.humidity,
          date: date ?? this.date);

  factory Dht11Data.fromJson(Map<String, dynamic> json) => Dht11Data(
        temperature: json["temperature"]?.toDouble(),
        humidity: json["humidity"]?.toDouble(),
        date: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "humidity": humidity,
      };
}
