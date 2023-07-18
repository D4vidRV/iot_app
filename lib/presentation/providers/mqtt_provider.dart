import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final mqttStreamProvider = StreamProvider<String>((ref) async* {
  final mqttClient = MqttServerClient('192.168.0.120', 'client_flutter');
  mqttClient.logging(on: true);

  // Crea un stream controlador para recibir las actualizaciones de MQTT
  final streamController = StreamController<String>();

  // Configuración y autenticación del cliente MQTT...
  try {
    await mqttClient.connect('userautomatikos2', 'passautomatikos2');
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('EXAMPLE::client exception - $e');
    mqttClient.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('EXAMPLE::socket exception - $e');
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
  const topic = 'aa';
  mqttClient.subscribe(topic, MqttQos.atMostOnce);

  mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payloadString =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final payloadJson = jsonDecode(payloadString);
    print('Received message: $payloadString from topic: ${c[0].toString()}');
    // Añade el valor al flujo de datos
    streamController.add(payloadJson['msg']);
  });

  // Devuelve el flujo de datos
  yield* streamController.stream;
});
