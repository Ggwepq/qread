import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> launchString(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  static bool isUrl(String text) {
    return text.startsWith('http://') || text.startsWith('https://');
  }
}
