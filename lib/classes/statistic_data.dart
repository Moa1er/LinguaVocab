
class StatisticData {
  final String tags;
  final int timestamp;
  final double successRate;
  final int avgRespTime;

  StatisticData({
    required this.tags,
    required this.timestamp,
    required this.successRate,
    required this.avgRespTime,
  });
}