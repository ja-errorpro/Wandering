import 'package:flutter/material.dart';
import 'all_page.dart';

class GeneratedItineraryPage extends StatelessWidget {
  final String slogan;
  final List<ItineraryItem> itineraryItems;
  final Map<String, List<HotelRecommendation>> dailyHotels;

  const GeneratedItineraryPage({
    super.key,
    required this.slogan,
    required this.itineraryItems,
    required this.dailyHotels,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('為你生成的行程'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Slogan 區塊
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: getCardGradientColors(),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slogan,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '你的推薦行程',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...itineraryItems.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('抵達時間：${item.arrivalTime}'),
                  Text('活動時間：${item.activityDuration}'),
                  if (item.transportationToNext != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('前往方式：${item.transportationToNext}（${item.transportationDuration}）'),
                    ),
                ],
              ),
            )),
            const SizedBox(height: 24),
            const Text(
              '每日住宿推薦',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...dailyHotels.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...entry.value.map((hotel) => GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(hotel.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check-in: ${hotel.checkIn}'),
                          Text('Check-out: ${hotel.checkOut}'),
                          Text('價位：${hotel.price}'),
                          Text('含早餐：${hotel.breakfastIncluded ? "是" : "否"}'),
                          Text('網路：${hotel.internetIncluded ? "有" : "無"}'),
                          const SizedBox(height: 8),
                          Text(hotel.description),
                        ],
                      ),
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('價位：${hotel.price}'),
                          Text('含早餐：${hotel.breakfastIncluded ? "是" : "否"} | 網路：${hotel.internetIncluded ? "有" : "無"}'),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('分享路線'),
              style: ElevatedButton.styleFrom(
                backgroundColor: getCardGradientColors().first,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // TODO: 分享功能實作
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('刷新景點'),
              onPressed: () {
                // TODO: 刷新特定景點功能
                print('刷新景點');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GeneratedLoadingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ItineraryItem {
  final String name;
  final String arrivalTime;
  final String activityDuration;
  final String? transportationToNext;
  final String? transportationDuration;

  ItineraryItem({
    required this.name,
    required this.arrivalTime,
    required this.activityDuration,
    this.transportationToNext,
    this.transportationDuration,
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
