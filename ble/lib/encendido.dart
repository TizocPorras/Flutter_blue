import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'conectado.dart';

// Cuando esta encendido el bluetooth buscamos los dispositivos y los mostramos

class Encendido extends StatefulWidget {
  final FlutterBlue blue;
  const Encendido({super.key, required this.blue});

  @override
  State<Encendido> createState() => _EncendidoState();
}

class _EncendidoState extends State<Encendido> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.blue.startScan(timeout: const Duration(seconds: 6));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispositivos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: widget.blue.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                return Column(
                  children: snapshot.data!
                      .map((e) => CupertinoButton(
                            onPressed: () {
                              e.device.connect();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Conectado(device: e.device),
                                  ));
                            },
                            child: Text(e.device.name.isEmpty
                                ? "Desconocido"
                                : e.device.name),
                          ))
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
