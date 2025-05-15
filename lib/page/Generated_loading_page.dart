import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'all_page.dart';

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
    List<ItineraryItem> itinerary = [
      ItineraryItem(
        name: '中正紀念堂',
        arrivalTime: '09:00',
        activityDuration: '1 小時',
        transportationToNext: '捷運',
        transportationDuration: '15 分鐘',
      ),
      ItineraryItem(
        name: '華山文創園區',
        arrivalTime: '10:30',
        activityDuration: '1.5 小時',
      ),
    ];

    Map<String, List<HotelRecommendation>> hotels = {
      'Day 1': [
        HotelRecommendation(
          name: 'W Taipei',
          checkIn: '15:00',
          checkOut: '12:00',
          price: '\$2300/晚',
          breakfastIncluded: true,
          internetIncluded: true,
          description: '時尚現代飯店，位於信義區核心。',
        ),
        HotelRecommendation(
          name: '旅樂序2館',
          checkIn: '16:00',
          checkOut: '11:00',
          price: '\$1500/晚',
          breakfastIncluded: false,
          internetIncluded: true,
          description: '舒適平價住宿，交通便利。',
        )
      ],
    };

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GeneratedItineraryPage(
          slogan: 'AI 為你量身打造的旅行體驗 ✨',
          itineraryItems: itinerary,
          dailyHotels: hotels,
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
              valueColor: AlwaysStoppedAnimation<Color>(getCardGradientColors()[2]),
            ),
          ],
        ),
      ),
    );
  }
}
