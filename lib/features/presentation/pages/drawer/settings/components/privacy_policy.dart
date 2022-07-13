import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: const EdgeInsets.symmetric(vertical: 30),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 80,
        child: WebView(
          initialUrl: "https://www.privacypolicies.com/live/1998729d-3854-4c84-81ee-8749bf087985",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
