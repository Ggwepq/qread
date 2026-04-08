import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logic/qr_parser.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/utils/wifi_helper.dart';

class ResultDialog extends StatelessWidget {
  final QRResult result;
  final VoidCallback onDismiss;

  const ResultDialog({
    super.key,
    required this.result,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(_getIcon(), color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(_getTitle()),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              result.value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (result.type == QRType.wifi) ...[
            const SizedBox(height: 12),
            Text('Security: ${result.metadata?['T'] ?? 'None'}'),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: result.value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          },
          child: const Text('Copy'),
        ),
        ElevatedButton(
          onPressed: () => _handleAction(context),
          child: Text(_getActionLabel()),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (result.type) {
      case QRType.wifi: return Icons.wifi;
      case QRType.url: return Icons.link;
      case QRType.text: return Icons.text_fields;
    }
  }

  String _getTitle() {
    switch (result.type) {
      case QRType.wifi: return 'WiFi Network';
      case QRType.url: return 'Web Link';
      case QRType.text: return 'Scanned Text';
    }
  }

  String _getActionLabel() {
    switch (result.type) {
      case QRType.wifi: return 'Connect';
      case QRType.url: return 'Open Link';
      case QRType.text: return 'Done';
    }
  }

  Future<void> _handleAction(BuildContext context) async {
    switch (result.type) {
      case QRType.wifi:
        final ssid = result.value;
        final pass = result.metadata?['P'] ?? '';
        final security = result.metadata?['T'] ?? 'WPA';
        
        final success = await WifiHelper.connectToWifi(
          ssid: ssid,
          password: pass,
          security: security,
        );
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(success ? 'Connecting...' : 'Failed to connect')),
          );
          onDismiss();
          Navigator.of(context).pop();
        }
        break;

      case QRType.url:
        await UrlHelper.launchString(result.value);
        if (!context.mounted) return;
        onDismiss();
        Navigator.of(context).pop();
        break;

      case QRType.text:
        onDismiss();
        Navigator.of(context).pop();
        break;
    }
  }
}
