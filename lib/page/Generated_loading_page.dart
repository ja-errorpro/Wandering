import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'all_page.dart';
// import './../random_data.dart';

class GeneratedLoadingPage extends StatefulWidget {
  const GeneratedLoadingPage({super.key});

  @override
  State<GeneratedLoadingPage> createState() => _GeneratedLoadingPageState();
}

class _GeneratedLoadingPageState extends State<GeneratedLoadingPage> {
  @override
  void initState() {
    super.initState();
    _loadItinerary();
  }

  Future<void> _loadItinerary() async {
    await Future.delayed(const Duration(seconds: 3));

    // 假資料：模擬行程與飯店
    final Map<String, List<ItineraryItem>> sampleDailyItinerary = {
      "第一天 (10月10日)": [
        // 日期字串可以包含實際日期
        ItineraryItem(
          name: '抵達桃園機場',
          arrivalTime: '10:00',
          activityDuration: '1 小時',
        ),
        ItineraryItem(
          name: '搭乘機場捷運前往台北市區',
          arrivalTime: '11:30',
          activityDuration: '1 小時',
          transportationToNext: '機場捷運',
          transportationDuration: '40 分鐘',
        ),
        ItineraryItem(
          name: '飯店 Check-in & 放行李',
          arrivalTime: '12:30',
          activityDuration: '30 分鐘',
        ),
        ItineraryItem(
          // 用餐項目，包含餐廳名稱和推薦品項
          name: '午餐 - 台北特色牛肉麵',
          arrivalTime: '13:00',
          activityDuration: '1.5 小時',
          restaurantName: '林東芳牛肉麵',
          recommendedItems: ['招牌牛肉麵', '花干'],
          transportationToNext: '步行',
          transportationDuration: '15 分鐘',
        ),
        ItineraryItem(
          name: '參觀中正紀念堂',
          arrivalTime: '15:00',
          activityDuration: '2 小時',
          transportationToNext: '捷運',
          transportationDuration: '10 分鐘',
        ),
        ItineraryItem(
          name: '體驗永康街文青氛圍',
          arrivalTime: '17:30',
          activityDuration: '1.5 小時',
          transportationToNext: '步行',
          transportationDuration: '5 分鐘',
        ),
        ItineraryItem(
          // 用餐項目，只包含餐廳名稱 (沒有推薦品項)
          name: '晚餐 - 永康街小吃',
          arrivalTime: '19:00',
          activityDuration: '1.5 小時',
          restaurantName: '鼎泰豐 永康店', // 假設在永康街
          recommendedItems: [], // 可以是空列表或 null
        ),
        ItineraryItem(
          name: '逛信義商圈看夜景',
          arrivalTime: '21:00',
          activityDuration: '2 小時',
          transportationToNext: '捷運',
          transportationDuration: '20 分鐘',
        ),
      ],
      "第二天 (10月11日)": [
        ItineraryItem(
          // 用餐項目 (早餐通常沒有推薦品項)
          name: '飯店享用早餐',
          arrivalTime: '08:00',
          activityDuration: '1 小時',
          restaurantName: '飯店自助餐', // 餐廳名稱
          recommendedItems: null, // 或者 null
        ),
        ItineraryItem(
          name: '搭乘貓空纜車',
          arrivalTime: '09:30',
          activityDuration: '2 小時',
          transportationToNext: '捷運轉公車',
          transportationDuration: '40 分鐘',
        ),
        ItineraryItem(
          name: '貓空茶園漫步',
          arrivalTime: '11:30',
          activityDuration: '1 小時',
        ),
        ItineraryItem(
          // 用餐項目，包含餐廳名稱和推薦品項
          name: '午餐 - 貓空特色茶餐',
          arrivalTime: '12:30',
          activityDuration: '1.5 小時',
          restaurantName: '貓空茶屋',
          recommendedItems: ['茶香炒飯', '文山包種茶'],
        ),
        ItineraryItem(
          name: '前往動物園',
          arrivalTime: '14:30',
          activityDuration: '3 小時',
          transportationToNext: '纜車轉捷運',
          transportationDuration: '30 分鐘',
        ),
        ItineraryItem(
          // 用餐項目，包含餐廳名稱和推薦品項
          name: '晚餐 - 動物園附近美食',
          arrivalTime: '18:00',
          activityDuration: '1.5 小時',
          restaurantName: '木柵鐵板燒',
          recommendedItems: ['雞腿排', '牛肉'],
          transportationToNext: '步行',
          transportationDuration: '10 分鐘',
        ),
        ItineraryItem(
          name: '搭乘捷運回飯店',
          arrivalTime: '19:30',
          activityDuration: '40 分鐘',
          transportationToNext: '捷運',
          transportationDuration: '30 分鐘',
        ),
      ],
      "第三天 (10月12日)": [
        // 增加第三天，但沒有住宿，展示只有行程的情況
        ItineraryItem(
          name: '早餐',
          arrivalTime: '08:30',
          activityDuration: '1 小時',
        ),
        ItineraryItem(
          name: '逛迪化街年貨大街 (如果時間對)',
          arrivalTime: '10:00',
          activityDuration: '2 小時',
          transportationToNext: '捷運',
          transportationDuration: '15 分鐘',
        ),
        ItineraryItem(
          // 用餐項目
          name: '午餐 - 迪化街小吃',
          arrivalTime: '12:30',
          activityDuration: '1 小時',
          restaurantName: '永樂市場周邊',
          recommendedItems: ['慈聖宮前美食'],
        ),
        ItineraryItem(
          name: '最後採購',
          arrivalTime: '13:30',
          activityDuration: '1.5 小時',
        ),
        ItineraryItem(
          name: '前往桃園機場準備返程',
          arrivalTime: '15:30',
          activityDuration: '2 小時',
          transportationToNext: '機場捷運',
          transportationDuration: '40 分鐘',
        ),
      ],
    };

    final Map<String, List<HotelRecommendation>> sampleDailyHotels = {
      "第一天 住宿 (10月13日晚)": [
        HotelRecommendation(
          name: '台北車站附近飯店 A',
          checkIn: '15:00',
          checkOut: '11:00',
          price: 'NT\$3000',
          breakfastIncluded: true,
          internetIncluded: true,
          description: '交通方便，房間乾淨舒適，適合商務和旅遊。',
        ),
        HotelRecommendation(
          name: '西門町潮流旅店 B',
          checkIn: '16:00',
          checkOut: '12:00',
          price: 'NT\$2500',
          breakfastIncluded: false,
          internetIncluded: true,
          description: '位於西門町鬧區，逛街購物美食都方便，設計年輕化。',
        ),
      ],
      "第二天 住宿 (10月14日晚)": [
        HotelRecommendation(
          name: '信義區高級飯店 C',
          checkIn: '15:00',
          checkOut: '11:00',
          price: 'NT\$6000',
          breakfastIncluded: true,
          internetIncluded: true,
          description: '正對台北101，擁有絕佳城市景觀，設施豪華，服務周到。',
        ),
        HotelRecommendation(
          name: '東區文創旅店 D',
          checkIn: '16:00',
          checkOut: '12:00',
          price: 'NT\$4000',
          breakfastIncluded: true,
          internetIncluded: true,
          description: '設計感十足的特色旅店，位於東區購物商圈附近，交通便利。',
        ),
      ],
      // 第三天沒有住宿，所以 dailyHotels 中不需要 "第三天 住宿" 的 Key
    };

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GeneratedItineraryPage(
          slogan: 'AI 為你量身打造的旅行體驗 ✨',
          dailyItinerary: sampleDailyItinerary,
          dailyHotels: sampleDailyHotels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/wandering_5.PNG',
              width: 200,
              height: 200,
              alignment: Alignment(0, -0.15), // 移動到畫面1/3處
            ),
            const SizedBox(height: 24),
            const Text(
              '正在生成你的專屬行程...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                getCardGradientColors()[2],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
