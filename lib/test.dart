import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

dynamic temp;
dynamic gas;
dynamic hum;
bool lol = true;
String text = '';

class TestHome extends StatefulWidget {
  const TestHome({Key? key}) : super(key: key);

  @override
  State<TestHome> createState() => TestScreen();
}

class TestScreen extends State<TestHome> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference tempRef = database.ref('readings/temp');

    tempRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        temp = data;
      });
    });
    DatabaseReference turbRef = database.ref('readings/gas');
    turbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        gas = data;
      });
    });
    DatabaseReference humRef = database.ref('readings/gas');
    humRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        hum = data;
      });
    });
  }

  // Generate some dummy data for the chart
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the blue line
  final List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CH4 Readings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // The red line
                LineChartBarData(
                  spots: dummyData1,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.red,
                ),
                // The orange line
                LineChartBarData(
                  spots: dummyData2,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.orange,
                ),
                // The blue line
                LineChartBarData(
                  spots: dummyData3,
                  isCurved: false,
                  barWidth: 3,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
