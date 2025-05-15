import 'dart:math';

// ==========================================================================
// Data Model Classes (定義行程和住宿項目的結構)
// ==========================================================================

class ItineraryItem {
  final String name;
  final String arrivalTime;
  final String activityDuration;
  final String? transportationToNext;
  final String? transportationDuration;
  final String? restaurantName;
  final List<String>? recommendedItems;

  ItineraryItem({
    required this.name,
    required this.arrivalTime,
    required this.activityDuration,
    this.transportationToNext,
    this.transportationDuration,
    this.restaurantName,
    this.recommendedItems,
  });
}

class HotelRecommendation {
  final String name;
  final String checkIn;
  final String checkOut;
  final String price;
  final bool breakfastIncluded;
  final bool internetIncluded;
  final String description;

  HotelRecommendation({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.breakfastIncluded,
    required this.internetIncluded,
    required this.description,
  });
}

// Helper class to bundle itinerary and hotel data for a full trip
class ItineraryData {
  final String slogan;
  final Map<String, List<ItineraryItem>> daily_Itinerary;
  final Map<String, List<HotelRecommendation>> daily_Hotels;

  ItineraryData({
    required this.slogan,
    required this.daily_Itinerary,
    required this.daily_Hotels,
  });
}

// ==========================================================================
// Potential Data Pools (所有可能的行程和住宿項目列表)
// ==========================================================================

// 按天數分類的行程池
final Map<int, List<ItineraryItem>> _potentialItineraryItemsByDay = {
  1: [ // 第一天行程池
    ItineraryItem(name: '抵達桃園機場', arrivalTime: '10:00', activityDuration: '1 小時'),
    ItineraryItem(name: '抵達松山機場', arrivalTime: '10:30', activityDuration: '45 分鐘'),
    ItineraryItem(name: '搭乘機場捷運前往市區', arrivalTime: '11:30', activityDuration: '1 小時', transportationToNext: '機場捷運', transportationDuration: '40 分鐘'),
    ItineraryItem(name: '搭乘客運前往市區', arrivalTime: '11:30', activityDuration: '1.5 小時', transportationToNext: '國光客運', transportationDuration: '1 小時'),
    ItineraryItem(name: '飯店 Check-in & 放行李', arrivalTime: '12:30', activityDuration: '30 分鐘'),
    ItineraryItem(name: '前往住宿地寄放行李', arrivalTime: '12:00', activityDuration: '30 分鐘', transportationToNext: '計程車', transportationDuration: '15 分鐘'),
    ItineraryItem( // 用餐項目
      name: '午餐 - 台北特色牛肉麵', arrivalTime: '13:00', activityDuration: '1.5 小時',
      restaurantName: '林東芳牛肉麵', recommendedItems: ['招牌牛肉麵', '花干'], transportationToNext: '步行', transportationDuration: '15 分鐘',
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 永康街小吃', arrivalTime: '13:00', activityDuration: '1 小時',
      restaurantName: '度小月擔仔麵', recommendedItems: ['擔仔麵', '貢丸'], transportationToNext: '步行', transportationDuration: '10 分鐘',
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 火車站便當', arrivalTime: '12:45', activityDuration: '45 分鐘',
      restaurantName: '台鐵便當', recommendedItems: ['排骨便當', '雞腿便當'], transportationToNext: '步行', transportationDuration: '5 分鐘',
    ),
    ItineraryItem(name: '參觀中正紀念堂', arrivalTime: '15:00', activityDuration: '2 小時', transportationToNext: '捷運', transportationDuration: '10 分鐘'),
    ItineraryItem(name: '參觀台北101觀景台', arrivalTime: '15:30', activityDuration: '2 小時', transportationToNext: '捷運', transportationDuration: '20 分鐘'),
    ItineraryItem(name: '體驗永康街文青氛圍', arrivalTime: '17:30', activityDuration: '1.5 小時', transportationToNext: '步行', transportationDuration: '5 分鐘'),
    ItineraryItem(name: '逛信義商圈', arrivalTime: '18:00', activityDuration: '2 小時', transportationToNext: '捷運', transportationDuration: '20 分鐘'),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 士林夜市小吃', arrivalTime: '19:00', activityDuration: '2 小時',
      restaurantName: '士林夜市', recommendedItems: ['豪大大雞排', '大腸包小腸', '青蛙下蛋'], transportationToNext: '捷運', transportationDuration: '15 分鐘',
    ),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 東區火鍋', arrivalTime: '19:30', activityDuration: '1.5 小時',
      restaurantName: '某連鎖火鍋店', recommendedItems: ['麻辣湯底', '美國牛肉'], transportationToNext: '捷運', transportationDuration: '10 分鐘',
    ),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 饒河夜市美食', arrivalTime: '20:00', activityDuration: '1.5 小時',
      restaurantName: '饒河街觀光夜市', recommendedItems: ['藥燉排骨', '胡椒餅'], transportationToNext: '捷運', transportationDuration: '15 分鐘',
    ),
    ItineraryItem(name: '返回飯店休息', arrivalTime: '21:30', activityDuration: '1 小時', transportationToNext: '捷運', transportationDuration: '20 分鐘'),
  ],
  2: [ // 第二天行程池
    ItineraryItem(
      name: '飯店享用早餐', arrivalTime: '08:00', activityDuration: '1 小時',
      restaurantName: '飯店自助餐', recommendedItems: null,
    ),
    ItineraryItem(
      name: '外出吃早餐 - 傳統豆漿店', arrivalTime: '08:30', activityDuration: '45 分鐘',
      restaurantName: '阜杭豆漿', recommendedItems: ['厚燒餅夾蛋油條', '冰豆漿'], transportationToNext: '捷運', transportationDuration: '10 分鐘',
    ),
    ItineraryItem(name: '搭乘貓空纜車', arrivalTime: '09:30', activityDuration: '2 小時', transportationToNext: '捷運轉公車', transportationDuration: '40 分鐘'),
    ItineraryItem(name: '陽明山賞花/步道', arrivalTime: '10:00', activityDuration: '3 小時', transportationToNext: '公車', transportationDuration: '30 分鐘'),
    ItineraryItem(name: '平溪放天燈', arrivalTime: '10:30', activityDuration: '3 小時', transportationToNext: '火車', transportationDuration: '1 小時'),
    ItineraryItem(name: '貓空茶園漫步', arrivalTime: '11:30', activityDuration: '1 小時'),
    ItineraryItem( // 用餐項目
      name: '午餐 - 貓空特色茶餐', arrivalTime: '12:30', activityDuration: '1.5 小時',
      restaurantName: '貓空茶屋', recommendedItems: ['茶香炒飯', '文山包種茶'],
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 陽明山野菜', arrivalTime: '13:00', activityDuration: '1.5 小時',
      restaurantName: '陽明山餐廳A', recommendedItems: ['山菜拼盤', '土雞'], transportationToNext: '步行', transportationDuration: '5 分鐘',
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 平溪老街小吃', arrivalTime: '13:00', activityDuration: '1 小時',
      restaurantName: '平溪老街', recommendedItems: ['香腸', '芋圓'],
    ),
    ItineraryItem(name: '前往動物園', arrivalTime: '14:30', activityDuration: '3 小時', transportationToNext: '纜車轉捷運', transportationDuration: '30 分鐘'),
    ItineraryItem(name: '九份老街散步', arrivalTime: '15:00', activityDuration: '3 小時', transportationToNext: '公車', transportationDuration: '40 分鐘'),
    ItineraryItem(name: '東北角海岸風景區', arrivalTime: '14:00', activityDuration: '4 小時', transportationToNext: '火車轉公車', transportationDuration: '1.5 小時'),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 貓空夜景餐廳', arrivalTime: '18:00', activityDuration: '1.5 小時',
      restaurantName: '邀月茶坊', recommendedItems: ['簡餐', '泡茶'],
    ),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 九份芋圓及小吃', arrivalTime: '18:00', activityDuration: '1.5 小時',
      restaurantName: '九份老街', recommendedItems: ['芋圓', '草仔粿', '魚丸湯'],
    ),
    ItineraryItem( // 用餐項目
      name: '晚餐 - 基隆廟口夜市', arrivalTime: '19:00', activityDuration: '2 小時',
      restaurantName: '基隆廟口夜市', recommendedItems: ['鼎邊銼', '天婦羅'], transportationToNext: '公車', transportationDuration: '30 分鐘',
    ),
    ItineraryItem(name: '返回市區/飯店', arrivalTime: '20:00', activityDuration: '1 小時', transportationToNext: '公車/捷運', transportationDuration: '40 分鐘'),
  ],
  3: [ // 第三天行程池 (假設是離開日，行程較少)
    ItineraryItem(name: '早餐', arrivalTime: '08:30', activityDuration: '1 小時'),
    ItineraryItem(name: '飯店 Check-out', arrivalTime: '09:30', activityDuration: '30 分鐘'),
    ItineraryItem(name: '逛迪化街年貨大街', arrivalTime: '10:00', activityDuration: '2 小時', transportationToNext: '捷運', transportationDuration: '15 分鐘'),
    ItineraryItem(name: '參觀士林官邸', arrivalTime: '10:00', activityDuration: '2 小時', transportationToNext: '捷運', transportationDuration: '20 分鐘'),
    ItineraryItem(name: '參觀華山1914文創園區', arrivalTime: '10:30', activityDuration: '2.5 小時', transportationToNext: '捷運', transportationDuration: '10 分鐘'),
    ItineraryItem( // 用餐項目
      name: '午餐 - 迪化街小吃', arrivalTime: '12:30', activityDuration: '1 小時',
      restaurantName: '永樂市場周邊', recommendedItems: ['慈聖宮前美食'],
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 華山文創園區內餐廳', arrivalTime: '13:00', activityDuration: '1.5 小時',
      restaurantName: '華山某餐廳', recommendedItems: ['義大利麵', '輕食'],
    ),
    ItineraryItem( // 用餐項目
      name: '午餐 - 機場美食街', arrivalTime: '14:00', activityDuration: '1 小時',
      restaurantName: '桃園機場美食廣場', recommendedItems: ['速食', '咖啡'], transportationToNext: null, transportationDuration: null, // 假設已在機場
    ),
    ItineraryItem(name: '最後採購/伴手禮', arrivalTime: '13:30', activityDuration: '1.5 小時'),
    ItineraryItem(name: '前往桃園機場準備返程', arrivalTime: '15:30', activityDuration: '2 小時', transportationToNext: '機場捷運', transportationDuration: '40 分鐘'),
    ItineraryItem(name: '前往松山機場準備返程', arrivalTime: '16:00', activityDuration: '1.5 小時', transportationToNext: '捷運', transportationDuration: '20 分鐘'),
  ],
};

// 按日期 Key 分類的住宿池
final Map<String, List<HotelRecommendation>> _potentialHotelsByDayKey = {
  "第一天 住宿 (10月27日晚)": [
    HotelRecommendation(
      name: '台北車站附近飯店 A', checkIn: '15:00', checkOut: '11:00',
      price: 'NT\$3000', breakfastIncluded: true, internetIncluded: true,
      description: '交通方便，房間乾淨舒適，適合商務和旅遊。',
    ),
    HotelRecommendation(
      name: '西門町潮流旅店 B', checkIn: '16:00', checkOut: '12:00',
      price: 'NT\$2500', breakfastIncluded: false, internetIncluded: true,
      description: '位於西門町鬧區，逛街購物美食都方便，設計年輕化。',
    ),
    HotelRecommendation(
      name: '中山區設計酒店', checkIn: '15:00', checkOut: '11:00',
      price: 'NT\$3200', breakfastIncluded: true, internetIncluded: true,
      description: '設計感十足，附近多百貨公司。',
    ),
  ],
  "第二天 住宿 (10月28日晚)": [
    HotelRecommendation(
      name: '信義區高級飯店 C', checkIn: '15:00', checkOut: '11:00',
      price: 'NT\$6000', breakfastIncluded: true, internetIncluded: true,
      description: '正對台北101，擁有絕佳城市景觀，設施豪華，服務周到。',
    ),
    HotelRecommendation(
      name: '東區文創旅店 D', checkIn: '16:00', checkOut: '12:00',
      price: 'NT\$4000', breakfastIncluded: true, internetIncluded: true,
      description: '設計感十足的特色旅店，位於東區購物商圈附近，交通便利。',
    ),
    HotelRecommendation(
      name: '大安區溫馨民宿', checkIn: '15:00', checkOut: '12:00',
      price: 'NT\$2800', breakfastIncluded: false, internetIncluded: true,
      description: '鬧中取靜，溫馨舒適，靠近捷運站。',
    ),
  ],
  // 如果有第三天住宿，可以在這裡添加池 (根據您的行程規劃，本例第三天是離開日沒有住宿)
  // "第三天 住宿 (10月29日晚)": [ ... ]
};


// 預定義的 Slogan 池 (如果需要隨機 Slogan)
final List<String> _potentialSlogans = [
  '三天兩夜台北城市探索之旅！',
  '發現不一樣的台北魅力！',
  '這次的台北之旅充滿驚喜！',
  '專屬於你的台北精選行程！',
  '台北，等你來體驗！',
];


// ==========================================================================
// Random Data Generation Function (隨機生成數據的函數)
// ==========================================================================

final Random _random = Random();

/// 根據提供的日期結構 (Keys) 和 Slogan，隨機生成行程和住宿數據。
/// [initialItineraryStructureKeys] 和 [initialHotelStructureKeys] 只用於確定需要為哪些日期生成數據。
ItineraryData generateRandomItinerary({
  required Map<String, List<ItineraryItem>> initialItineraryStructureKeys,
  required Map<String, List<HotelRecommendation>> initialHotelStructureKeys,
  String? baseSlogan, // 可以選擇基於一個Slogan來生成，或者完全隨機
}) {
  final Map<String, List<ItineraryItem>> newDailyItinerary = {};
  final Map<String, List<HotelRecommendation>> newDailyHotels = {};

  // --- 生成隨機行程 ---
  // 遍歷原始行程數據的日期 Key，確保日期結構不變
  for (final dateKey in initialItineraryStructureKeys.keys) {
    // 嘗試從日期 Key 中提取天數，以便從對應的項目池中選取
    // 這裡做一個簡單的判斷：如果 Key 包含 "第一天" 就是 Day 1 的池，"第二天" 就是 Day 2
    int dayNumber = 0;
    if (dateKey.contains("第一天")) dayNumber = 1;
    else if (dateKey.contains("第二天")) dayNumber = 2;
    else if (dateKey.contains("第三天")) dayNumber = 3;
    // 如果有更多天或不同的命名規則，需要擴充這個邏輯

    final List<ItineraryItem>? potentialItems = _potentialItineraryItemsByDay[dayNumber];

    if (potentialItems != null && potentialItems.isNotEmpty) {
      final List<ItineraryItem> selectedItems = [];
      // 這裡可以根據需要選擇生成多少個項目，或者根據一些規則來選取
      // 為了簡單起見，我們隨機選取一定數量的項目 (例如 5 到 potentialItems.length)
      // 確保至少有1個項目，最多不超過池的大小
      int numberOfItemsToSelect = _random.nextInt(potentialItems.length ~/ 2 + 1) + potentialItems.length ~/ 2 ; // 隨機選擇池中約一半到全部的項目
      if (numberOfItemsToSelect < 1) numberOfItemsToSelect = 1; // 至少選一個
      if (numberOfItemsToSelect > potentialItems.length) numberOfItemsToSelect = potentialItems.length; // 最多選池的大小


      final List<ItineraryItem> itemsToPickFrom = List.from(potentialItems); // 複製列表以便移除已選項目

      for(int i = 0; i < numberOfItemsToSelect && itemsToPickFrom.isNotEmpty; i++){
        final int randomIndex = _random.nextInt(itemsToPickFrom.length);
        selectedItems.add(itemsToPickFrom[randomIndex]);
        itemsToPickFrom.removeAt(randomIndex); // 移除已選，避免重複
      }

      // 可以選擇按時間排序 selectedItems，讓行程看起來合理一些 (如果項目有可比的時間資訊)
      // 這部分邏輯需要更複雜，因為 arrivalTime 是字串，簡單排序可能不對
      // 如果需要嚴謹的時間排序，ItineraryItem 應該包含 Date/Time 對象
      // 這裡暫不實作複雜的時間排序

      newDailyItinerary[dateKey] = selectedItems;
    } else {
      // 如果該日期沒有對應的項目池，保留空列表或根據需要處理
      newDailyItinerary[dateKey] = [];
    }
  }

  // --- 生成隨機住宿 ---
  // 遍歷原始住宿數據的 Key，確保住宿日期結構不變
  for (final hotelKey in initialHotelStructureKeys.keys) {
    final List<HotelRecommendation>? potentialHotels = _potentialHotelsByDayKey[hotelKey];

    if (potentialHotels != null && potentialHotels.isNotEmpty) {
      final List<HotelRecommendation> selectedHotels = [];
      // 隨機選取 1 到 2 個酒店 (確保不超過池的大小)
      int numberOfHotelsToSelect = _random.nextInt(2) + 1;
      if (numberOfHotelsToSelect > potentialHotels.length) numberOfHotelsToSelect = potentialHotels.length;


      final List<HotelRecommendation> hotelsToPickFrom = List.from(potentialHotels); // 複製列表

      for(int i = 0; i < numberOfHotelsToSelect && hotelsToPickFrom.isNotEmpty; i++){
        final int randomIndex = _random.nextInt(hotelsToPickFrom.length);
        selectedHotels.add(hotelsToPickFrom[randomIndex]);
        hotelsToPickFrom.removeAt(randomIndex); // 移除已選
      }

      newDailyHotels[hotelKey] = selectedHotels;

    } else {
      // 如果該日期沒有對應的酒店池，保留空列表或根據需要處理
      newDailyHotels[hotelKey] = [];
    }
  }

  // 隨機選擇一個 Slogan (如果 baseSlogan 為空) 或保留 baseSlogan
  final String finalSlogan = baseSlogan ?? _potentialSlogans[_random.nextInt(_potentialSlogans.length)];


  return ItineraryData(
    slogan: finalSlogan,
    daily_Itinerary: newDailyItinerary,
    daily_Hotels: newDailyHotels,
  );
}

// 可以在這裡提供一個函數，用於在應用啟動時生成第一組數據
ItineraryData generateInitialRandomItinerary() {
  // 定義一個基本的日期結構 (例如三天兩夜)
  // 您也可以根據實際輸入來動態生成這個結構
  final Map<String, List<ItineraryItem>> initialItineraryStructure = {
    "第一天 (10月27日)": [], // 列表是空的，只用於提供 Key
    "第二天 (10月28日)": [],
    "第三天 (10月29日)": [],
  };

  final Map<String, List<HotelRecommendation>> initialHotelStructure = {
    "第一天 住宿 (10月27日晚)": [], // 列表是空的，只用於提供 Key
    "第二天 住宿 (10月28日晚)": [],
    // 第三天沒有住宿
  };

  // 生成第一組隨機數據
  return generateRandomItinerary(
    initialItineraryStructureKeys: initialItineraryStructure,
    initialHotelStructureKeys: initialHotelStructure,
    baseSlogan: _potentialSlogans[_random.nextInt(_potentialSlogans.length)], // 初始 Slogan 也隨機
  );
}