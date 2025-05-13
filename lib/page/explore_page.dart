import 'package:flutter/material.dart';
import 'all_page.dart'; // 匯入所有頁面
import 'dart:ui'; // 引入backdropFilter所需的庫

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 在這裡處理按鈕點擊事件，切換頁面
    if (index == 4) { // 如果點擊的是「我的」按鈕 (索引為 4)
      Navigator.push( // 使用 Navigator 導航到 ProfilePage
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
    // 其他按鈕的處理邏輯 (如果需要切換其他頁面)
    // else if (index == 0) { ... 導航到探索頁面 ... }
    // else if (index == 1) { ... 導航到行程頁面 ... }
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 白色背景
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Replace the location icon with the custom image
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/images/wandering_loc.PNG',
                    width: 24, // Adjust size as needed
                    height: 24, // Adjust size as needed
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜尋景點、活動',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: buildRoundedButton('住宿'),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: buildRoundedButton('活動'),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: buildRoundedButton('景點'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Make the \"中原大學\" section horizontally scrollable
            SizedBox(
              height: 220, // Give the ListView a fixed height
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    child: Container(
                      width: 300, // Adjust width as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '中原大學',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '與您偏好 90% 符合',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    child: Container(
                      width: 300, // Adjust width as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '中原大學',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '與您偏好 90% 符合',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            SizedBox(height: 16.0),
            Text(
              '其他推薦',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                // Make the \"其他推薦\" section horizontally scrollable
                scrollDirection: Axis.horizontal,
                children: [
                  buildHorizontalRecommendationCard(),
                  SizedBox(width: 12.0), // Added spacing between cards
                  buildHorizontalRecommendationCard(),
                  SizedBox(width: 12.0), // Added spacing between cards
                  buildHorizontalRecommendationCard(),
                  SizedBox(width: 12.0), // Added spacing between cards
                  // Add more items as needed
                ],

              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar( // 使用自訂的底部導航欄
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildRoundedButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper widget for horizontal recommendation cards
  Widget buildHorizontalRecommendationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      child: Container(
        width: 150, // Adjust width as needed
        color: Colors.grey[300], // Placeholder color
        // Add content for the recommendation card here
      )
    );
  }
}

// 自訂的底部導航欄 Widget
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect( // 使用 ClipRRect 來實現圓角
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // 設置頂部圓角
      child: BackdropFilter( // 使用 BackdropFilter 來實現磨砂玻璃效果
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 設置模糊程度
        child: Container(
          height: 70, // 設置底部導航欄的高度
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // 設置背景色和透明度
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 平均分佈按鈕
            children: <Widget>[
              buildNavBarItem(Icons.explore, 0, '探索'), // 羅盤圖標
              buildNavBarItem(Icons.calendar_today, 1, '行程'), // 日曆圖標
              buildFloatingNavBarItem(Icons.airplanemode_active_outlined, 2, '推薦'), // 骰子圖標 (中間突出按鈕)
              buildNavBarItem(Icons.chat_bubble_outline, 3, '聊天'), // 聊天圖標
              buildNavBarItem(Icons.person_outline, 4, '我的'), // 個人圖標
            ],
          ),
        ),
      ),
    );
  }

  // 普通按鈕的構建函數
  Widget buildNavBarItem(IconData icon, int index, String label) {
    return InkWell( // 使用 InkWell 實現點擊效果
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selectedIndex == index ? Colors.blue : Colors.grey, // 根據是否選中改變顏色
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selectedIndex == index ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 中間突出按鈕的構建函數
  Widget buildFloatingNavBarItem(IconData icon, int index, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 20), // 向下偏移以實現突出效果
      child: FloatingActionButton( // 使用 FloatingActionButton 來實現中間突出效果
        onPressed: () => onItemTapped(index),
        child: Icon(icon),
        elevation: 0, // 去掉陰影
      ),
    );
  }
}