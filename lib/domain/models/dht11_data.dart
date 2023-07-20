class Dht11Data {
  double temperature;
  double humidity;

  Dht11Data({
    required this.temperature,
    required this.humidity,
  });

  Dht11Data copyWith({
    double? temperature,
    double? humidity,
  }) =>
      Dht11Data(
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
      );

  factory Dht11Data.fromJson(Map<String, dynamic> json) => Dht11Data(
        temperature: json["temperature"]?.toDouble(),
        humidity: json["humidity"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "humidity": humidity,
      };
}
