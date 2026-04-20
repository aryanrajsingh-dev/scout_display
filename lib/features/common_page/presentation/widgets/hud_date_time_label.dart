import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_display/core/utils/date_time_format.dart';
import 'package:scout_display/features/common_page/presentation/providers/time_sync_provider.dart';

class HudDateTimeLabel extends ConsumerStatefulWidget {
  const HudDateTimeLabel({super.key, required this.height});

  final double height;

  @override
  ConsumerState<HudDateTimeLabel> createState() => _HudDateTimeLabelState();
}

class _HudDateTimeLabelState extends ConsumerState<HudDateTimeLabel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final fontSize = h * 0.44;

    final offset = ref.watch(timeSyncNotifierProvider);
    final corrected = DateTime.now().add(offset);

    return Text(
      formatDdMmYyyyHm(corrected),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        height: 1,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
        ],
      ),
    );
  }
}
