import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/*
 * 用於獲取本機螢幕大小、預設語言
 */

// 全域變數
String screenSize = 'assets/images/screen_size/9_16.png';
String language = 'ja';

final Map<String, Map<String, String>> _translations = {
  '你好': {'en': 'Hello', 'zh-TW': '你好', 'ja': 'こんにちは'},
  '歡迎！': {'en': 'Welcome!', 'zh-TW': '歡迎！', 'ja': 'ようこそ！'},
  '個人資訊': {'en': 'personal information', 'zh-TW': '個人資訊', 'ja': '個人情報'},
  '設定你的偏好': {'en': 'Set your preferences', 'zh-TW': '設定你的偏好', 'ja': '好みの設定をする'},
  '每一次旅行，都從認識你開始。': {
    'en': 'Every journey starts with getting to know you.',
    'zh-TW': '每一次旅行，都從認識你開始。',
    'ja': 'すべての旅はあなたを知ることから始まります。',
  },
};

// 外部可調用的翻譯函數
String translate(String key) {
  print('翻譯 $key');
  String out = 'null';
  if (_translations.containsKey(key)) {
    
    out = _translations[key]?[language] ?? _translations[key]?['en'] ?? key;
    
    print('1.翻譯 $out');
    return out;
  }
  print('2.翻譯 $out');
  return key; // 如果沒找到，原樣返回 key
}

// Future<String> translate(String key) async {
//   // await Future.delayed(Duration(milliseconds: 100)); // 模擬 async 行為（可省略）
//   print('翻譯 $key');
//   if (_translations.containsKey(key)) {
//     return _translations[key]?[language] ?? _translations[key]?['en'] ?? key;
//   }
//   return key;
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeGlobals();
  runApp(const MyApp());
}

// 初始化函式
void _initializeGlobals() {
  final window = WidgetsBinding.instance.platformDispatcher.views.first;
  final size = window.physicalSize / window.devicePixelRatio;
  screenSize =
      '${size.width.toStringAsFixed(0)}x${size.height.toStringAsFixed(0)}';

  // 取得預設語言
  final locale = ui.PlatformDispatcher.instance.locale;
  language = locale.languageCode;
}

// 範例應用
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Screen Info Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Global Info Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Screen Size: $screenSize'),
              Text('Language: $language'),
            ],
          ),
        ),
      ),
    );
  }
}
