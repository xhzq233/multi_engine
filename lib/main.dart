import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'multi_engine.g.dart';

void main() {
  runApp(Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: Colors.black26,
      child: ListView(
        children: [
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: newEngine,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    ),
  ));
}

void newEngine() async {
  const name = 'secondary';
  final receivePort = ReceivePort();
  final success = IsolateNameServer.registerPortWithName(receivePort.sendPort, name);
  if (!success) {
    throw Exception('Unable to register port with name: $name');
  }
  await MultiEngineApi().spawnEngine(name);

  SendPort? secondarySendPort;
  print('Waiting for secondarySendPort');
  receivePort.listen((message) {
    if (message is SendPort) {
      secondarySendPort ??= message;
      print('Received secondarySendPort $secondarySendPort');
      secondarySendPort?.send('Hello from primary engine');
    }
  });
}

class _SecondaryEntry extends StatelessWidget {
  const _SecondaryEntry();

  static ValueNotifier<String> message = ValueNotifier('None');

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: message,
      builder: (BuildContext context, Widget? child) => Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: Colors.black,
          child: Align(child: Text(message.value, style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void secondaryEntry(List<String> args) {
  final primarySendPortName = args[0];
  final secondaryReceivePort = ReceivePort();
  final primarySendPort = IsolateNameServer.lookupPortByName(primarySendPortName);
  if (primarySendPort == null) {
    throw Exception('Unable to find primarySendPort');
  }

  primarySendPort.send(secondaryReceivePort.sendPort);
  secondaryReceivePort.listen((message) {
    print('[secondaryEntry] Received message: $message');
    _SecondaryEntry.message.value = message.toString();
  });
  runApp(const _SecondaryEntry());
}
