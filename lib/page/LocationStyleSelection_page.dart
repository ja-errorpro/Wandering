import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../preference_data.dart'; // 確保導入你的 preference_data.dart (包含 AccommodationType 枚舉和 UserPreferences 類)
import './../database_helper.dart'; // 導入資料庫幫助類
import 'AvoidTypeSelection_page.dart'; // 導入下一個頁面

class AccommodationTypeSelectionPage extends StatefulWidget {
  const AccommodationTypeSelectionPage({super.key});

  @override
  State<AccommodationTypeSelectionPage> createState() =>
      _AccommodationTypeSelectionPageState();
}

class _AccommodationTypeSelectionPageState
    extends State<AccommodationTypeSelectionPage> {

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

  // 顯示選擇數量警告視窗 (通用函數)
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

  // 驗證選擇數量是否在指定區間內 (通用函數)
  bool _isSelectionCountValid(
      Set<String> selectedSet, int minCount, int maxCount) {
    return selectedSet.length >= minCount && selectedSet.length <= maxCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('選擇偏好住宿類型')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          // 根據設計圖修改 UI 結構
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '選擇你的住宿偏好',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700, // 根據設計圖調整顏色
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '你偏好哪些住宿類型？(可複選)',
                   textAlign: TextAlign.center,
                   style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                   ),
                ),
                const SizedBox(height: 24),
                Expanded( // 使用 Expanded 使 GridView 填充剩餘空間
                  child: GridView.count(
                    crossAxisCount: 2, // 每行兩個項目
                    crossAxisSpacing: 16.0, // 水平間距
                    mainAxisSpacing: 16.0, // 垂直間距
                    childAspectRatio: 1.2, // 控制每個網格項目的長寬比
                    children: AccommodationType.values.map((type) {
                      final typeValue = type.toString().split('.').last;
                      final isSelected = userPreferences.accommodationTypes.contains(typeValue);

                      // 根據設計圖構建帶有圖標和文字的選擇卡片
                      Widget icon;
                      String label;
                      // 根據 AccommodationType 設置圖標和文字
                       switch (type) {
                         case AccommodationType.hostel:
                           icon = Icon(Icons.king_bed, size: 40, color: isSelected ? Colors.white : Colors.blue);
                           label = '青年旅館';
                           break;
                         case AccommodationType.bedAndBreakfast:
                            icon = Icon(Icons.home, size: 40, color: isSelected ? Colors.white : Colors.green);
                            label = '民宿';
                            break;
                         case AccommodationType.starHotel:
                            icon = Icon(Icons.star, size: 40, color: isSelected ? Colors.white : Colors.orange);
                            label = '星級飯店';
                            break;
                         case AccommodationType.luxuryResort:
                            icon = Icon(Icons.beach_access, size: 40, color: isSelected ? Colors.white : Colors.redAccent);
                            label = '豪華渡假村';
                            break;
                         case AccommodationType.campingWildCamping:
                            icon = Icon(Icons.camping, size: 40, color: isSelected ? Colors.white : Colors.teal);
                            label = '露營/野營';
                            break;
                         case AccommodationType.apartmentSuite:
                            icon = Icon(Icons.apartment, size: 40, color: isSelected ? Colors.white : Colors.pink);
                            label = '公寓/套房';
                            break;
                         case AccommodationType.any:
                           icon = Icon(Icons.hotel, size: 40, color: isSelected ? Colors.white : Colors.grey);
                           label = '任意皆可';
                           break;
                         case AccommodationType.flexibleMix:
                            icon = Icon(Icons.shuffle, size: 40, color: isSelected ? Colors.white : Colors.cyan);
                            label = '靈活混搭';
                           break;
                       }

                      return InkWell( // 使用 InkWell 實現可點擊效果
                        onTap: () {
                          // **住宿類型選擇邏輯：考慮 any 和 flexibleMix 的互斥性**
                          final currentSelection = Set<String>.from(userPreferences.accommodationTypes);

                          // 如果選擇的是 Any 或 Flexible Mix
                          if (type == AccommodationType.any || type == AccommodationType.flexibleMix) {
                              // 如果當前已經選擇了 Any 或 Flexible Mix 以外的其他選項，則提示錯誤或清空其他選項
                              if (currentSelection.isNotEmpty &&
                                  !currentSelection.contains('any') &&
                                  !currentSelection.contains('flexibleMix')) {
                                  // 提示用戶 Any/Flexible Mix 不能與其他選項同時選擇
                                  _showSelectionCountWarningDialog(PreferenceCategory.accommodationTypes, 1, 1); // 這裡根據 Any/Flexible Mix 的規則提示只能選擇一項
                                  return;
                              }

                              // 如果選擇 Any 或 Flexible Mix，清空其他選項
                              userPreferences.accommodationTypes.clear();
                              userPreferences.updatePreference(PreferenceCategory.accommodationTypes, typeValue, true); // 只選擇當前這個

                          } else {
                              // 如果選擇的是其他選項，清空 Any 和 Flexible Mix
                              if (currentSelection.contains('any')) {
                                userPreferences.updatePreference(PreferenceCategory.accommodationTypes, 'any', false);
                              }
                              if (currentSelection.contains('flexibleMix')) {
                                userPreferences.updatePreference(PreferenceCategory.accommodationTypes, 'flexibleMix', false);
                              }

                              // **檢查選擇數量是否超過最大限制 (對於非 any 和 flexibleMix 選項)**
                              if (!isSelected && userPreferences.accommodationTypes.length >= 3) {
                                  _showSelectionCountWarningDialog(
                                    PreferenceCategory.accommodationTypes,
                                    1, // 根據 AccommodationType 的規則設置最小選擇數
                                    3, // 根據 AccommodationType 的規則設置最大選擇數
                                  );
                                  return; // 不允許選擇更多
                              }

                             // 更新 UserPreferences 中的住宿類型
                             userPreferences.updatePreference(
                               PreferenceCategory.accommodationTypes,
                               typeValue,
                               !isSelected, // 切換選擇狀態
                             );
                          }


                          // **在偏好更新後保存到資料庫**
                           DatabaseHelper.instance.insertOrUpdatePreferences(userPreferences);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blueAccent : Colors.white, // 根據選擇狀態改變背景顏色
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: isSelected ? Colors.blueAccent : Colors.grey.shade300, // 根據選擇狀態改變邊框顏色
                              width: 1.5,
                            ),
                            boxShadow: isSelected ? [ // 選擇時添加陰影效果
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ] : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              icon,
                              const SizedBox(height: 8),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87, // 根據選擇狀態改變文字顏色
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                 const SizedBox(height: 24), // 按鈕上方留白
                 ElevatedButton(
                  onPressed: () {
                     // **驗證當前頁面的選擇數量**
                     // 住宿類型驗證邏輯：
                     // 如果選擇了 "any" 或 "flexibleMix"，則只允許選擇一項
                     // 如果沒有選擇 "any" 或 "flexibleMix"，則必須在 1 到 3 項之間
                     final currentSelection = Set<String>.from(userPreferences.accommodationTypes);

                     bool isValid = false;
                     if (currentSelection.contains('any') || currentSelection.contains('flexibleMix')) {
                         isValid = currentSelection.length == 1; // 如果選擇了 Any 或 Flexible Mix，只能選擇一個
                         if (!isValid) {
                            _showSelectionCountWarningDialog(PreferenceCategory.accommodationTypes, 1, 1);
                         }
                     } else {
                          isValid = _isSelectionCountValid(currentSelection, 1, 3); // 其他情況下，必須在 1 到 3 項之間
                          if (!isValid) {
                              _showSelectionCountWarningDialog(PreferenceCategory.accommodationTypes, 1, 3);
                          }
                     }


                     if (isValid) {
                        // **在導航前保存到資料庫**
                        DatabaseHelper.instance.insertOrUpdatePreferences(userPreferences);

                        // 導航到下一個偏好設定頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AvoidTypeSelectionPage(),
                          ),
                        );
                     }
                  },
                   // 根據選擇是否有效來決定按鈕是否啟用
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.teal, // 根據設計圖調整按鈕顏色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    '下一頁',
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
