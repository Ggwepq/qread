enum QRType { wifi, url, text }

class QRResult {
  final QRType type;
  final String value;
  final Map<String, String>? metadata;

  QRResult({required this.type, required this.value, this.metadata});
}

class QRParser {
  static QRResult parse(String code) {
    if (code.startsWith('WIFI:')) {
      return _parseWifi(code);
    } else if (code.startsWith('http://') || code.startsWith('https://')) {
      return QRResult(type: QRType.url, value: code);
    } else {
      return QRResult(type: QRType.text, value: code);
    }
  }

  static QRResult _parseWifi(String code) {
    // WIFI:T:WPA;S:MySSID;P:password;;
    final Map<String, String> metadata = {};
    final content = code.substring(5);
    final parts = content.split(';');

    for (var part in parts) {
      if (part.contains(':')) {
        final kv = part.split(':');
        metadata[kv[0]] = kv[1];
      }
    }

    final ssid = metadata['S'] ?? 'Unknown WiFi';
    return QRResult(
      type: QRType.wifi,
      value: ssid,
      metadata: metadata,
    );
  }
}
