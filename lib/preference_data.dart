import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 假設你用 Firestore
import 'package:firebase_auth/firebase_auth.dart';

/*
 * 存偏好設定，最初初始化，未來可隨著演算法再度更改
 */

enum PreferenceCategory {
  travelStyles,
  locationTypes,
  accommodationTypes,
  avoidTypes,
}

enum TravelStyle {
  culturalExperience, // Cultural Experience (Museums, History, Heritage tours)
  natureScenery, // Nature Scenery (Mountains, Lakes, National Parks)
  culinaryExploration, // Culinary Exploration (Local snacks, Restaurants, Local specialty dishes)
  hiddenGems, // Hidden Gems (Hidden spots, Off-the-beaten-path exploration)
  nightlife, // Nightlife (Nightclubs, Bars, Late-night markets)
  sportsOutdoors, // Sports & Outdoors (Rock climbing, Surfing, Skiing, Rafting, etc. adventure activities)
  shopping, // Shopping (Department stores, Brand stores, Trendy commercial areas)
  artsCulture, // Arts & Culture (Bookstores, Art galleries, Street performers, Old buildings)
  familyFun, // Family Fun (Family farms, Amusement parks, Zoos)
  slowLivingHealing, // Slow Living & Healing (Hot springs, Meditative spots, Rural life)
}

enum LocationType {
  museum, // Museum (History and art exhibitions)
  landmarkBuilding, // Landmark Building (City landmarks, Historical buildings)
  marketNightMarket, // Market/Night Market (Local snacks and shopping hotspots)
  oldStreet, // Old Street!
  parkSquare, // Park/Square (Community, Green spaces, Picnic areas)
  cafe, // Cafe (Hipster spots, Relaxation)
  artsSpace, // Arts Space (e.g. Bookstores/Art galleries, Places for static, culturally rich activities)
  templeReligiousSite, // Temple/Religious Site (Religious culture, Sacred atmosphere)
  nightViewpoint, // Night Viewpoint (High vantage points, Night view photo spots)
  trailNature, // Trail/Nature (Mountain trails, Forests, Wetlands, etc.)
  beachLakeside, // Beach/Lakeside (Scenic views, Suitable for walking)
}

enum AccommodationType {
  hostel, // Hostel (Cheap, Social, Backpacker favorite | Min 1, Max 3)
  bedAndBreakfast, // Bed and Breakfast (Local experience, Cozy environment | Min 1, Max 3)
  starHotel, // Star Hotel (Excellent service, Complete facilities | Min 1, Max 3)
  luxuryResort, // Luxury Resort (High-end experience, Full facilities | Min 1, Max 3)
  campingWildCamping, // Camping/Wild Camping (Close to nature, Tents/Vehicle camping | Min 1, Max 3)
  apartmentSuite, // Apartment/Suite (Free access, Suitable for long stays | Min 1, Max 3)
  any, // Any (No preference, just need a place to sleep | Only choose one)
  flexibleMix, // Flexible Mix (Mix accommodation types depending on the itinerary | Only choose one)
}

enum AvoidType {
  crowdedPlaces, // Crowded Places (Crowded, Queuing, Popular tourist spots)
  highCostAttractions, // High-Cost Attractions (Entry fees, Experience or dining prices too high)
  tightItinerary, // Tight Itinerary (Too many spots in one day, unable to relax)
  adventurousActivities, // Adventurous Activities (High altitude, Extreme, Scary activities)
  humidHotClimate, // Humid and Hot Climate (Tropical or excessively humid environment uncomfortable)
  hotSunnyLocations, // Hot and Sunny Locations (Heatwave cities, Sun exposure)
  noisyEnvironment, // Noisy Environment (Noisy, Loud, Clamorous)
  uncleanSpaces, // Unclean Spaces (Toilets, Rooms or facilities not clean)
  fearOfAnimals, // Fear of Animals (Fear of dogs, snakes, insects or other animals)
}

// 資料結構來儲存使用者偏好
// UserPreferences 類別用於管理用戶的偏好選擇
// 繼承 ChangeNotifier，以便在狀態改變時通知監聽者
class UserPreferences extends ChangeNotifier {
  Set<String> travelStyles;
  Set<String> locationTypes;
  Set<String> accommodationTypes;
  Set<String> avoidTypes; // 添加 avoidTypes

  UserPreferences({
    Set<String>? travelStyles,
    Set<String>? locationTypes,
    Set<String>? accommodationTypes,
    Set<String>? avoidTypes, // 添加 avoidTypes 參數
  }) : travelStyles = travelStyles ?? {},
       locationTypes = locationTypes ?? {},
       accommodationTypes = accommodationTypes ?? {},
       avoidTypes = avoidTypes ?? {}; // 初始化 avoidTypes

  // 更新偏好 (您原有的方法)
  void updatePreference(
    PreferenceCategory category,
    String value,
    bool isSelected,
  ) {
    switch (category) {
      case PreferenceCategory.travelStyles:
        if (isSelected) {
          travelStyles.add(value);
        } else {
          travelStyles.remove(value);
        }
        break;
      case PreferenceCategory.locationTypes:
        if (isSelected) {
          locationTypes.add(value);
        } else {
          locationTypes.remove(value);
        }
        break;
      case PreferenceCategory.accommodationTypes:
        if (isSelected) {
          accommodationTypes.add(value);
        } else {
          accommodationTypes.remove(value);
        }
        break;
      case PreferenceCategory.avoidTypes: // 添加 avoidTypes 的更新邏輯
        if (isSelected) {
          avoidTypes.add(value);
        } else {
          avoidTypes.remove(value);
        }
        break;
    }
    notifyListeners(); // 通知監聽者偏好已更改
  }

  // 將 UserPreferences 對象轉換為 Map (用於保存到資料庫)
  Map<String, dynamic> toMap() {
    return {
      // 注意：這裡將 Set 轉換為逗號分隔的字符串
      'travelStyles': travelStyles.join(','),
      'locationTypes': locationTypes.join(','),
      'accommodationTypes': accommodationTypes.join(','),
      'avoidTypes': avoidTypes.join(','), // 添加 avoidTypes
    };
  }

  // 從 Map 創建 UserPreferences 對象 (用於從資料庫讀取)
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    // 注意：這裡將逗號分隔的字符串轉換回 Set
    return UserPreferences(
      travelStyles: Set<String>.from(map['travelStyles']?.split(',') ?? []),
      locationTypes: Set<String>.from(map['locationTypes']?.split(',') ?? []),
      accommodationTypes: Set<String>.from(
        map['accommodationTypes']?.split(',') ?? [],
      ),
      avoidTypes: Set<String>.from(
        map['avoidTypes']?.split(',') ?? [],
      ), // 添加 avoidTypes
    );
  }

  // 判斷偏好是否為空的方法 (用於檢查用戶是否已經設定過偏好)
  bool get isEmpty {
    return travelStyles.isEmpty &&
        locationTypes.isEmpty &&
        accommodationTypes.isEmpty &&
        avoidTypes.isEmpty; // 包含 avoidTypes
  }
}

// 獲取當前登入使用者的 UID
String? getCurrentUserUid() {
  final user = FirebaseAuth.instance.currentUser;
  return 'Tiw0cYt9q5XNjjNHEtzaCMBiCED2'; //user?.uid;
  // return 1;
}

/*
// 狀態變數來儲存選取的偏好
Set<String> selectedTravelStyles = {};
Set<String> selectedLocationTypes = {};
Set<String> selectedAvoids = {};
Set<String> selectedAccommodations = {};


// 偏好類型資料 (保持不變)
final List<String> travelStyles = [
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

final List<String> locationTypes = [
  '博物館', // 歷史與藝術展覽
  '地標建築', // 城市地標、歷史性建築
  '市場/夜市', // 在地小吃與逛街熱點
  '老街', //
  '公園／廣場', // 社區、綠地、野餐空間
  '咖啡廳', // 文青聚點、休息放鬆
  '藝文空間', // ex.書店／藝廊, 喜歡靜態、具文化氣息的場域
  '廟宇／宗教地', // 宗教文化、神聖氛圍
  '夜景觀景點', // 高處眺望點、夜景打卡
  '步道/自然', // 山林小徑、森林、濕地等
  '海邊／湖畔', // 風景優美、適合散步
];
final List<String> accommodationTypes = [
  '青年旅館', // 便宜、社交型、背包客最愛 | 至少1，最多3 |
  '民宿', // 在地體驗、溫馨環境    | 至少1，最多3 |
  '星級飯店', // 服務周到、設備完善    | 至少1，最多3 |
  '豪華渡假村', // 高檔享受、設施齊全    | 至少1，最多3 |
  '露營／野營', // 親近自然、帳篷／車宿   | 至少1，最多3 |
  '公寓／套房', // 自由進出、適合長住    | 至少1，最多3 |
  '任意皆可', // 不挑住宿，只要能睡就行  | 只能選一 |
  '靈活混搭', // 視行程安排混合住宿類型  | 只能選一 |
];
final List<String> avoidTypes = [
  '人多的地方', // 擁擠、排隊、熱門觀光景點
  '高消費景點', // 門票、體驗或餐飲價格過高
  '行程太緊湊', // 一天排太多點無法放鬆
  '冒險刺激活動', // 高空、極限、驚嚇型活動
  '潮濕悶熱氣候', // 熱帶或過度潮濕環境不舒服
  '高溫炎熱地點', // 熱浪城市、曝曬
  '吵雜環境', // 吵雜、喧鬧、嘈雜
  '不乾淨的空間', // 廁所、房間或設施不整潔
  '害怕動物', // 害怕狗、蛇、昆蟲或其他動物
];

*/
