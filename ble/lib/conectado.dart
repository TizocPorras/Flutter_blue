import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Conectado extends StatelessWidget {
  final BluetoothDevice device;
  const Conectado({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            initialData: BluetoothDeviceState.connecting,
            stream: device.state,
            builder: (context, snapshot) {
              Function()? onPress;
              String? text0;

              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPress = () => device.disconnect();
                  text0 = "No conectado";
                  break;
                case BluetoothDeviceState.disconnected:
                  onPress = () => device.connect();
                  text0 = "Conectado";
                  break;
                default:
                  text0 = "error";
                  onPress = null;
              }
              return TextButton(onPressed: onPress, child: Text(text0));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      leading:
                          ((snapshot.data == BluetoothDeviceState.connected)
                              ? const Icon(Icons.zoom_out)
                              : const Icon(Icons.zoom_in)),
                      title: Text(device.name),
                      subtitle: Text(device.id.toString()),
                      trailing: StreamBuilder<bool>(
                        stream: device.isDiscoveringServices,
                        initialData: false,
                        builder: (context, snapshot) => IndexedStack(
                          index: snapshot.data! ? 1 : 0,
                          children: <Widget>[
                            TextButton(
                              child: const Text("Caracteristicas"),
                              onPressed: () => device.discoverServices(),
                            ),
                            const IconButton(
                              icon: SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey),
                                ),
                              ),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<List<BluetoothService>>(
                      stream: device.services,
                      initialData: const [],
                      builder: (c, snapshot) {
                        return Column(
                          children: caracteristicas(snapshot.data!),
                        );
                      },
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> caracteristicas(List<BluetoothService> services) {
    return services
        .map((e) => Column(
              children: [
                ListTile(
                  title: const Text("OFF"),
                  onTap: () {
                    debugPrint(e.characteristics.toString());
                    e.characteristics[0].write([0]);
                  },
                ),
                ListTile(
                  title: const Text("ON"),
                  onTap: () {
                    debugPrint(e.characteristics.toString());
                    e.characteristics[0].write([1]);
                  },
                ),
                ListTile(
                  title: const Text("READ"),
                  onTap: () async {
                    Future.delayed(
                      const Duration(seconds: 2),
                      () async {
                        debugPrint(e.characteristics.toString());
                        List<int> data = await e.characteristics[0].read();
                        debugPrint(utf8.decode(data));
                      },
                    );
                  },
                ),
              ],
            ))
        .toList();
  }
}//end class