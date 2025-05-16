import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_page.dart'; // 匯入所有頁面

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // App Icon (使用內建 Icon 替代)
              Icon(
                Icons.travel_explore, // 你可以選擇一個更適合你的 App 的內建 Icon
                size: 100.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24.0),
              // 歡迎標題
              Text(
                '歡迎來到 Wandering App',
                style: GoogleFonts.arima(
                  // 使用 Google Sans 字體
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              // 歡迎說明
              Text(
                '開始你的精彩旅程吧！',
                style: TextStyle(
                  fontFamily: 'ProductSans',
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
                // style: GoogleFonts.arima(
                //   // 使用 Google Sans 字體
                //   fontSize: 18.0,
                //   color: Colors.black54,
                // ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              // 開始按鈕.
              ElevatedButton(
                onPressed: () {
                  // TODO: 在這裡導航到下一個頁面 (偏好設定頁面)PreferenceSelectionPage
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PreferenceSelectionPage()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  '開始探索',
                  style: TextStyle(fontFamily: 'ProductSans', fontSize: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入/註冊'),
        centerTitle: true, // 新增這行來居中標題
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            debugPrint('Hello World');
          },
          child: const Text(
            'Hello World',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}*/