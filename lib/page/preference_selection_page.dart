// Suggested code may be subject to a license. Learn more: ~LicenseLog:968994147.
import 'package:flutter/material.dart';
import './../preference_data.dart'; // PreferenceData 類別
import 'all_page.dart'; // 匯入 導入下一個頁面

class PreferenceSelectionPage extends StatefulWidget {
  const PreferenceSelectionPage({super.key});

  @override
  State<PreferenceSelectionPage> createState() =>
      _PreferenceSelectionPageState();
}

class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
  late String str_output;
  @override // Make this a StatelessWidget
  Widget build(BuildContext context) {
    // remove State class and initState
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Set your preferences'),
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // 設置 AppBar 背景透明
        elevation: 0, // 去掉 AppBar 陰影
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 255, 255, 255),
        ), // 設置返回按鈕顏色
      ),
      extendBodyBehindAppBar: true, //
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // 依據螢幕大小添加圖片背景
            image: AssetImage(screenSize), // 使用指定的圖片路徑
            fit: BoxFit.cover, // 圖片填充方式
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '每一次旅行，都從認識你開始。',textAlign: TextAlign.center, // Title // Set Your Preferences
                  style: TextStyle(
                    fontFamily: 'ChenYuluoyan', // 使用自定義字體
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  
                ),
                const SizedBox(height: 80),
                const Text( // Title // Set Your Preferences
                  '開始設定你的旅遊偏好，\n以獲得更精確的推薦。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ChenYuluoyan', // 使用自定義字體
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  // Get Started button
                  onPressed: () {
                    Navigator.push(
                      // Use push to allow back navigation
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TravelStyleSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent, // Turquoise background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '開始', // Button text
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Remove the State class
/*
class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserPreferencesAndNavigate();
    });
  }

  Future<void> _checkUserPreferencesAndNavigate() async {
    final userPreferences = Provider.of<UserPreferences>(
      context,
      listen: false,
    );

    bool preferencesAreEmpty =
        userPreferences.travelStyles.isEmpty &&
        userPreferences.locationTypes.isEmpty &&
        userPreferences.accommodationTypes.isEmpty;

    if (preferencesAreEmpty) {
      print('用戶偏好為空，導航到旅行風格選擇頁面');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TravelStyleSelectionPage(),
        ),
      );
    } else {
      print('用戶已有偏好，導航到主頁面');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TravelStyleSelectionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定您的偏好'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '歡迎！請設定您的旅遊偏好以獲得更精準的推薦。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TravelStyleSelectionPage(),
                  ),
                );
              },
              child: const Text('開始設定'),
            ),
          ],
        ),
      ),
    );
  }
}
*/


