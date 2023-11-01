import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kotlin Call from Dart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kotlin Call from Dart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = '';
  static const platform = MethodChannel('example.com/channel');

  Future<void> _generateRandomString() async {
    String random = '';
    String printer = '';
    try {
      var arguments = {
        'len': 4,
        'prefix': 'up_',
      };
      random = await platform.invokeMethod('getRandom', arguments);
      print(random.characters);

    } on PlatformException catch (e) {
      random = '';
    }
    setState(() {
      _counter = random;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Kotlin generates the following string:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateRandomString,
        tooltip: 'Generate',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}