import 'package:flutter/foundation.dart';
import 'qr_parser.dart';

class ScannerController extends ChangeNotifier {
  bool _isScanning = true;
  QRResult? _lastResult;

  bool get isScanning => _isScanning;
  QRResult? get lastResult => _lastResult;

  void onScan(String code) {
    if (!_isScanning) return;
    
    _lastResult = QRParser.parse(code);
    _isScanning = false;
    notifyListeners();
  }

  void resumeScanning() {
    _lastResult = null;
    _isScanning = true;
    notifyListeners();
  }
}
