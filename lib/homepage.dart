import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'graph_gas.dart';
import 'graph_hum.dart';
import 'graph_temp.dart';

dynamic temp;
dynamic gas;
dynamic hum;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => HomeScreen();
}

class HomeScreen extends State<MyHomePage> {
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
    DatabaseReference gasRef = database.ref('readings/gas');
    gasRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        gas = data;
      });
    });
    DatabaseReference humRef = database.ref('readings/hum');
    humRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        hum = data;
      });
    });
  }

  String text = "....";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Description:"),
                        content: Text(text),
                        actions: [
                          TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text("OK"))
                        ],
                      ));
            },
          ),
        ],
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 213, 198, 241),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 30,
                width: 30,
              ),
              //GAS
              Row(
                //Row 1
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Gas Reading:",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 228, 238),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    width: 170.0,
                    height: 60.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$gas',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
                width: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const GasGraph(title: 'Temperature Graph')),
                  );
                },
                child: const Text('Show Graph'),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 80,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              //TEMP
              Row(
                //Row 1
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Temperature Reading:",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 228, 238),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    width: 170.0,
                    height: 60.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$temp',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
                width: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TempGraph(title: 'Temperature Graph')),
                  );
                },
                child: const Text('Show Graph'),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 80,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              //HUM
              Row(
                //Row 1
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Humidity Reading:",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 228, 238),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    width: 170.0,
                    height: 60.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$hum',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
                width: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HumGraph(title: 'Humidity Graph')),
                  );
                },
                child: const Text('Show Graph'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
