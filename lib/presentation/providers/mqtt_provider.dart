// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_app/domain/models/dht11_data.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final mqttClient = MqttServerClient('192.168.0.120', 'client_flutter');

final mqttStreamProvider = StreamProvider<Dht11Data>((ref) async* {
  mqttClient.logging(on: true);

  // Crea un stream controlador para recibir las actualizaciones de MQTT
  final streamController = StreamController<Dht11Data>();

  // Configuración y autenticación del cliente MQTT...
  try {
    await mqttClient.connect('userautomatikos2', 'passautomatikos2');
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('NoConnectionException - $e');
    mqttClient.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('SocketException exception - $e');
    mqttClient.disconnect();
  }

  // Verificar conexion mqtt
  if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
    print('Flutter client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'Flutter client connection failed - disconnecting, status is ${mqttClient.connectionStatus}');
    mqttClient.disconnect();
    exit(-1);
  }

  /// Ok, lets try a subscription
  const topic = 'dht11';
  mqttClient.subscribe(topic, MqttQos.atLeastOnce);

  mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payloadString =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    final payloadJson = jsonDecode(payloadString);
    print('Received message: $payloadString');

    final sensorData = Dht11Data(
      temperature: payloadJson['temperature'],
      humidity: payloadJson['humidity'],
    );

    // Añade el valor al flujo de datos
    streamController.add(sensorData);
  });

  // Devuelve el flujo de datos
  yield* streamController.stream;
});
