import 'dart:async';
import 'dart:io';

import 'package:comm_module/comm_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mavlink_nrt/dialects/ardupilotmega.dart';
import 'package:mavlink_nrt/mavlink.dart';

import 'features/common_page/presentation/screens/common_page.dart';
import 'features/common_page/presentation/widgets/app_background.dart';

Future<void> main() async {
  final transport = UdpTransport(address: InternetAddress.anyIPv4, port: 7000, remoteAddress: InternetAddress("192.168.168.99"), remotePort: 7500);
  transport.connect();

  final MavlinkDialect ardupilotDialect = MavlinkDialectArdupilotmega();
  final arduPilotParser = MavlinkParser(ardupilotDialect);

  transport.onData.listen((data) {
    print("Raw bytes from transport: $data");
    arduPilotParser.parse(data);
  });

  int? t1; // last sent timestamp (ns)
  int seq = 0; // MAVLink sequence counter

// --- SEND TIMESYNC REQUEST ---
  void sendTimesync() {
    t1 = DateTime.now().microsecondsSinceEpoch;

    final msg = Timesync(
      tc1: 0,
      ts1: t1!,
      targetSystem: 0,
      targetComponent: 0,
    );

    final frame = MavlinkFrame.v2(
      seq = (seq + 1) & 0xFF,
      255, // your system id
      190, // your component id
      msg,
    );

    print("sending ts1= $t1");
    transport.send(frame.serialize());
  }

// --- HANDLE INCOMING MAVLINK FRAMES ---
  arduPilotParser.stream.listen((frame) async {
    final message = frame.message;

    if (message is! Timesync) return;
    final now = DateTime.now().microsecondsSinceEpoch;

    print(
        "[Timesync received → tc1=${message.tc1}, ts1=${message.ts1}, local_t1=$t1"
    );

    // CASE 1: Incoming request → reply
    if (message.tc1 == 0) {
      print("Hitting Case 1");
      final reply = Timesync(
        tc1: message.ts1,
        ts1: now,
        targetSystem: frame.systemId,
        targetComponent: frame.componentId,
      );

      final replyFrame = MavlinkFrame.v2(
        seq++,
        255,
        190,
        reply,
      );

      await transport.send(replyFrame.serialize());
    }
    // CASE 2: Response → compute offset
    else if (t1 != null && message.ts1 == t1) {
      print('Hitting case 2');
      final t3 = now;
      final t2 = message.ts1;

      final offset = t2 - ((t1! + t3) ~/ 2); // us
      final rtt = t3 - t1!;                  // us

      print("Offset: $offset us, RTT: $rtt us");
    }
  });

// --- PERIODIC TIMESYNC ---
  Timer.periodic(const Duration(seconds: 10), (_) {
    sendTimesync();
  });

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scout Display',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      builder: (context, child) {
        return AppBackground(child: child ?? const SizedBox.shrink());
      },
      home: const CommonPage(),
    );
  }
}
