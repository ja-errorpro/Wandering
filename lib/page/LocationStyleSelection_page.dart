import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // 導入 Provider
import './../preference_data.dart'; // 確保導入你的 preference_data.dart (包含 LocationType 枚舉和 UserPreferences 類)
import 'AccommodationTypeSelection_page.dart'; // 導入下一個頁面
import 'package:Wandering/model/user_database_handler.dart';
import 'package:Wandering/auth.dart';
import 'package:Wandering/model/user_model.dart';

// 定義 LocationType 的圖示和顏色 (範例，你可以根據你的設計添加所有地點類型)
// 建議在 preference_data.dart 中為 LocationType 添加相關屬性
extension LocationTypeDetails on LocationType {
  IconData get icon {
    switch (this) {
      case LocationType.museum:
        return Icons.account_balance;
      case LocationType.marketNightMarket:
        return Icons.shopping_bag;
      case LocationType.trailNature:
        return Icons.nature;
      case LocationType.cafe:
        return Icons.coffee;
      case LocationType.landmarkBuilding:
        return Icons.apartment;
      case LocationType.beachLakeside:
        return Icons.beach_access;
      case LocationType.templeReligiousSite:
        return Icons.temple_hindu;
      case LocationType.artsSpace:
        return Icons.book;
      case LocationType.parkSquare:
        return Icons.park;
      case LocationType.nightViewpoint:
        return Icons.nightlight_round;
      case LocationType.oldStreet: // 添加 Old Street 的圖示
        return Icons.streetview;
      default:
        return Icons.help_outline; // 預設圖示
    }
  }

  Color get color {
    switch (this) {
      case LocationType.museum:
        return Colors.blue;
      case LocationType.marketNightMarket:
        return Colors.amber;
      case LocationType.trailNature:
        return Colors.green;
      case LocationType.cafe:
        return Colors.redAccent;
      case LocationType.landmarkBuilding:
        return Colors.red;
      case LocationType.beachLakeside:
        return Colors.lightBlue;
      case LocationType.templeReligiousSite:
        return Colors.deepPurple;
      case LocationType.artsSpace:
        return Colors.brown;
      case LocationType.parkSquare:
        return Colors.greenAccent;
      case LocationType.nightViewpoint:
        return Colors.deepPurpleAccent;
      case LocationType.oldStreet: // 添加 Old Street 的顏色
        return Colors.orangeAccent;
      default:
        return Colors.grey; // 預設顏色
    }
  }

  String get label {
    // 根據設計圖調整 Old Street 的標籤
    if (this == LocationType.oldStreet) {
      return '老街';
    }
    // 其他使用之前的邏輯獲取文字標籤
    switch (this) {
      case LocationType.museum:
        return '博物館';
      case LocationType.landmarkBuilding:
        return '地標建築';
      case LocationType.marketNightMarket:
        return '市場/夜市';
      case LocationType.parkSquare:
        return '公園/廣場';
      case LocationType.cafe:
        return '咖啡廳';
      case LocationType.artsSpace:
        return '書局/藝廊';
      case LocationType.templeReligiousSite:
        return '廟宇/宗教地';
      case LocationType.nightViewpoint:
        return '夜景觀景點';
      case LocationType.trailNature:
        return '步道/自然';
      case LocationType.beachLakeside:
        return '海邊/湖畔';
      default:
        return this.toString().split('.').last;
    }
  }
}

class LocationTypeSelectionPage extends StatefulWidget {
  const LocationTypeSelectionPage({super.key});

  @override
  State<LocationTypeSelectionPage> createState() =>
      _LocationTypeSelectionPageState();
}

class _LocationTypeSelectionPageState extends State<LocationTypeSelectionPage> {
  // 在 State 初始化時從資料庫加載偏好
  @override
  void initState() {
    super.initState();
    _loadPreferencesFromDatabase();
  }

  // 從資料庫加載用戶偏好
  Future<void> _loadPreferencesFromDatabase() async {
    final auth = Provider.of<AuthModel>(context, listen: false);
    if (auth.isAuthenticated == false) {
      return; // 如果使用者未登入，則不進行任何操作
    }

    final user = await UserDatabaseHandler.instance.getUser(auth.user!.uid);

    if (user != null) {
      // 將資料庫中的偏好設置到 UserPreferences
      final userPreferences = user.preferences;
    }
  }

  // 顯示選擇數量警告視窗 (通用函數)
  void _showSelectionCountWarningDialog(
    PreferenceCategory category,
    int minCount,
    int maxCount,
  ) {
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
      appBar: AppBar(title: const Text('選擇偏好地點類型')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          // 使用 GridView.builder 構建網格佈局
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '選擇你喜愛的地點類型', // 更新標題文字
                  style: GoogleFonts.lato(
                    fontSize: 24, // 調整字體大小
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // 設定標題顏色
                  ),
                  textAlign: TextAlign.center, // 標題置中
                ),
                const SizedBox(height: 8),
                Text(
                  '以下哪些地方會吸引你停下腳步?(可複選)', // 副標題
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Expanded(
                  // 使用 Expanded 讓 GridView 佔滿剩餘空間
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 每行顯示 3 個
                          crossAxisSpacing: 12.0, // 水平間距
                          mainAxisSpacing: 12.0, // 垂直間距
                          childAspectRatio: 0.8, // 調整每個網格項目的長寬比
                        ),
                    itemCount: LocationType.values.length,
                    itemBuilder: (context, index) {
                      final locationType = LocationType.values[index];
                      final typeValue =
                          locationType.label; // 使用 extension 獲取 label
                      final isSelected = userPreferences.locationTypes.contains(
                        typeValue,
                      ); // 從 UserPreferences 中獲取選擇狀態

                      return InkWell(
                        // 使用 InkWell 使卡片可點擊
                        onTap: () {
                          // 檢查選擇數量是否超過最大限制 (5項)
                          if (!isSelected &&
                              userPreferences.locationTypes.length >= 5) {
                            // 只有在未選中且數量超過時才提示
                            _showSelectionCountWarningDialog(
                              PreferenceCategory.locationTypes,
                              1, // 地點類型的最小選擇數
                              5, // 地點類型的最大選擇數
                            );
                            return; // 不允許選擇更多
                          }

                          // 更新 UserPreferences 中的地點類型偏好
                          userPreferences.updatePreference(
                            PreferenceCategory.locationTypes,
                            typeValue,
                            !isSelected, // 切換選擇狀態
                          );

                          // **在偏好更新後保存到資料庫**
                          final user = UserModel(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            username: 'username', // 這裡需要獲取當前用戶的名稱
                            firebaseUser: FirebaseAuth.instance.currentUser!,
                            email: FirebaseAuth.instance.currentUser!.email!,
                            preferences: userPreferences,
                          );

                          UserDatabaseHandler.instance.insertOrUpdateUser(
                            user,
                            Provider.of<AuthModel>(context, listen: false),
                          );
                        },
                        child: Card(
                          // 使用 Card 創建卡片效果
                          color: isSelected
                              ? locationType.color.withOpacity(0.8)
                              : Colors.white, // 選中時改變背景色
                          elevation: isSelected ? 8.0 : 2.0, // 選中時提高陰影
                          shape: RoundedRectangleBorder(
                            // 圓角邊框
                            borderRadius: BorderRadius.circular(12.0),
                            side: isSelected
                                ? BorderSide(
                                    color: locationType.color,
                                    width: 2.0,
                                  )
                                : BorderSide.none, // 選中時添加邊框
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                locationType.icon, // 使用 extension 獲取圖標
                                size: 40,
                                color: isSelected
                                    ? Colors.white
                                    : locationType.color, // 根據選擇狀態改變圖標顏色
                              ),
                              const SizedBox(height: 8),
                              Text(
                                typeValue, // 使用 extension 獲取標籤
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87, // 根據選擇狀態改變文字顏色
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24), // 按鈕上方留白
                ElevatedButton(
                  onPressed: () {
                    // 驗證當前頁面的選擇數量 (最少 1 項，最多 5 項)
                    if (_isSelectionCountValid(
                      userPreferences.locationTypes,
                      1,
                      5,
                    )) {
                      // **在導航前保存到資料庫**

                      // 導航到下一個偏好設定頁面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AccommodationTypeSelectionPage(),
                        ),
                      );
                    } else {
                      // 顯示警告訊息
                      _showSelectionCountWarningDialog(
                        PreferenceCategory.locationTypes,
                        1,
                        5,
                      );
                    }
                  },
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
