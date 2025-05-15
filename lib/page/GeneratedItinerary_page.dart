import 'package:flutter/material.dart';
import 'all_page.dart';
import './../random_data.dart';

class GeneratedItineraryPage extends StatelessWidget {
  final String slogan;
  final Map<String, List<ItineraryItem>> dailyItinerary;
  final Map<String, List<HotelRecommendation>> dailyHotels;

  const GeneratedItineraryPage({
    super.key,
    required this.slogan,
    required this.dailyItinerary,
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
                  // 確保 getCardGradientColors 可用
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

            // 遍歷每日行程
            ...dailyItinerary.entries.map((entry) {
              final String date = entry.key;
              final List<ItineraryItem> itemsForDay = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顯示日期標題
                  Text(
                    date,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),

                  // 遍歷並顯示該日期的行程項目
                  ...itemsForDay.map((item) {
                    // 包裝行程項目 Container 讓它可以被點擊
                    return GestureDetector(
                      // 點擊事件處理
                      onTap: () {
                        // 檢查是否為用餐項目 (判斷條件可以根據實際數據決定，例如檢查名稱或是否有 restaurantName 欄位)
                        // 這裡我們檢查 item.restaurantName 是否非空來判斷
                        if (item.restaurantName != null && item.restaurantName!.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${item.name} 詳細資訊'), // 對話框標題顯示活動名稱
                                content: SingleChildScrollView( // 使用 SingleChildScrollView 防止內容過長溢出
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // 讓 Column 高度最小化
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('餐廳名稱：${item.restaurantName!}'), // 顯示餐廳名稱
                                      const SizedBox(height: 8),
                                      // 顯示推薦品項 (如果有的話)
                                      if (item.recommendedItems != null && item.recommendedItems!.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('推薦品項：', style: TextStyle(fontWeight: FontWeight.bold)),
                                            // 遍歷推薦品項列表
                                            ...item.recommendedItems!.map((recItem) => Text('- $recItem')).toList(),
                                          ],
                                        )
                                      else
                                        const Text('無推薦品項'), // 如果沒有推薦品項
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('關閉'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 關閉對話框
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        // 如果不是用餐項目，可以選擇不做任何事，或者顯示一個提示
                        // else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('此為一般活動，無用餐資訊')),
                        //   );
                        // }
                      },
                      child: Container(
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
                            // 如果是用餐項目，可以額外顯示餐廳名稱 (非點擊狀態下)
                            if (item.restaurantName != null && item.restaurantName!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text('地點：${item.restaurantName!}'), // 可以選擇在這裡也顯示餐廳名稱
                              ),
                            if (item.transportationToNext != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('前往方式：${item.transportationToNext}（${item.transportationDuration}）'),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(), // 將行程項目轉換為 Widget 列表

                  const SizedBox(height: 24), // 每天行程結束後的間距
                ],
              );
            }).toList(), // 將每天的 Column 轉換為 Widget 列表，放入 ListView 的 children


            // 每日住宿推薦 (這部分邏輯不變)
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
                )).toList(),
              ],
            )).toList(),
            const SizedBox(height: 24), // 住宿區塊後的間距
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
                // 確保 getCardGradientColors 可用
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
                // 確保 GeneratedLoadingPage 可用
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

// 修改 ItineraryItem 類別，增加餐廳名稱和推薦品項欄位
class ItineraryItem {
  final String name;
  final String arrivalTime;
  final String activityDuration;
  final String? transportationToNext;
  final String? transportationDuration;
  // 新增餐廳相關欄位，設為 nullable 因為並非所有項目都是用餐
  final String? restaurantName;
  final List<String>? recommendedItems;

  ItineraryItem({
    required this.name,
    required this.arrivalTime,
    required this.activityDuration,
    this.transportationToNext,
    this.transportationDuration,
    // 在建構子中接受新的參數
    this.restaurantName,
    this.recommendedItems,
  });
}

// HotelRecommendation 類別定義不變
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
