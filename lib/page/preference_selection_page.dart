// Suggested code may be subject to a license. Learn more: ~LicenseLog:2464357609.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 導入 Provider 套件
import 'package:firebase_auth/firebase_auth.dart';
import './../preference_data.dart'; // PreferenceData 類別
import 'TravelStyleSelection_page.dart'; // 導入下一個頁面

class PreferenceSelectionPage extends StatefulWidget {
  const PreferenceSelectionPage({super.key});

  @override
  State<PreferenceSelectionPage> createState() =>
      _PreferenceSelectionPageState();
}

class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
  // 在 State 初始化時執行檢查和導航
  @override
  void initState() {
    super.initState();
    // 在下一幀繪製完成後執行導航，確保 context 是可用的
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserPreferencesAndNavigate();
    });
  }

  // 檢查用戶偏好並導航的方法 可刪除
  Future<void> _checkUserPreferencesAndNavigate() async {
    // 獲取 UserPreferences 實例
    // listen: false 因為我們只讀取它的狀態一次，不需要在它改變時重建這個 Widget
    final userPreferences = Provider.of<UserPreferences>(
      context,
      listen: false,
    );

    // TODO: 這裡需要判斷用戶的偏好是否為空
    // 這取決於你的 UserPreferences 類別如何定義“空偏好”
    // 一種簡單的判斷方式是檢查所有偏好集合是否都為空
    bool preferencesAreEmpty =
        userPreferences.travelStyles.isEmpty &&
        userPreferences.locationTypes.isEmpty &&
        userPreferences
            .accommodationTypes
            .isEmpty; // && userPreferences.avoidTypes.isEmpty

    if (preferencesAreEmpty) {
      // preferencesAreEmpty
      print('用戶偏好為空，導航到旅行風格選擇頁面');
      // 導航到旅行風格選擇頁面
      // 使用 pushReplacement 以防止用戶返回這個檢查頁面
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
      // 導航到主頁面
      // 使用 pushReplacement 以防止用戶返回這個檢查頁面
      // Navigator.pushReplacementNamed(
      //   context,
      //   '/home', // 替換為你的主頁面路由名稱
      // );

      // 如果你沒有使用命名路由，可以使用 MaterialPageRoute
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const HomePage(), // 替換為你的主頁面 Widget
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 在檢查和導航過程中，可以顯示一個加載指示器
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定您的偏好'), // 更新 AppBar 標題
        automaticallyImplyLeading: false, // 移除返回按鈕，因為這是初始設定頁面
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
