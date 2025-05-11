// Suggested code may be subject to a license. Learn more: ~LicenseLog:2464357609.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 導入 Provider 套件
// import 'package:firebase_auth/firebase_auth.dart';
import './../preference_data.dart'; // PreferenceData 類別
import  'TravelStyleSelection_page.dart'; // 導入下一個頁面



class PreferenceSelectionPage extends StatefulWidget {
  const PreferenceSelectionPage({super.key});

  @override
  State<PreferenceSelectionPage> createState() => _PreferenceSelectionPageState();
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

  // 檢查用戶偏好並導航的方法
  Future<void> _checkUserPreferencesAndNavigate() async {
    // 獲取 UserPreferences 實例
    // listen: false 因為我們只讀取它的狀態一次，不需要在它改變時重建這個 Widget
    final userPreferences = Provider.of<UserPreferences>(context, listen: false);

    // TODO: 這裡需要判斷用戶的偏好是否為空
    // 這取決於你的 UserPreferences 類別如何定義“空偏好”
    // 一種簡單的判斷方式是檢查所有偏好集合是否都為空
    bool preferencesAreEmpty = userPreferences.travelStyles.isEmpty &&
                              userPreferences.locationTypes.isEmpty &&
                              userPreferences.accommodationTypes.isEmpty; // && userPreferences.avoidTypes.isEmpty
                              

    if (preferencesAreEmpty) {
      print('用戶偏好為空，導航到旅行風格選擇頁面');
      // 導航到旅行風格選擇頁面
      // 使用 pushReplacement 以防止用戶返回這個檢查頁面
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: 
            (context) => const TravelStyleSelectionPage(),
        ),
      );
    } else {
      print('用戶已有偏好，導航到主頁面');
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
      appBar: AppBar(title: const Text('加載中...')), // 顯示加載提示
      body: const Center(
        child: CircularProgressIndicator(), // 顯示加載圓圈
      ),
    );
  }
}


// class PreferenceSelectionPage extends StatefulWidget {
//   const PreferenceSelectionPage({super.key});

//   @override
//   State<PreferenceSelectionPage> createState() => _PreferenceSelectionPageState();
// }

// class PreferenceCategoryTravelStyles extends StatefulWidget {
//   const PreferenceCategoryTravelStyles({super.key});

//   @override
//   State<PreferenceCategoryTravelStyles> createState() => _PreferenceCategoryTravelStyles();
// }



// class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
//   // 使用 UserPreferences 來管理選取的偏好項目
//   late UserPreferences _userPreferences;

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const PreferenceSelectionPageS()),
//     );
//   });

// }


// class _PreferenceCategoryTravelStyles extends State<PreferenceCategoryTravelStyles> {


//   @override
//   void initState() {
//     super.initState();
//     // 在 State 初始化時獲取當前用戶 UID 並創建 UserPreferences 對象
//     String? uid = getCurrentUserUid();
//     if (uid != null) {
//       _userPreferences = UserPreferences(uid: uid);
//       // TODO: 如果需要從 Firebase 載入現有的使用者偏好，在這裡實現載入邏輯
//     } else {
//       // 處理無法獲取用戶 UID 的情況，可能導航到登入頁面或顯示錯誤
//       print('無法獲取當前用戶 UID');
//       // 例如：Navigator.pushReplacementNamed(context, '/login');
//     }
//   }

//   // 顯示選擇數量警告視窗
//   void _showSelectionCountWarningDialog(
//     PreferenceCategory category,
//     int minCount,
//     int maxCount,
//   ) {
//     String message = '';
//     String categoryName = '';

//     switch (category) {
//       case PreferenceCategory.travelStyles:
//         categoryName = '旅行風格';
//         break;
//       case PreferenceCategory.locationTypes:
//         categoryName = '地點類型';
//         break;
//       case PreferenceCategory.accommodationTypes:
//         categoryName = '住宿類型';
//         break;
//       case PreferenceCategory.avoidTypes:
//         categoryName = '避免類型';
//         break;
//     }

//     if (minCount == maxCount) {
//       message = '$categoryName 必須選擇 $minCount 項。';
//     } else {
//       message = '$categoryName 必須選擇 $minCount 到 $maxCount 項。';
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('選擇數量不符'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('確定'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 驗證選擇數量是否在指定區間內
//   bool _isSelectionCountValid(
//     Set<String> selectedSet,
//     int minCount,
//     int maxCount,
//   ) {
//     return selectedSet.length >= minCount && selectedSet.length <= maxCount;
//   }

//   // 構建偏好選擇區塊的通用方法
//   Widget _buildPreferenceBlock<T>({
//     required String title,
//     required List<T> items,
//     required Set<String> selectedItemsSet, // 使用 Set<String> 來檢查是否選取
//     required String Function(T) getValue, // 用於獲取 enum 的字串值
//     required int minCount,
//     required int maxCount,
//     required PreferenceCategory category,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           '$title (最少選擇$minCount項，最多$maxCount項)',
//           style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8.0,
//           runSpacing: 8.0,
//           children:
//               items.map((item) {
//                 final itemValue = getValue(item);
//                 final isSelected = selectedItemsSet.contains(itemValue);
//                 return FilterChip(
//                   label: Text(itemValue), // 使用 enum 的字串值作為標籤
//                   selected: isSelected,
//                   onSelected: (bool selected) {
//                     // 檢查選擇數量是否超過最大限制
//                     if (selected && selectedItemsSet.length >= maxCount) {
//                       _showSelectionCountWarningDialog(
//                         category,
//                         minCount,
//                         maxCount,
//                       );
//                       return; // 不允許選擇更多
//                     }
//                     setState(() {
//                       // 使用 UserPreferences 的 updatePreference 方法更新選取狀態
//                       _userPreferences.updatePreference(
//                         category,
//                         itemValue,
//                         selected,
//                       );
//                     });
//                   },
//                 );
//               }).toList(),
//         ),
//         const SizedBox(height: 24), // 區塊之間的間距
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 確保 _userPreferences 已經初始化
//     if (_userPreferences == null) {
//       // 可以顯示一個載入中的指示器或錯誤訊息
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('選擇你的旅遊偏好')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // 旅行風格選擇區塊
//               _buildPreferenceBlock<TravelStyle>(
//                 title: '旅行風格',
//                 items: TravelStyle.values, // 使用 enum.values 來獲取所有選項
//                 selectedItemsSet:
//                     _userPreferences.travelStyles, // 使用 UserPreferences 中的 Set
//                 getValue:
//                     (style) => style.toString().split('.').last, // 獲取 enum 的字串值
//                 minCount: 1,
//                 maxCount: 3,
//                 category: PreferenceCategory.travelStyles,
//               ),

//               // 地點類型選擇區塊
//               _buildPreferenceBlock<LocationType>(
//                 title: '偏好地點類型',
//                 items: LocationType.values, // 使用 enum.values
//                 selectedItemsSet:
//                     _userPreferences.locationTypes, // 使用 UserPreferences 中的 Set
//                 getValue:
//                     (type) => type.toString().split('.').last, // 獲取 enum 的字串值
//                 minCount: 1, // TODO: 設定地點類型的最小和最大選擇數量
//                 maxCount: 5, // TODO: 設定地點類型的最小和最大選擇數量
//                 category: PreferenceCategory.locationTypes,
//               ),

//               // 住宿類型選擇區塊
//               _buildPreferenceBlock<AccommodationType>(
//                 title: '偏好住宿類型',
//                 items: AccommodationType.values, // 使用 enum.values
//                 selectedItemsSet:
//                     _userPreferences
//                         .accommodationTypes, // 使用 UserPreferences 中的 Set
//                 getValue:
//                     (type) => type.toString().split('.').last, // 獲取 enum 的字串值
//                 minCount: 1, // TODO: 設定住宿類型的最小和最大選擇數量
//                 maxCount: 3, // TODO: 設定住宿類型的最小和最大選擇數量
//                 category: PreferenceCategory.accommodationTypes,
//               ),

//               // 避免類型選擇區塊
//               _buildPreferenceBlock<AvoidType>(
//                 title: '避免類型',
//                 items: AvoidType.values, // 使用 enum.values
//                 selectedItemsSet:
//                     _userPreferences.avoidTypes, // 使用 UserPreferences 中的 Set
//                 getValue:
//                     (type) => type.toString().split('.').last, // 獲取 enum 的字串值
//                 minCount: 0, // 避免類型可能沒有限制，或有其他限制
//                 maxCount: AvoidType.values.length, // 最多可以全選
//                 category: PreferenceCategory.avoidTypes,
//               ),

//               const SizedBox(height: 24),

//               ElevatedButton(
//                 onPressed: () {
//                   // 驗證所有偏好類別的選擇數量
//                   if (!_isSelectionCountValid(
//                     _userPreferences.travelStyles,
//                     1,
//                     3,
//                   )) {
//                     _showSelectionCountWarningDialog(
//                       PreferenceCategory.travelStyles,
//                       1,
//                       3,
//                     );
//                     return;
//                   }
//                   // TODO: 添加其他類別的驗證
//                   // if (!_isSelectionCountValid(_userPreferences.locationTypes, minLoc, maxLoc)) {
//                   //   _showSelectionCountWarningDialog(PreferenceCategory.locationTypes, minLoc, maxLoc);
//                   //   return;
//                   // }
//                   // ... 為 Accommodation Types 和 Avoid Types 添加驗證

//                   // 如果所有類別的選擇都有效，則儲存偏好並導航
//                   // UserPreferences 對象 _userPreferences 已經包含了選取的偏好
//                   print('用戶偏好已準備好儲存：${_userPreferences.toMap()}');

//                   // TODO: 實現儲存邏輯 (儲存到 Firebase 等)，使用 _userPreferences.toMap() 獲取要儲存的數據

//                   // TODO: 導航到下一個頁面
//                   // Navigator.pushReplacementNamed(context, '/next_page');
//                 },
//                 child: const Text('完成選擇'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



/*
class InitalPreference extends StatefulWidget {
  const InitalPreference({super.key});

  @override
  State<InitalPreference> createState() => _InitalPreferenceState();
}

class _InitalPreferenceState extends State<InitalPreference> {
  // 定義旅遊風格選項
  final List<String> travelStylesOptions = [
    '文化體驗', // 博物館、歷史、古蹟導覽
    '自然景觀', // 山林、湖泊、國家公園
    '美食探索', // 歷史與藝術展覽小吃、餐廳、在地特色料理
    '小眾秘境', // 隱藏景點、非主流探索
    '夜生活', // 夜店、酒吧、深夜市集
    '運動戶外', // 攀岩、衝浪、滑雪、泛舟等冒險活動
    '購物逛街', // 百貨、品牌店、潮流商圈
    '文青藝文', // 書店、藝廊、街頭藝人、老建築
    '親子同樂', // 親子農場、樂園、動物園
    '慢活療癒', // 溫泉、靜心景點、鄉村生活
  ];

  // 定義其他偏好類別選項 (目前為空，之後會加入)
  final List<String> locationTypesOptions = [];
  final List<String> avoidTypesOptions = [];
  final List<String> accommodationTypesOptions = [];

  // 儲存使用者選擇的偏好
  Set<String> selectedTravelStyles = {};
  Set<String> selectedLocationTypes = {};
  Set<String> selectedAvoids = {};
  Set<String> selectedAccommodations = {};

  // 更新特定偏好類別的選擇
  void _updatePreferenceSelection(
    Set<String> selectedSet,
    String value,
    bool isSelected,
  ) {
    setState(() {
      if (isSelected) {
        selectedSet.add(value);
      } else {
        selectedSet.remove(value);
      }
    });
  }

  // 檢查特定偏好類別的選擇數量是否符合要求
  bool _isSelectionCountValid(Set<String> selectedSet, int min, int max) {
    return selectedSet.length >= min && selectedSet.length <= max;
  }

  // 顯示選擇數量不足或過多的警告對話框
  void _showSelectionCountWarningDialog(
    PreferenceCategory type,
    int min,
    int max,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('選擇數量不符'),
          content: Text('請為${_getCategoryName(type)}選擇$min到$max個項目。'),
          actions: <Widget>[
            TextButton(
              child: const Text('確定'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // 驗證所有必要類別是否都有選擇
  bool _validateSelections(PreferenceCategory type) {
    if (type == PreferenceCategory.travelStyles) {
      return selectedTravelStyles.isNotEmpty;
    } else if (type == PreferenceCategory.locationTypes) {
      return selectedLocationTypes.isNotEmpty;
    } else if (type == PreferenceCategory.accommodationTypes) {
      return selectedAccommodations.isNotEmpty;
    } else if (type == PreferenceCategory.avoidTypes) {
      return selectedAvoids.isNotEmpty;
    } else {
      return true; // 其他類別目前不強制選擇
    }
  }

  // 根據 PreferenceCategory 返回對應的中文名稱
  String _getCategoryName(PreferenceCategory type) {
    switch (type) {
      case PreferenceCategory.travelStyles:
        return '旅行風格';
      case PreferenceCategory.locationTypes:
        return '偏好地點';
      case PreferenceCategory.accommodationTypes:
        return '住宿類型';
      case PreferenceCategory.avoidTypes:
        return '避免類型';
    }
  }

  // 顯示警告對話框
  void _showIncompleteDialog(PreferenceCategory type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('請完成選擇'),
          content: const Text('請從每個類別中至少選擇一個偏好項目。'),
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

  // 顯示警告對話框
  @override
  Widget build(BuildContext context) {
    PreferenceCategory type = PreferenceCategory.travelStyles;
    return Scaffold(
      appBar: AppBar(title: const Text('選擇你的旅遊偏好')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 旅行風格選擇
            Text(
              '選擇旅行風格 (最少選擇1項，最多3項)',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0, // 水平間距
              runSpacing: 8.0, // 垂直間距
              children:
                  travelStylesOptions.map((style) {
                    final isSelected = selectedTravelStyles.contains(style);
                    return FilterChip(
                      label: Text(style),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        // 檢查選擇數量是否超過限制
                        if (selected && selectedTravelStyles.length >= 3) {
                          _showSelectionCountWarningDialog(
                            PreferenceCategory.travelStyles,
                            1,
                            3,
                          );
                          return; // 不允許選擇更多
                        }
                        // 檢查是否取消選擇最後一個項目
                        if (!selected && selectedTravelStyles.length <= 1) {
                          _showSelectionCountWarningDialog(
                            PreferenceCategory.travelStyles,
                            1,
                            3,
                          );
                          return; // 不允許取消選擇最後一個
                        }
                        _updatePreferenceSelection(
                          selectedTravelStyles,
                          style,
                          selected,
                        );
                      },
                    );
                  }).toList(),
            ),

            // TODO: Add UI elements for other preference categories (locationTypes, accommodationTypes, avoidTypes)
            const Spacer(), // Pushes the button to the bottom

            ElevatedButton(
              onPressed: () {
                // 驗證旅行風格的選擇數量
                if (!_isSelectionCountValid(selectedTravelStyles, 1, 3)) {
                  _showSelectionCountWarningDialog(
                    PreferenceCategory.travelStyles,
                    1,
                    3,
                  );
                  return;
                } else {
                  // TODO: 驗證其他類別的選擇 (如果需要)

                  // 獲取當前用戶 UID
                  String? uid = getCurrentUserUid();
                  if (uid != null) {
                    // 創建 UserPreferences 對象並儲存
                    UserPreferences userPrefs = UserPreferences(
                      uid: uid,
                      travelStyles: selectedTravelStyles,
                    );
                    // TODO: 實現儲存邏輯，例如儲存到 Firebase
                  }
                }
              },
              child: const Text('完成選擇'),
            ),
          ],
        ),
      ),
    );
  }
}
*/


