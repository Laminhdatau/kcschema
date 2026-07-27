/// Data kategori default yang akan di-seed saat database pertama kali dibuat.
/// Kategori ini sesuai dengan blok rangkaian umum pada skematik HP.
class SeedData {
  SeedData._();

  /// 12 kategori default untuk blok rangkaian skematik HP
  static const List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Charging / Data (Charging Ways)', 'icon_key': 'charging'},
    {'name': 'LCD / Display', 'icon_key': 'display'},
    {'name': 'Touchscreen', 'icon_key': 'touchscreen'},
    {'name': 'Power Amplifier (PA) / Sinyal', 'icon_key': 'signal'},
    {'name': 'Audio (Mic, Speaker, Earpiece)', 'icon_key': 'audio'},
    {'name': 'Camera', 'icon_key': 'camera'},
    {'name': 'WiFi / Bluetooth', 'icon_key': 'wifi_bt'},
    {'name': 'Power / PMIC / EFUSE', 'icon_key': 'power'},
    {'name': 'Baseband / IMEI', 'icon_key': 'baseband'},
    {'name': 'Fingerprint', 'icon_key': 'fingerprint'},
    {'name': 'Full Schematic', 'icon_key': 'full_schematic'},
    {'name': 'Lainnya', 'icon_key': 'other'},
  ];
}
