import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import './../preference_data.dart'; // 確保導入你的 preference_data.dart
import './../savePreferencesLocally.dart'; // 導入並使用別名
import 'LocationStyleSelection_page.dart'; // 導入下一個頁面

class TravelStyleSelectionPage extends StatefulWidget {
  const TravelStyleSelectionPage({super.key});

  @override
  State<TravelStyleSelectionPage> createState() =>
      _TravelStyleSelectionPageState();
}

class _TravelStyleSelectionPageState extends State<TravelStyleSelectionPage> {
  // 顯示選擇數量警告視窗 (與之前相同，可以提取為一個通用函數)
  void _showSelectionCountWarningDialog(
    PreferenceCategory category,
    int minCount,
    int maxCount,
  ) {
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

  // 驗證選擇數量是否在指定區間內 (與之前相同)
  bool _isSelectionCountValid(
    Set<String> selectedSet,
    int minCount,
    int maxCount,
  ) {
    return selectedSet.length >= minCount && selectedSet.length <= maxCount;
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Consumer 來監聽 UserPreferences 的變化並重建 UI
    return Scaffold(
      appBar: AppBar(title: const Text('選擇你的旅行風格')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          // 在這裡構建旅行風格的選擇 UI
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '旅行風格 (最少選擇1項，最多3項)',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      TravelStyle.values.map((style) {
                        final styleValue = style.toString().split('.').last;
                        final isSelected = userPreferences.travelStyles
                            .contains(styleValue);
                        return FilterChip(
                          label: Text(styleValue),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            // 檢查選擇數量是否超過最大限制
                            if (selected &&
                                userPreferences.travelStyles.length >= 3) {
                              _showSelectionCountWarningDialog(
                                PreferenceCategory.travelStyles,
                                1,
                                3,
                              );
                              return; // 不允許選擇更多
                            }
                            // 更新 UserPreferences 中的旅行風格
                            userPreferences.updatePreference(
                              PreferenceCategory.travelStyles,
                              styleValue,
                              selected,
                            );
                          },
                        );
                      }).toList(),
                ),
                const Spacer(), // 將按鈕推到底部
                ElevatedButton(
                  onPressed: () async {
                    // 加上 async 因為保存偏好可能是非同步操作
                    // 驗證當前頁面的選擇數量
                    if (_isSelectionCountValid(
                      userPreferences.travelStyles,
                      1,
                      3,
                    )) {
                      // 保存偏好設定到本地
                      await savePreferencesLocally(
                        userPreferences,
                      ); // 假設保存函數名為 savePreferences 並接受 UserPreferences 物件
                      // 導航到下一個偏好設定頁面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const LocationTypeSelectionPage(),
                        ),
                      );
                    } else {
                      // 顯示警告訊息
                      _showSelectionCountWarningDialog(
                        PreferenceCategory.travelStyles,
                        1,
                        3,
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
