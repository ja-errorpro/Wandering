import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../preference_data.dart';  // 確保導入你的 preference_data.dart 和 LocationType 定義
import 'AccommodationTypeSelection_page.dart'; // 導入下一個頁面
import './../savePreferencesLocally.dart' as savePreferencesLocally; // 導入本地保存函數

// 定義 LocationType 的圖示和顏色 (範例，你需要根據你的設計添加所有地點類型)
// 建議在 preference_data.dart 中為 LocationType 添加相關屬性
extension LocationTypeDetails on LocationType {
  IconData get icon {
    switch (this) {
      case LocationType.Museum:
        return Icons.account_balance;
      case LocationType.Market:
        return Icons.shopping_bag;
      case LocationType.HikingNature:
        return Icons.nature;
      case LocationType.Cafe:
        return Icons.coffee;
      case LocationType.LandmarkBuilding:
        return Icons.apartment;
      case LocationType.BeachLake:
        return Icons.beach_access;
      case LocationType.TempleReligion:
        return Icons.temple_hindu;
      case LocationType.BookstoreLibrary:
        return Icons.book;
      case LocationType.ParkSquare:
        return Icons.park;
      case LocationType.NightView:
        return Icons.nightlight_round;
      // 添加其他地點類型的圖示
      default:
        return Icons.help_outline; // 預設圖示
    }
  }

  Color get color {
     switch (this) {
      case LocationType.Museum:
        return Colors.blue;
      case LocationType.Market:
        return Colors.amber;
      case LocationType.HikingNature:
        return Colors.green;
      case LocationType.Cafe:
        return Colors.redAccent;
      case LocationType.LandmarkBuilding:
        return Colors.red;
      case LocationType.BeachLake:
        return Colors.lightBlue;
      case LocationType.TempleReligion:
        return Colors.deepPurple;
      case LocationType.BookstoreLibrary:
        return Colors.brown;
      case LocationType.ParkSquare:
        return Colors.greenAccent;
      case LocationType.NightView:
        return Colors.deepPurpleAccent;
      // 添加其他地點類型的顏色
      default:
        return Colors.grey; // 預設顏色
    }
  }

  String get label {
    return this.toString().split('.').last; // 使用之前的邏輯獲取文字標籤
  }
}


class LocationTypeSelectionPage extends StatefulWidget {
  const LocationTypeSelectionPage({super.key});

  @override
  State<LocationTypeSelectionPage> createState() => _LocationTypeSelectionPageState();
}

class _LocationTypeSelectionPageState extends State<LocationTypeSelectionPage> {
  Set<String> _selectedLocationTypes = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final loadedPreferences = await savePreferencesLocally.loadPreferencesLocally();
    if (loadedPreferences != null) {
      setState(() {
        _selectedLocationTypes = loadedPreferences.locationTypes;
      });
    }
  }

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

   bool _isSelectionCountValid(Set<String> selectedSet, int minCount, int maxCount) {
    return selectedSet.length >= minCount && selectedSet.length <= maxCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('選擇偏好地點類型')),
      body: Padding(
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
            Expanded( // 使用 Expanded 讓 GridView 佔滿剩餘空間
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 每行顯示 3 個
                  crossAxisSpacing: 12.0, // 水平間距
                  mainAxisSpacing: 12.0, // 垂直間距
                  childAspectRatio: 0.8, // 調整每個網格項目的長寬比
                ),
                itemCount: LocationType.values.length,
                itemBuilder: (context, index) {
                  final locationType = LocationType.values[index];
                  final typeValue = locationType.label; // 使用 extension 獲取 label
                  final isSelected = _selectedLocationTypes.contains(typeValue);

                  return InkWell( // 使用 InkWell 使卡片可點擊
                    onTap: () {
                      // 檢查選擇數量是否超過最大限制 (5項)
                       if (!isSelected && _selectedLocationTypes.length >= 5) { // 只有在未選中且數量超過時才提示
                          _showSelectionCountWarningDialog(
                            PreferenceCategory.locationTypes,
                            1,
                            5,
                          );
                          return; // 不允許選擇更多
                       }

                      setState(() {
                        if (isSelected) {
                          _selectedLocationTypes.remove(typeValue);
                        } else {
                          _selectedLocationTypes.add(typeValue);
                        }
                      });
                    },
                    child: Card( // 使用 Card 創建卡片效果
                       color: isSelected ? locationType.color.withOpacity(0.8) : Colors.white, // 選中時改變背景色
                       elevation: isSelected ? 8.0 : 2.0, // 選中時提高陰影
                       shape: RoundedRectangleBorder( // 圓角邊框
                         borderRadius: BorderRadius.circular(12.0),
                          side: isSelected ? BorderSide(color: locationType.color, width: 2.0) : BorderSide.none, // 選中時添加邊框
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                            Icon(
                              locationType.icon, // 使用 extension 獲取圖示
                              size: 48,
                              color: isSelected 