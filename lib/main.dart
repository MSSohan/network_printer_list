import 'package:flutter/material.dart';
import 'printer_discovery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> printerList = [];

  @override
  void initState() {
    super.initState();
    listPrinters();
  }

  Future<void> listPrinters() async {
    try {
      final list = await NetworkPrinterDiscovery.listPrinters();
      print(list);
      setState(() {
        printerList = list;
      });
    } catch (e) {
      print('Error listing printers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Printer List'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (printerList.isEmpty)
                CircularProgressIndicator()
              else
                for (var printer in printerList)
                  Text(printer),
            ],
          ),
        ),
      ),
    );
  }
}
