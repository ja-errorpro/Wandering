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
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Center(
        child: Text('Explore Page - Selected Index: $_selectedIndex'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar( // 使用自訂的底部導航欄
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
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