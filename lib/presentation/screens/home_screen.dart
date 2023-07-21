import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_app/presentation/providers/mqtt_state_notifier_provider.dart';
import 'package:iot_app/presentation/widgets/temperature_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: const Center(
        child: _HomeView(),
      ),
    );
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttTopic = ref.watch(mqttStremProviderList);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _DeviceCustomCard(
              deviceName: 'DHT22',
              metricWidgets: [
                _CustomCircularIndicator(
                  mqttData: mqttTopic.value?.last.temperature ?? 0.0,
                  metricName: 'Temperature',
                  metric: '°C',
                ),
                _CustomCircularIndicator(
                  mqttData: mqttTopic.value?.last.humidity ?? 0.0,
                  metricName: 'Humidity',
                  metric: '%',
                ),
              ],
              metricName: 'Temperature'),
        ),
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: _DeviceCustomCard(
              deviceName: 'Temperature in °C',
              metricName: '',
              metricWidgets: [TemperatureChart()],
            )),
      ],
    );
  }
}

class _DeviceCustomCard extends StatelessWidget {
  final String deviceName;
  final String metricName;
  final List<Widget> metricWidgets;
  const _DeviceCustomCard(
      {required this.metricWidgets,
      required this.deviceName,
      required this.metricName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Text(deviceName),
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [...metricWidgets],
          ),
        ],
      ),
    );
  }
}

class _CustomCircularIndicator extends StatelessWidget {
  const _CustomCircularIndicator({
    required this.mqttData,
    required this.metricName,
    required this.metric,
  });

  final double mqttData;
  final String metricName;
  final String metric;

  @override
  Widget build(BuildContext context) {
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
              child: FadeInLeft(
                child: CircularProgressIndicator(
                  value: mqttData / 100,
                  strokeWidth: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$mqttData $metric',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(metricName)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
