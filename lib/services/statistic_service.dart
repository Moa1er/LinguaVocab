import 'package:flutter/material.dart';
import 'dart:io';
import '../classes/statistic_data.dart';
import '../globals/globals.dart' as globals;
import '../utils/file_manager.dart';

class StatisticService with ChangeNotifier {
  static final StatisticService _statisticService = StatisticService._internal();

  List<StatisticData> statsData = [];

  factory StatisticService(){
    return _statisticService;
  }

  StatisticService._internal();

  readStatsInFile() async{
    try {
      File file = File(globals.statisticsFilePath);
      List<String> lines = await file.readAsLines();

      // Process each line
      for (String line in lines) {
        List<String> stat = line.split(',');
        int idxTags = 0;
        int idxTimeStamp = 1;
        int idxSuccessRate = 2;
        int idxAvgTime = 3;
        statsData.add(
            StatisticData(
              tags: stat[idxTags],
              timestamp: int.parse(stat[idxTimeStamp]),
              successRate: double.parse(stat[idxSuccessRate]),
              avgRespTime: int.parse(stat[idxAvgTime]),
            )
        );
      }
    } catch (e) {
      print("Error reading stat file in readStatsInFile(): $e");
    }
  }

  saveStats(List<String>? selectedTags, double successRate, int avgRespTime){
    String tagsToWrite = "";
    if(selectedTags != null){
      tagsToWrite = selectedTags.join(";");
    }

    StatisticData statData = StatisticData(tags: tagsToWrite, timestamp: DateTime.now().millisecondsSinceEpoch, successRate: successRate, avgRespTime: avgRespTime);
    saveStatisticsToFile(statData);
    statsData.add(statData);
  }
}