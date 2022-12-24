import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

dynamic temp;
dynamic gas;
dynamic hum;
class HumGraph extends StatefulWidget {
  const HumGraph({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  GraphScreen createState() => GraphScreen();
}
class GraphScreen extends State<HumGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    getData();
    super.initState();
    chartData = getChartData();
    //shown data delayed by 1 sec.
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: const Text('Humidity Graph'),
          automaticallyImplyLeading: false,
          leading: IconButton (
                 icon: const Icon(Icons.arrow_back), 
                 onPressed: () { 
                    Navigator.pop(context);
                 },
            ),
        ),
        body: SfCartesianChart(
          backgroundColor: Colors.white,
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              //data source, color, and x-y data assignment
              dataSource: chartData,
              color: Colors.red,
              xValueMapper: (LiveData reading, _) => reading.time,
              yValueMapper: (LiveData reading, _) => reading.data,
            )
          ],
          //x-axis grid view
          primaryXAxis: NumericAxis(
              //grid width
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              //interval
              interval: 1,
              //axis Title
              title: AxisTitle(text: 'Time (seconds)')),
          //y-axis grid view
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              //Tick Lines
              majorTickLines: const MajorTickLines(size: 0),
              //axis Title
              title: AxisTitle(text: 'Humidity (%)')),
        ),
      ),
    );
  }

  int time = 8;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, hum));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.data);
  final dynamic time; //must be an integer 'cause time (1,2,3,..)
  final dynamic data; //can have a decimal point
}
