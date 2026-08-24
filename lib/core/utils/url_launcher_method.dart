import 'package:fitness_app/core/utils/app_toasts.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlMethod(String url) async {
  try {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception('Invalid URL');
    }
  } catch (e) {
    AppToast.error(title: "Error", description: 'Could not open page');
  }
}

final String appUrl =
    "https://play.google.com/store/apps/details?id=com.mycloudstorage.databackup.photo.video";
final String termsOfService =
    "https://yourbrownberry.com/brown_berry_privacy_policy.html";
final String privacyPolicy =
    "https://yourbrownberry.com/brown_berry_privacy_policy.html";
