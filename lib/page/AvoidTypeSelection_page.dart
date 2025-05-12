import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../preference_data.dart'; // 確保導入你的 preference_data.dart
// import 'completion_page.dart'; // 導入完成頁面 (如果有的話)
// import 'home_page.dart'; // 假設完成後導向主頁面

class AvoidTypeSelectionPage extends StatefulWidget {
  const AvoidTypeSelectionPage({super.key});

  @override
  State<AvoidTypeSelectionPage> createState() => _AvoidTypeSelectionPageState();
}

class _AvoidTypeSelectionPageState extends State<AvoidTypeSelectionPage> {
   // 顯示選擇數量警告視窗 (通用函數)
  void _showSelectionCountWarningDialog(
      PreferenceCategory category, int minCount, int maxCount) {
    // ... 你的警告視窗實現 ...
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

   // 驗證選擇數量是否在指定區間內 (通用函數)
  bool _isSelectionCountValid(Set<String> selectedSet, int minCount, int maxCount) {
    return selectedSet.length >= minCount && selectedSet.length <= maxCount;
  }

  @override
  Widget build(BuildContext context) {
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
                  '避免類型 (最少選擇0項，最多${AvoidType.values.length}項)', // 避免類型可能沒有限制
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: AvoidType.values.map((type) {
                     final typeValue = type.toString().split('.').last;
                    final isSelected = userPreferences.avoidTypes.contains(typeValue);
                    return FilterChip(
                      label: Text(typeValue),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        // 避免類型可能沒有最大數量限制，如果需要可以添加
                        // if (selected && userPreferences.avoidTypes.length >= AvoidType.values.length) {
                        //    _showSelectionCountWarningDialog(...)
                        //    return;
                        // }
                        // 更新 UserPreferences 中的避免類型
                        userPreferences.updatePreference(
                          PreferenceCategory.avoidTypes,
                          typeValue,
                          selected,
                        );
                      },
                    );
                  }).toList(),
                ),
                 const Spacer(), // 將按鈕推到底部
                ElevatedButton(
                  onPressed: () async { // 改為 async 以等待儲存完成
                     // 驗證當前頁面的選擇數量 (如果避免類型有特殊限制)
                     // if (!_isSelectionCountValid(userPreferences.avoidTypes, 0, AvoidType.values.length)) {
                     //    _showSelectionCountWarningDialog(...)
                     //    return;
                     // }

                     // 在最後一個偏好頁面儲存偏好
                     print('所有偏好已選擇，準備儲存：${userPreferences.toMap()}');
                    //  await userPreferences.savePreferences(); // 調用儲存方法

                     // 導航到完成頁面或主頁面
                     // Navigator.pushReplacementNamed(context, '/completion_page'); // 導航到完成頁面
                     Navigator.pushReplacementNamed(context, '/home'); // 導航到主頁面 (假設)
                  },
                  child: const Text('完成選擇並儲存'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
