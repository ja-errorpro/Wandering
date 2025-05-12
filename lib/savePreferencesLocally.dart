import 'package:shared_preferences/shared_preferences.dart';
import 'preference_data.dart'; // UserPreferences 類別

// 將用戶偏好保存到本地 (使用 shared_preferences)
Future<void> savePreferencesLocally(UserPreferences preferences) async {
  final prefs = await SharedPreferences.getInstance();

  try {
    // 將 UserPreferences 的各個 Set 屬性轉換為 List<String>
    final travelStylesList = preferences.travelStyles.toList();
    final locationTypesList = preferences.locationTypes.toList();
    final accommodationTypesList = preferences.accommodationTypes.toList();
    // 如果還有其他屬性，也請按照對應的類型進行保存

    // 將 List<String> 保存到 SharedPreferences
    await prefs.setStringList('travelStyles', travelStylesList);
    await prefs.setStringList('locationTypes', locationTypesList);
    await prefs.setStringList('accommodationTypes', accommodationTypesList);
    // 保存其他屬性

    print('用戶偏好已成功保存到本地 (SharedPreferences)。');
  } catch (e) {
    print('保存用戶偏好到本地時發生錯誤: $e');
  }
}

// 從本地加載用戶偏好 (使用 shared_preferences)
Future<UserPreferences?> loadPreferencesLocally() async {
  final prefs = await SharedPreferences.getInstance();

  try {
    final travelStylesList = prefs.getStringList('travelStyles');
    final locationTypesList = prefs.getStringList('locationTypes');
    final accommodationTypesList = prefs.getStringList('accommodationTypes');

    // 只有當所有關鍵偏好列表都存在時，才認為有保存的本地偏好
    if (travelStylesList != null && locationTypesList != null && accommodationTypesList != null) {
      // 從 List<String> 重建 UserPreferences 對象
      return UserPreferences(
        travelStyles: travelStylesList.toSet(), // 假設 UserPreferences 構造函數接受 Set
        locationTypes: locationTypesList.toSet(),
        accommodationTypes: accommodationTypesList.toSet(),
        // 如果還有其他屬性，也請在這裡加載並設置
      );
    }
  } catch (e) {
    print('從本地加載用戶偏好時發生錯誤: $e');
    // 可以在這裡處理數據格式不正確等錯誤
  }

  return null; // 如果本地沒有完整的保存偏好
}
