import 'dart:async';

import 'package:flutter/services.dart';

class NetworkPrinterDiscovery {
  static const MethodChannel _channel = MethodChannel("network_printer_discovery");

  static Future<List<String>> listPrinters() async {
    final List<dynamic> printerList = await _channel.invokeMethod("listPrinters");
    //final List<dynamic> printerList = ['one', 'two'];
    print(printerList);

    return printerList.cast<String>();
  }
}