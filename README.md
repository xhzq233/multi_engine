# multi_engine

two-way communication between multiple Flutter engines;

# Principles

Static methods to allow for simple sharing of [SendPort]s across [Isolate]s.

All isolates share a global mapping of names to ports. An isolate can
register a [SendPort] with a given name using [registerPortWithName];
another isolate can then look up that port using [lookupPortByName].

```cpp

// Flutter Side
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

```