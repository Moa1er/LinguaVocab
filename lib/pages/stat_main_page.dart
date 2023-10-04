import 'package:flutter/material.dart';
import 'package:vocab_language_tester/pages/stat_indiv_page.dart';
import 'package:vocab_language_tester/services/statistic_service.dart';

class StatMainPage extends StatefulWidget {
  const StatMainPage({Key? key}) : super(key: key);

  @override
  State<StatMainPage> createState() => _StatMainPageState();
}

class _StatMainPageState extends State<StatMainPage> {
  StatisticService statisticService = StatisticService();
  late Set<String> uniqueTags;

  @override
  void initState() {
    super.initState();
    uniqueTags = statisticService.statsData.map((stat) => stat.tags).toSet();
  }

  void seeIndivStats(String tags) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StatIndivPage(
      tagPassed: tags,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats Tag List'),
      ),
      body: ListView.builder(
        itemCount: uniqueTags.length,
        itemBuilder: (context, index) {
          String tags = uniqueTags.elementAt(index);
          return ListTile(
            title: Text(tags),
            onTap: () => seeIndivStats(tags),
          );
        },
      ),
    );
  }
}
