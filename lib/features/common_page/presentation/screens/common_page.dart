import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/hud_sidebar.dart';
import '../providers/time_sync_provider.dart';

class CommonPage extends ConsumerStatefulWidget {
  const CommonPage({super.key});

  @override
  ConsumerState<CommonPage> createState() => _CommonPageState();
}

class _CommonPageState extends ConsumerState<CommonPage> {
  int _selectedIndex = 0;

  static const _items = <String>[
    'SYSTEM',
    'DRIVE',
    'POWER',
    'COMPUTE',
    'SENSOR',
    'COM',
    'ALERTS',
    'PAYLOAD',
  ];

  @override
  void initState() {
  super.initState();

  Future.microtask(() async {
    await ref.read(timeSyncNotifierProvider.notifier).sync();

    debugPrint("Time Sync Completed");
  });
}

  @override
  Widget build(BuildContext context) {
    final clampedIndex = _selectedIndex.clamp(0, _items.length - 1);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          IndexedStack(
            index: clampedIndex,
            children: [
              for (final _ in _items) const SizedBox.expand(),
            ],
          ),
          HudSidebar(
            items: _items,
            selectedIndex: clampedIndex,
            onSelect: (index) {
              setState(() => _selectedIndex = index);
            },
          ),
        ],
      ),
    );
  }
}