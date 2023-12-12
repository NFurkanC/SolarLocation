import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';
import 'dart:async';

void main() {
  return runApp(GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

/// Represents MyHomePage class
class MyHomePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double long1 = 0.0;
  Widget _getGauge({bool isRadialGauge = true}) {
    if (isRadialGauge) {
      return _getRadialGauge();
    } else {
      return _getLinearGauge();
    }
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
        title: GaugeTitle(
            text: 'Güneş Konumu',
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        //enableLoadingAnimation: true,
        //animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 360,
              startAngle: 180,
              endAngle: 540,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 90,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 90,
                    endValue: 180,
                    color: Colors.orange,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 180,
                    endValue: 270,
                    color: Colors.red,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 270,
                    endValue: 360,
                    color: Color.fromARGB(255, 131, 16, 202),
                    startWidth: 10,
                    endWidth: 10)
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: long1,
                  markerType: MarkerType.circle,
                  markerHeight: 40,
                  markerWidth: 40,
                  //markerOffset: 350,
                  color: Colors.amber,
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: const Text('G',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: 90,
                    positionFactor: 0.8),
                GaugeAnnotation(
                    widget: Container(
                        child: const Text('K',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: 270,
                    positionFactor: 0.8),
                GaugeAnnotation(
                    widget: Container(
                        child: const Text('D',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: 0,
                    positionFactor: 0.8),
                GaugeAnnotation(
                    widget: Container(
                        child: const Text('B',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: 180,
                    positionFactor: 0.8)
              ])
        ]);
  }

  Widget _getLinearGauge() {
    return Container(
      child: SfLinearGauge(
          minimum: 0.0,
          maximum: 360.0,
          orientation: LinearGaugeOrientation.horizontal,
          majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
          axisTrackStyle: LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: LinearEdgeStyle.bothFlat,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> availablePort = SerialPort.availablePorts;
    //List available ports.
    print('Available Ports: $availablePort');
    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    });
    SerialPort port1 = SerialPort('COM4');
    port1.openReadWrite();

    try {
      //Write data to serial port.
      /*print(
          "Written Bytes: ${port1.write(_stringToUint8List('Hello World!'))}");*/
      //Read data from serial port.

      SerialPortReader reader = SerialPortReader(port1);
      Stream<String> upcomingData = reader.stream.map((data) {
        return String.fromCharCodes(data);
      });

      upcomingData.listen((adata) {
        setState(() {
          long1 = double.parse('$adata');
        });
        print('Received: $adata');
      });
      //Close the serial port.
    } on SerialPortError catch (err, _) {
      print(SerialPort.lastError);
      port1.close();
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Güneş Konumlandırma Sistemi')),
        body: _getRadialGauge());
  }
}

Uint8List _stringToUint8List(String data) {
  List<int> codeUnits = data.codeUnits;
  Uint8List uint8list = Uint8List.fromList(codeUnits);
  return uint8list;
}
