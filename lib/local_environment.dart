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

List<Color> getCardGradientColors({String theme = 'default', String page = 'default'}) {
  switch (theme) {
    case 'sunset':
      return const [
        Color(0xffffe0b2), // 淺橙
        Color(0xffffcc80), // 橙
        Color(0xffffb74d), // 深橙
        Color(0xffffa726), // 暗橙
      ];
    case 'forest':
      return const [
        Color(0xffb2dfdb), // 淺綠藍
        Color(0xff80cbc4), // 綠藍
        Color(0xff4db6ac), // 中綠藍
        Color(0xff26a69a), // 深綠藍
      ];
    case 'pastel': //
      return const [
        Color(0xfff8bbd0), // 粉紅
        Color(0xffe1bee7), // 淡紫
        Color(0xffd1c4e9), // 淡藍紫
        Color(0xffc5cae9), // 藍灰
      ];
    case 'default':
    default:
      switch (page) {
        case 'login':
          return const [
            Color(0xFF7beec5), // 薄荷綠
            Color(0xFF01e6fa), // 亮藍
            Color(0xFF32c8ff), // 天藍
            Color(0xFFc0e8cb), // 淡綠
          ];
        case 'preference':
          return const [
            Color(0xFF7beec5), // 薄荷綠
            Color(0xFF01e6fa), // 亮藍
            Color(0xFF32c8ff), // 天藍
            Color(0xFFc0e8cb), // 淡綠
          ];
        case 'explore':
          return const [
            Color(0xFF7beec5), // 薄荷綠
            Color(0xFF01e6fa), // 亮藍
            Color(0xFF32c8ff), // 天藍
            Color(0xFFc0e8cb), // 淡綠
          ];
        default:
        return const [
          Color(0xffd5f6ff), // 亮藍
          Color(0xff89c8e3), // 天藍
          Color(0xff82b1c1), // 天藍
          Color(0xffafd9ef), // 天藍
        ];
      }

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
