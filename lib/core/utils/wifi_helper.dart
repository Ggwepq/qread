import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io';

class WifiHelper {
  static Future<bool> connectToWifi({
    required String ssid,
    required String password,
    String security = 'WPA',
  }) async {
    if (Platform.isAndroid) {
      bool connected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: _parseSecurity(security),
        joinOnce: false,
      );
      return connected;
    } else if (Platform.isIOS) {
      // iOS doesn't allow programmatic connection to arbitrary SSIDs without some limitations,
      // but WiFiForIoTPlugin tries its best or we can suggest user to join.
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: _parseSecurity(security),
        joinOnce: true,
      );
    }
    return false;
  }

  static NetworkSecurity _parseSecurity(String security) {
    switch (security.toUpperCase()) {
      case 'WPA':
      case 'WPA2':
        return NetworkSecurity.WPA;
      case 'WEP':
        return NetworkSecurity.WEP;
      default:
        return NetworkSecurity.NONE;
    }
  }
}
