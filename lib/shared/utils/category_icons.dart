import 'package:flutter/material.dart';

/// Mapping icon_key kategori ke Material Icons
class CategoryIcons {
  CategoryIcons._();

  static IconData getIcon(String? iconKey) {
    return _iconMap[iconKey] ?? Icons.category_rounded;
  }

  static const Map<String, IconData> _iconMap = {
    'charging': Icons.battery_charging_full_rounded,
    'display': Icons.phone_android_rounded,
    'touchscreen': Icons.touch_app_rounded,
    'signal': Icons.signal_cellular_alt_rounded,
    'audio': Icons.volume_up_rounded,
    'camera': Icons.camera_alt_rounded,
    'wifi_bt': Icons.wifi_rounded,
    'power': Icons.power_rounded,
    'baseband': Icons.sim_card_rounded,
    'fingerprint': Icons.fingerprint_rounded,
    'full_schematic': Icons.memory_rounded,
    'other': Icons.more_horiz_rounded,
  };
}
