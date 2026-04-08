import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/scanner/presentation/qr_scanner_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QRReaderApp());
}

class QRReaderApp extends StatelessWidget {
  const QRReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qread',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const QRScannerView(),
    );
  }
}
