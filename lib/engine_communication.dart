/// multi_engine - engine_communication
/// Created by xhz on 9/21/24

import 'dart:isolate';
import 'dart:ui';

import 'multi_engine.g.dart';


void newEngine(String name) {
  MultiEngineApi().spawnEngine(name);

  // 1. Spawn two-way engine communication
  final SendPort? sendPort = IsolateNameServer.lookupPortByName(name);

  if (sendPort == null) {
    throw Exception('Could not find port for name: $name');
  }

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  // 2. Listen for messages from the other isolate
  receivePort.listen((message) {

  });
}

@pragma('vm:entry-point')
void _secondaryEntry(List<String> args) {
  // 1. Spawn two-way engine communication
  final sendPortName = args[0];
  final receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, sendPortName);

  // 2. Listen for messages from the other isolate
  receivePort.listen((message) {
    // 3. Handle messages from the other isolate
    if (message is SendPort) {
      // 4. Send messages to the other isolate
    }
  });
}