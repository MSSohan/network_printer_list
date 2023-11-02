import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  final MethodChannel methodChannel = MethodChannel('kotlin_printer_finder');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Network Printer Finder'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              // // Find all network printers.
              // final printers = await methodChannel.invokeMethod('findPrinters');
              //
              // // Print the list of printers.
              // printers.forEach((printer) {
              //   print(printer);
              // });
              // Get the IP address of the printer
              final printerIp = '192.168.68.144';

              // Create a new socket connection to the printer
              final socket = await Socket.connect(printerIp, 9100);

              // Send the PDF document to the printer
              final file = File('my-document.pdf');
              final data = await file.readAsBytes();
              socket.write(data);

              // Close the socket connection
              socket.close();
            },
            child: Text('Find Printers'),
          ),
        ),
      ),
    );
  }
}