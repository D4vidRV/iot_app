// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_app/domain/models/dht11_data.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Proveedor del StateNotifier
final mqttProvider = StateNotifierProvider<MqttNotifier, Dht11Data>((ref) {
  return MqttNotifier();
});

// StateNotifier para manejar el estado del objeto Dht11Data
class MqttNotifier extends StateNotifier<Dht11Data> {
  MqttNotifier() : super(Dht11Data(temperature: 0, humidity: 0));

  void updateData(Dht11Data data) {
    state = state.copyWith(
      temperature: data.temperature,
      humidity: data.humidity,
    );
  }
}

// Conexión y StreamProvider MQTT
final mqttStreamProvider = StreamProvider<Dht11Data>((ref) async* {
  final mqttClient = MqttServerClient('192.168.0.120', 'client_flutter');

  mqttClient.logging(on: true);

  try {
    await mqttClient.connect('userautomatikos2', 'passautomatikos2');
  } on NoConnectionException catch (e) {
    print('NoConnectionException - $e');
    throw Exception('Failed to connect to MQTT broker.');
  } on SocketException catch (e) {
    print('SocketException exception - $e');
    throw Exception('Failed to connect to MQTT broker.');
  }

  if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
    print('Flutter client connected');
  } else {
    print(
        'Flutter client connection failed - disconnecting, status is ${mqttClient.connectionStatus}');
    mqttClient.disconnect();
    throw Exception('Failed to connect to MQTT broker.');
  }

  const topic = 'dht11';
  mqttClient.subscribe(topic, MqttQos.atLeastOnce);

  await for (final List<MqttReceivedMessage<MqttMessage>> c
      in mqttClient.updates!) {
    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payloadString =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    final payloadJson = jsonDecode(payloadString);
    final sensorData = Dht11Data.fromJson(payloadJson);

    yield sensorData;
  }
});
