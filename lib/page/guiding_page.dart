import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart'; // 假設您使用 Google Fonts
import 'all_page.dart'; // 假設您的所有頁面都在這個文件中匯入
// import '../icons.dart'; // 假設您的自定義圖標在這個文件中

class GuidingPage extends StatelessWidget {
  const GuidingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 將內容置中
        child: SingleChildScrollView( // 如果內容過多，允許滾動
          padding: const EdgeInsets.all(24.0), // 增加頁面邊距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 將列內容在主軸上置中
            crossAxisAlignment: CrossAxisAlignment.center, // 將列內容在交叉軸上置中
            children: <Widget>[
              // App 名稱 (使用圖片中的漸變色)
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // App 名稱置中
                children: [
                  Text(
                    'Wandering',
                    style: TextStyle(
                      fontFamily: 'HolidayFree', // 使用自定義字體
                      fontSize: 45.0,
                      fontWeight: FontWeight.w400, // w400
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 34, 167, 255), //  // 藍色
                            Color.fromARGB(255, 69, 205, 255), // 
                            Color.fromARGB(255, 124, 196, 255),
                            Color.fromARGB(255, 124, 196, 255), // 藍色
                            Color.fromARGB(255, 122, 243, 209),
                            Color.fromARGB(255, 69, 205, 255), // 
                            Color.fromARGB(255, 124, 196, 255), // 藍色
                            Color.fromARGB(255, 69, 205, 255), // 
                          ],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)), // 根據需要調整 Rect
                    ),
                  ),
                  // Text(
                  //   'dering',
                  //   style: GoogleFonts.pacifico( // 使用類似的字體
                  //     fontSize: 48.0,
                  //     fontWeight: FontWeight.bold,
                  //     foreground: Paint()
                  //       ..shader = const LinearGradient(
                  //         colors: <Color>[
                  //           Color.fromARGB(255, 122, 243, 126), // 綠色
                  //           Color.fromARGB(255, 124, 196, 255), // 藍色
                  //           // Colors.green, // 綠色
                  //           // Colors.orange, // 橙色
                  //           // Colors.red, // 紅色
                  //         ],
                  //       ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)), // 根據需要調整 Rect
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16.0), // 添加間距

              // 標語
              Text(
                '不知道去哪旅行，太懶得規劃？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40.0), // 添加間距

              // 一鍵生成按鈕
              ElevatedButton(
                onPressed: () {
                  // TODO: 按鈕按下後的導航邏輯
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                });
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 按鈕背景顏色
                  padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0), // 按鈕內邊距
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder( // 圓角按鈕
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '一鍵生成屬於你的旅程',
                  style: TextStyle(color: Colors.white), // 按鈕文字顏色
                ),
              ),
              const SizedBox(height: 60.0), // 添加間距

              // 功能介紹列表
              _buildFeatureItem(
                context,
                icon: Icons.star, // 星星圖標
                iconColor: Colors.pinkAccent, // 粉紅色
                title: '初始偏好選擇',
                description: '山本上波、莫國城、夜黯小欸', // 替換為實際描述
              ),
              const SizedBox(height: 20.0), // 添加間距

              _buildFeatureItem(
                context,
                icon: Icons.menu, // 菜單圖標
                iconColor: Colors.orange, // 橙色
                title: '輸入旅行條件',
                description: '月份、設置、人件甚多', // 替換為實際描述
              ),
              const SizedBox(height: 20.0), // 添加間距

              _buildFeatureItem(
                context,
                icon: Icons.check_circle_outline, // 勾選圖標
                iconColor: Colors.green, // 綠色
                title: '自動產生行程與路線',
                description: '推薦點、往研交疊繞綠規劃', // 替換為實際描述
              ),
              const SizedBox(height: 20.0), // 添加間距

              _buildFeatureItem(
                context,
                icon: Icons.hotel, // 酒店圖標
                iconColor: Colors.red, // 紅色
                title: '提供住宿建議',
                description: '推薦所在地點的最佳住宿!', // 替換為實際描述
              ),
              const SizedBox(height: 20.0), // 添加間距
            ],
          ),
        ),
      ),
    );
  }

  // 構建單個功能介紹項目的輔助方法
  Widget _buildFeatureItem(
      BuildContext context, {
      required IconData icon,
      required Color iconColor,
      required String title,
      required String description,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30.0,
          color: iconColor,
        ),
        const SizedBox(width: 16.0), // 圖標和文本之間的間距
    //.animate().fadeIn(duration: 1200.ms).scale(delay: 200.ms),
        Expanded( // 使用 Expanded 讓文本佔據剩餘空間
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0), // 標題和描述之間的間距
              Text(
                description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ).animate().slide(
          begin: const Offset(0, 10), // 從下方開始
          end: const Offset(0, 0),   // 滑到正常位置
          duration: 500.ms,        // 動畫持續時間 (例如 500 毫秒)
          curve: Curves.easeOut,   // 動畫曲線 (例如 easeOut)
        )
      ],
    );
  }
}
