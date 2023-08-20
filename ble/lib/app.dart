import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'encendido.dart';
import 'noencendido.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: StreamBuilder(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          BluetoothState? estado = snapshot.data;
          if (estado == BluetoothState.on) {
            //bluetooth encendido
            return Encendido(blue: FlutterBlue.instance);
          } else {
            // bluetooth apagado
            return NoEncendido();
          }
        },
      ),
    );
  }
}
