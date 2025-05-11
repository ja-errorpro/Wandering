import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../preference_data.dart';  // 確保導入你的 preference_data.dart
import 'AccommodationTypeSelection_page.dart'; // 導入下一個頁面

class LocationTypeSelectionPage extends StatefulWidget {
  const LocationTypeSelectionPage({super.key});

  @override
  State<LocationTypeSelectionPage> createState() => _LocationTypeSelectionPageState();
}

class _LocationTypeSelectionPageState extends State<LocationTypeSelectionPage> {
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
      appBar: AppBar(title: const Text('選擇偏好地點類型')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          // 在這裡構建地點類型的選擇 UI
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '偏好地點類型 (最少選擇1項，最多5項)', // TODO: 設定地點類型的最小和最大選擇數量
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: LocationType.values.map((type) {
                     final typeValue = type.toString().split('.').last;
                    final isSelected = userPreferences.locationTypes.contains(typeValue);
                    return FilterChip(
                      label: Text(typeValue),
                      selected: isSelected,
                      onSelected: (bool selected) {
                         // 檢查選擇數量是否超過最大限制
                        if (selected && userPreferences.locationTypes.length >= 5) { // TODO: 使用地點類型的最大選擇數量
                          _showSelectionCountWarningDialog(
                            PreferenceCategory.locationTypes,
                            1, // TODO: 使用地點類型的最小選擇數量
                            5, // TODO: 使用地點類型的最大選擇數量
                          );
                          return; // 不允許選擇更多
                        }
                        // 更新 UserPreferences 中的地點類型
                        userPreferences.updatePreference(
                          PreferenceCategory.locationTypes,
                          typeValue,
                          selected,
                        );
                      },
                    );
                  }).toList(),
                ),
                 const Spacer(), // 將按鈕推到底部
                ElevatedButton(
                  onPressed: () {
                     // 驗證當前頁面的選擇數量
                     if (_isSelectionCountValid(userPreferences.locationTypes, 1, 5)) { // TODO: 使用地點類型的最小和最大選擇數量
                        // 導航到下一個偏好設定頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccommodationTypeSelectionPage(),
                          ),
                        );
                     } else {
                       // 顯示警告訊息
                       _showSelectionCountWarningDialog(
                         PreferenceCategory.locationTypes,
                         1, // TODO: 使用地點類型的最小選擇數量
                         5, // TODO: 使用地點類型的最大選擇數量
                       );
                     }
                  },
                  child: const Text('下一頁'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
