import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/api_endpoints.dart';

class ContactService {
  static void onTapHubungiAdmin() async {
    await canLaunchUrl(Uri.parse(ApiEndpoints.hubungiAdmin))
        ? launchUrl(
            Uri.parse(ApiEndpoints.hubungiAdmin),
            mode: LaunchMode.externalApplication,
          )
        : debugPrint("Can't open WhatsApp");
  }
}
