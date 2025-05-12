import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // 導入 Provider
import './../preference_data.dart'; // 確保導入你的 preference_data.dart (包含 AvoidType 枚舉和 UserPreferences 類)
import './../database_helper.dart'; // 導入資料庫幫助類
// import 'completion_page.dart'; // 導入完成頁面 (如果有的話)
// import 'home_page.dart'; // 假設完成後導向主頁面

// 定義 AvoidType 的文字標籤
extension AvoidTypeDetails on AvoidType {
  String get label {
    // 根據 AvoidType 枚舉值返回對應的中文標籤
    switch (this) {
      case AvoidType.crowdedPlaces: return '擁擠的地方';
      case AvoidType.highCostAttractions: return '高消費景點';
      case AvoidType.tightItinerary: return '緊湊行程';
      case AvoidType.adventurousActivities: return '冒險活動';
      case AvoidType.humidHotClimate: return '濕熱氣候';
      case AvoidType.hotSunnyLocations: return '炎熱曝曬地點';
      case AvoidType.noisyEnvironment: return '嘈雜環境';
      case AvoidType.uncleanSpaces: return '不乾淨的空間';
      case AvoidType.fearOfAnimals: return '害怕動物';
      default: return this.toString().split('.').last; // 默認使用英文
    }
  }
}


class AvoidTypeSelectionPage extends StatefulWidget {
  const AvoidTypeSelectionPage({super.key});

  @override
  State<AvoidTypeSelectionPage> createState() => _AvoidTypeSelectionPageState();
}

class _AvoidTypeSelectionPageState extends State<AvoidTypeSelectionPage> {

  // 在 State 初始化時從資料庫加載偏好
  @override
  void initState() {
    super.initState();
    _loadPreferencesFromDatabase();
  }

  // 從資料庫加載用戶偏好
  Future<void> _loadPreferencesFromDatabase() async {
    final userPreferences = Provider.of<UserPreferences>(context, listen: false);
    final loadedPreferences = await DatabaseHelper.instance.getPreferences();

    if (loadedPreferences != null) {
      // 如果資料庫有數據，更新 Provider 中的 UserPreferences
      userPreferences.travelStyles = loadedPreferences.travelStyles;
      userPreferences.locationTypes = loadedPreferences.locationTypes;
      userPreferences.accommodationTypes = loadedPreferences.accommodationTypes;
      userPreferences.avoidTypes = loadedPreferences.avoidTypes;
      print('從資料庫加載了用戶偏好。');
    } else {
       print('資料庫中沒有用戶偏好數據。');
    }
  }

   // 顯示選擇數量警告視窗 (通用函數) - 避免類型通常沒有數量限制，所以這個函數可能不需要，但保留以便將來使用
  void _showSelectionCountWarningDialog(
      PreferenceCategory category, int minCount, int maxCount) {
     String message = '';
    String categoryName = '';

    switch (category) {
      case PreferenceCategory.travelStyles:
        categoryName = '旅行風格';
        break;
      case PreferenceCategory.locationTypes:
        categoryName = '地點類型';
        break;
      case PreferenceCategory.accommodationTypes:
        categoryName = '住宿類型';
        break;
      case PreferenceCategory.avoidTypes:
        categoryName = '避免類型';
        break;
    }

    if (minCount == maxCount) {
      message = '$categoryName 必須選擇 $minCount 項。';
    } else {
      message = '$categoryName 必須選擇 $minCount 到 $maxCount 項。';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('選擇數量不符'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   // 驗證選擇數量是否在指定區間內 (通用函數) - 避免類型通常沒有數量限制，所以這個函數可能不需要，但保留以便將來使用
  bool _isSelectionCountValid(Set<String> selectedSet, int minCount, int maxCount) {
    return selectedSet.length >= minCount && selectedSet.length <= maxCount;
  }

  @override
  Widget build(BuildContext context) {
     // 使用 Consumer 來監聽 UserPreferences 的變化並重建 UI
    return Scaffold(
      appBar: AppBar(title: const Text('選擇避免類型')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          // 在這裡構建避免類型的選擇 UI
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '避免類型 (可複選)', // 避免類型通常沒有數量限制
                  style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent), // 根據避免類型調整顏色
                   textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                 Text(
                  '以下是你特別想要避開的類型嗎？',
                   style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[700]),
                   textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: AvoidType.values.map((type) {
                       final typeValue = type.label; // 使用 extension 獲取標籤
                      final isSelected = userPreferences.avoidTypes.contains(typeValue); // 從 UserPreferences 中獲取選擇狀態
                      return FilterChip(
                         label: Text(
                           typeValue,
                           style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87, // 根據選擇狀態改變文字顏色
                              fontWeight: FontWeight.bold,
                           ),
                         ),
                        selected: isSelected,
                         backgroundColor: Colors.grey.shade300, // 默認背景色
                        selectedColor: Colors.redAccent.withOpacity(0.8), // 選中時的背景色
                        checkmarkColor: Colors.white, // 選中時的勾選顏色
                         onSelected: (bool selected) {
                            // 避免類型通常沒有最大數量限制
                            // if (selected && userPreferences.avoidTypes.length >= AvoidType.values.length) {
                            //    _showSelectionCountWarningDialog(PreferenceCategory.avoidTypes, 0, AvoidType.values.length);
                            //    return;
                            // }

                            // 更新 UserPreferences 中的避免類型
                            userPreferences.updatePreference(
                              PreferenceCategory.avoidTypes,
                              typeValue,
                              selected, // 直接使用 selected 的布爾值
                            );

                            // **在偏好更新後保存到資料庫**
                            DatabaseHelper.instance.insertOrUpdatePreferences(userPreferences);
                          },
                      );
                    }).toList(),
                  ),
                ),
                 const SizedBox(height: 24), // 將按鈕推到底部
                ElevatedButton(
                  onPressed: () async { // 改為 async 以等待儲存完成

                     // 避免類型通常沒有數量限制，所以不需要驗證
                     // if (!_isSelectionCountValid(userPreferences.avoidTypes, 0, AvoidType.values.length)) {
                     //    _showSelectionCountWarningDialog(PreferenceCategory.avoidTypes, 0, AvoidType.values.length);
                     //    return;
                     // }

                     // 在最後一個偏好頁面儲存偏好
                     print('所有偏好已選擇，準備儲存：${userPreferences.toMap()}');
                     await DatabaseHelper.instance.insertOrUpdatePreferences(userPreferences); // 調用儲存方法

                     // 導航到完成頁面或主頁面
                     // Navigator.pushReplacementNamed(context, '/completion_page'); // 導航到完成頁面
                      // 假設完成後導向主頁面，你需要根據你的應用程式路由來設定正確的路由名稱
                     // Navigator.pushReplacementNamed(context, '/home'); // 導航到主頁面
                     // 這裡使用 Navigator.popUntil 回到根路由，或者導航到你指定的完成頁面
                      Navigator.popUntil(context, (route) => route.isFirst); // 回到第一個頁面
                      // 或者
                      // Navigator.pushReplacementNamed(context, '/completionPage'); // 導航到完成頁面 (你需要定義這個路由)


                  },
                   style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red, // 根據避免類型調整按鈕顏色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    '完成選擇並儲存',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
