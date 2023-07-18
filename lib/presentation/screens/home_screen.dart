import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../providers/mqtt_provider.dart';

final mqttClient = MqttServerClient('192.168.0.120:1883', 'client_flutter');

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: Column(
              children: [
                Text('DH35'),
                Row(
                  children: [
                    _CircularCustomIndicator(),
                    _CircularCustomIndicator(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircularCustomIndicator extends ConsumerWidget {
  const _CircularCustomIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttData = ref.watch(mqttStreamProvider);
    final mqttDataInt = double.parse(mqttData.value ?? '');

    print(mqttDataInt);
    return SizedBox(
      width: 180,
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: mqttDataInt / 100,
                strokeWidth: 15,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$mqttDataInt',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Text('Temperature')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
