/// multi_engine - pigeon
/// Created by xhz on 9/21/24

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/multi_engine.g.dart',
  dartOptions: DartOptions(),
  swiftOut: 'ios/Runner/MultiEngine.g.swift',
  swiftOptions: SwiftOptions(),
))
@HostApi()
abstract class MultiEngineApi {
  void spawnEngine(String name);
}
