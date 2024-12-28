/// multi_engine - engine_communication
/// Created by xhz on 9/21/24

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'multi_engine.g.dart';

void newEngine(String name) async {
  final receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, name);
  await MultiEngineApi().spawnEngine(name);

  SendPort? secondarySendPort;
  receivePort.listen((message) {
    if (message is SendPort) {
      secondarySendPort ??= message;
    }
  });
}

@pragma('vm:entry-point')
void _secondaryEntry(List<String> args) {
  final primarySendPortName = args[0];
  final secondaryReceivePort = ReceivePort();
  final primarySendPort = IsolateNameServer.lookupPortByName(primarySendPortName);
  if (primarySendPort == null) {
    throw Exception('Unable to find primarySendPort');
  }

  primarySendPort.send(secondaryReceivePort.sendPort);
  secondaryReceivePort.listen((message) {});
}
