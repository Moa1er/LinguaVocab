import 'package:flutter/material.dart';
import 'package:vocab_language_tester/services/statistic_service.dart';

class StatisticsPage extends StatefulWidget {

  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

// class _StatisticsPageState extends State<StatisticsPage> {
//   StatisticService statisticService = StatisticService();
//
//   // Variables to handle sorting
//   bool _sortAscending = true;
//
//   void _onSort(int columnIndex, bool ascending) {
//     setState(() {
//       if (columnIndex == 0) {
//         // Sort by tags
//         statisticService.statsData.sort((a, b) => a.tags.compareTo(b.tags));
//       } else if (columnIndex == 1) {
//         // Sort by success rate
//         statisticService.statsData.sort((a, b) => a.successRate.compareTo(b.successRate));
//       } else if (columnIndex == 2) {
//         // Sort by average response time
//         statisticService.statsData.sort((a, b) => a.avgRespTime.compareTo(b.avgRespTime));
//       }
//
//       if (_sortAscending == ascending) {
//         statisticService.statsData = statisticService.statsData.reversed.toList();
//       }
//       _sortAscending = !_sortAscending;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Statistics'),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           DataTable(
//             columnSpacing: 20,
//             columns: [
//               DataColumn(
//                 label: const Text('Tags'),
//                 onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
//               ),
//               DataColumn(
//                 label: const Text('Success Rate'),
//                 onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
//               ),
//               DataColumn(
//                 label: const Text('Avg Time'),
//                 onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
//               ),
//             ],
//             rows: statisticService.statsData.map((data) {
//               return DataRow(cells: [
//                 DataCell(SizedBox(width: 130, child: Text(data.tags.isEmpty ? "ALL TAGS" : data.tags))),
//                 DataCell(Text('${data.successRate.toStringAsFixed(2)} %')),
//                 DataCell(Text('${data.avgRespTime.toString()} ms')),
//               ]);
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _StatisticsPageState extends State<StatisticsPage> {
  StatisticService statisticService = StatisticService();

  // Variables to handle sorting
  bool _sortAscending = true;

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 0) {
        // Sort by tags
        statisticService.statsData.sort((a, b) => a.tags.compareTo(b.tags));
      } else if (columnIndex == 1) {
        // Sort by success rate
        statisticService.statsData.sort((a, b) => a.successRate.compareTo(b.successRate));
      } else if (columnIndex == 2) {
        // Sort by average response time
        statisticService.statsData.sort((a, b) => a.avgRespTime.compareTo(b.avgRespTime));
      }

      if (_sortAscending == ascending) {
        statisticService.statsData = statisticService.statsData.reversed.toList();
      }
      _sortAscending = !_sortAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: const Text('Tags'),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text('Success Rate'),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text('Avg Time'),
                  onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
                ),
              ],
              rows: statisticService.statsData.map((data) {
                return DataRow(cells: [
                  DataCell(SizedBox(width: 130, child: Text(data.tags.isEmpty ? "ALL TAGS" : data.tags))),
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





