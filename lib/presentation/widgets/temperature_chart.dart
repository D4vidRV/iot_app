import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_app/domain/models/dht11_data.dart';
import 'package:iot_app/presentation/providers/mqtt_state_notifier_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TemperatureChart extends ConsumerWidget {
  const TemperatureChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(mqttStremProviderList);
    final List<Dht11Data> dataList = asyncValue.when(
      data: (data) => data,
      loading: () => [],
      error: (error, stackTrace) => [],
    );

    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis:
              NumericAxis(labelFormat: '{value} °C', isVisible: false),
          series: <ChartSeries>[
            // Renders line chart
            LineSeries<Dht11Data, String>(
              dataSource: dataList,
              xValueMapper: (Dht11Data data, _) => '${data.date.second}s',
              yValueMapper: (Dht11Data data, _) => data.temperature,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
    );
  }
}
