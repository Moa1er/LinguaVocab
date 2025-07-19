import 'package:flutter/material.dart';
import 'package:vocab_language_tester/classes/statistic_data.dart';
import 'package:vocab_language_tester/services/statistic_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatIndivPage extends StatefulWidget {
  final String tagPassed;

  const StatIndivPage({
    Key? key,
    required this.tagPassed,
  }) : super(key: key);

  @override
  State<StatIndivPage> createState() => _StatIndivPageState();
}

class _StatIndivPageState extends State<StatIndivPage> {
  StatisticService statisticService = StatisticService();
  late List<StatisticData> dataForGivenTags;
  // Variables to handle sorting
  bool _sortAscending = true;

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    zoomMode: ZoomMode.x,  // Here, we're enabling zooming only on the x-axis; you can adjust as needed
  );

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 0) {
        // Sort by tags
        dataForGivenTags.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      } else if (columnIndex == 1) {
        // Sort by success rate
        dataForGivenTags.sort((a, b) => a.successRate.compareTo(b.successRate));
      } else if (columnIndex == 2) {
        // Sort by average response time
        dataForGivenTags.sort((a, b) => a.avgRespTime.compareTo(b.avgRespTime));
      }

      if (_sortAscending == ascending) {
        dataForGivenTags = dataForGivenTags.reversed.toList();
      }
      _sortAscending = !_sortAscending;
    });
  }

  @override
  void initState() {
    super.initState();
    dataForGivenTags =
        statisticService.statsData.where((item) => item.tags == widget.tagPassed).toList();
    dataForGivenTags.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tag Specific Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Stats for tags :${widget.tagPassed}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
              primaryXAxis: CategoryAxis(
                isVisible: false,
              ),
              // primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}%',
                title: AxisTitle(text: 'Success Rate'),
                minimum: 0,
                maximum: 100,
                labelStyle: const TextStyle(color: Colors.blue),
              ),
              axes: <ChartAxis>[
                NumericAxis(
                  opposedPosition: true,
                  name: 'AvgTime',
                  labelFormat: '{value}ms',
                  isInversed: true,
                  labelStyle: const TextStyle(color: Colors.red),
                ),
              ],
              series: <CartesianSeries>[
                LineSeries<StatisticData, String>(
                // LineSeries<StatisticData, DateTime>(
                  name: 'Success Rate',
                  color: Colors.blue,
                  dataSource: dataForGivenTags,
                  // xValueMapper: (data, _) => DateTime.fromMillisecondsSinceEpoch(data.timestamp),
                  xValueMapper: (data, _) => DateTime.fromMillisecondsSinceEpoch(data.timestamp).toString(),
                  yValueMapper: (data, _) => data.successRate,
                ),
                LineSeries<StatisticData, String>(
                // LineSeries<StatisticData, DateTime>(
                  name: 'Avg Time',
                  yAxisName: 'AvgTime',
                  color: Colors.red,
                  dataSource: dataForGivenTags,
                  // xValueMapper: (data, _) => DateTime.fromMillisecondsSinceEpoch(data.timestamp),
                  xValueMapper: (data, _) => DateTime.fromMillisecondsSinceEpoch(data.timestamp).toString(),
                  yValueMapper: (data, _) => data.avgRespTime,
                ),
              ],
            ),
            DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: const Text('Time'),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text(
                    'Success Rate',
                    style: TextStyle(
                      color: Colors.blue,  // Setting the text color to red
                    ),
                  ),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text(
                    'Avg Time',
                    style: TextStyle(
                      color: Colors.red,  // Setting the text color to red
                    ),
                  ),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
              ],
              rows: dataForGivenTags.map((data) {
                return DataRow(cells: [
                  DataCell(SizedBox(width: 130, child: Text(DateTime.fromMillisecondsSinceEpoch(data.timestamp).toString()))),
                  DataCell(Text('${data.successRate.toStringAsFixed(2)} %')),
                  DataCell(Text('${data.avgRespTime.toString()} ms')),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
