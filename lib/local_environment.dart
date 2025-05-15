import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;

/*
 * 用於獲取本機螢幕大小、預設語言
 */

// 全域變數
String screenSize = 'assets/images/screen_size/9_16.png';
String language = 'zh-TW';
double fontSize = 14;
String theme = 'default'; // 預設主題

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

void setLanguage(String lang) {
  language = lang;
  print('語言設置為 $language');
}

void SetTheme(String th) {
  theme = th;
  print('主題設置為 $theme');
}

String GetTheme() {
  return theme;
}

void SetFontSize(double size) {
  fontSize = size;
  print('字體大小設置為 $fontSize');
}

double GetFontSize() {
  return fontSize;
}

List<Color> getCardGradientColors() {
  print('選取主題: $theme');
  switch (theme) {
  case 'grand blue':
    return const [
      Color(0xFF7beec5), // 薄荷綠
      Color(0xFF01e6fa), // 亮藍
      Color(0xFF32c8ff), // 天藍
      Color(0xFFc0e8cb), // 淡綠
    ];

  case 'uncolored': //'黑白'
    return const [
      Color(0xFFFFFFFF), // 白
      Color(0xFFa6a6a6), // 灰
      Color(0xFF898282), // 淺棕
      Color(0xFFb4b4b4), // 淺灰
    ];

  case 'fall': //'秋天'
  return const [
    Color(0xFFdbb8a5), // 肉色
    Color(0xFFffc7af), // 粉橘
    Color(0xFFebdac6), // 米黃
    Color(0xFFad7445), // 紅棕
  ];

  case 'the forest': //'迷霧森林'
  return const [
    Color(0xFFa4bac3), // 淺藍
    Color(0xFFc4dbd2), // 薄荷綠
    Color(0xFFb8cfc1), // 綠
    Color(0xFF4d7d79), // 深綠
  ];

  case 'bubble candy': //'泡泡糖'
  return const [
    Color(0xFFffb6b6), // 桃紅
    Color(0xFFeed9ef), // 藕
    Color(0xFFffd7ec), // 粉
    Color(0xFFffbac9), // 紅
  ];

  case 'Lavender': // '薰衣草'
  return const [
    Color(0xFFc6a5a5), // 粉紫
    Color(0xFFd5bbcc), // 紫
    Color(0xFFe1d2e4), // 淺紫
    Color(0xFFa892cb), // 紫
  ];

  case 'sunrise': //'日出'
  return const [
    Color(0xFFffe67a), // 黃
    Color(0xFFffca7a), // 橙
    Color(0xFFffa74c), // 橘
    Color(0xFFffdfaf), // 淺橘
  ];

  case 'rainbow': //'彩虹'
  return const [
    Color(0xFFFFBABA), // 紅
    Color(0xFFFFDA88), // 橙
    Color(0xFFEfec8e), // 黃
    Color(0xFFc6e8c0), // 薄荷綠
    Color(0xFFC0E8E4), // 藍
    Color(0xFFC0CCE8), //靛
  ];

  default:
  return const [
    Color(0xFF7beec5), // 薄荷綠
    Color(0xFF01e6fa), // 亮藍
    Color(0xFF32c8ff), // 天藍
    Color(0xFFc0e8cb), // 淡綠
  ];
  }
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   initializeGlobals();
//   runApp(const MyApp());
// }

// 初始化函式
void initializeGlobals() {
  final window = WidgetsBinding.instance.platformDispatcher.views.first;
  print('window.physicalSize: ${window.physicalSize}');
  final size = window.physicalSize / window.devicePixelRatio;
  print('size: $size');
  screenSize =
      '${size.width.toStringAsFixed(0)}x${size.height.toStringAsFixed(0)}';
  print('screenSize: $screenSize');

  // 取得預設語言
  final locale = ui.PlatformDispatcher.instance.locale;
  language = locale.languageCode;
  print('language: $language');
  theme = 'default';
  // 取得使用者字體大小
  fontSize = ui.PlatformDispatcher.instance.textScaleFactor * 16;
  print('fontSize: $fontSize');
}

// 範例應用
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Global Screen Info Demo',
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Global Info Example')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Screen Size: $screenSize'),
//               Text('Language: $language'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
