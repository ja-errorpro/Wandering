import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'all_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  Future<void> _launchGmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'cycugdsc@gmail.com',
      query: Uri.encodeFull('subject=使用者回饋&body=請在此輸入您的訊息...'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // 可顯示錯誤提示
      debugPrint('無法開啟 Gmail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聯絡我們'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _launchGmail,
          icon: Icon(Icons.mail_outline),
          label: Text('寫信給我們'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
