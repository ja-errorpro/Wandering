import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'all_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  // 啟動 Gmail 的函數
  Future<void> _launchGmail() async {
    // 'mailto' Scheme 用於開啟郵件客戶端
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'cycugdsc@gmail.com', // 請替換成您的 Gmail 地址
      query: Uri.encodeFull('subject=使用者回饋&body=請在此輸入您的訊息...'), // 主題和內文
    );
    await _launchUrlHelper(emailUri, 'Gmail');
  }

  // 啟動 Linktree 的函數
  Future<void> _launchLinktree() async {
    // 請替換成您的 Linktree 連結
    final Uri linktreeUri = Uri.parse('https://linktr.ee/your_username');
    await _launchUrlHelper(linktreeUri, 'Linktree');
  }

  // 啟動 Instagram 的函數
  Future<void> _launchInstagram() async {
    // 請替換成您的 Instagram 個人檔案連結
    final Uri instagramUri = Uri.parse(
      'https://www.instagram.com/your_handle/',
    );
    await _launchUrlHelper(instagramUri, 'Instagram');
  }

  // 協助啟動 URL 並處理錯誤的函數
  Future<void> _launchUrlHelper(Uri uri, String platformName) async {
    try {
      // 檢查是否可以啟動該 URL
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // 捕獲啟動過程中的其他錯誤
      debugPrint('開啟 $platformName 時發生錯誤: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('開啟 $platformName 時發生未知錯誤。')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聯絡我們'),
        backgroundColor: getCardGradientColors()[0], // 可以設置 App Bar 顏色
      ),
      body: Center(
        // 使用 Center 將 Column 垂直和水平置中
        child: Padding(
          padding: const EdgeInsets.all(24.0), // 為內容添加內邊距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 使 Column 的內容垂直置中
            crossAxisAlignment: CrossAxisAlignment.stretch, // 使按鈕水平拉伸填滿寬度
            children: <Widget>[
              // Gmail 按鈕
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'cycugdsc@gmail.com',
                      query: Uri.encodeFull('subject=使用者回饋&body=請在此輸入您的訊息...'),
                    );
                    await _launchUrlHelper(emailUri, 'Gmail');
                  },
                  icon: Icon(Icons.mail_outline),
                  label: Text('寫信給我們'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // 按鈕之間的垂直間距
              // GDG 社群頁按鈕
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri gdgUri = Uri.parse(
                      'https://gdg.community.dev/gdg-on-campus-chung-yuan-christian-university-taoyuan-taiwan/',
                    );
                    await _launchUrlHelper(gdgUri, 'GDG 社群頁');
                  },
                  icon: Icon(Icons.link),
                  label: Text('我們的 GDG 社群頁'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // 按鈕之間的垂直間距
              // Instagram 按鈕
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri instagramUri = Uri.parse(
                      'https://www.instagram.com/gdg.on.campus_cycu/',
                    );
                    await _launchUrlHelper(instagramUri, 'Instagram');
                  },
                  icon: Icon(Icons.camera_alt_outlined), // 使用相機圖標作為替代
                  label: Text('追蹤我們的 Instagram'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              // 您可以在這裡添加其他聯絡方式的按鈕或文字，例如電話、地址等
            ],
          ),
        ),
      ),
    );
  }
}
