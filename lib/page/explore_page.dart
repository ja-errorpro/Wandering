import 'package:flutter/material.dart';
import 'dart:ui';
import 'all_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 0;
  // 為了主題按鈕的選中狀態，新增一個變數，避免與底部導航欄的 _selectedIndex 衝突
  int _selectedTopicIndex = 0; // 新增變數

  @override
  void initState() {
    super.initState();
    if (getPreferenceChanged() == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreferenceSelectionPage()),
        );
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 根據 index 導航到不同的頁面
    // 使用 pushReplacement 避免底部導航頁面堆疊
    if (index == 0) {
      // 如果點擊的是當前頁面，通常不需要導航
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainCategoryPage()),
      );
    }
    else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartTravelPage()),
      );
    }
    else if (index == 3) {
      // Navigator.pushReplacement(
      //    context,
      //    MaterialPageRoute(builder: (context) => ListLtineraryPage()),
      //  );
    }
    else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  // 主題按鈕點擊事件
  void _onTopicTapped(int index) {
    setState(() {
      _selectedTopicIndex = index; // 更新主題按鈕的選中狀態
    });
    // 這裡可以根據 index 執行篩選或載入不同內容的操作
    print('主題按鈕點擊: $index'); // 示範輸出
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 將 body 內容放在一個 Padding 中，以便應用左右和頂部間距
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 50), // 應用頁面左右和頂部間距
        child: Column( // 最外層 Column，包含固定部分和可滑動部分
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 固定不動的搜尋框部分 ---
            Row(
              children: [
                Image.asset(
                  'assets/images/wandering_loc.PNG',
                  width: 36,
                  height: 36,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
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
            SizedBox(height: 16.0), // 搜尋框下方間距
            // --- 固定部分結束 ---

            // --- 可垂直滑動的部分 ---
            Expanded( // Expanded 讓 SingleChildScrollView 佔滿剩餘的垂直空間
              child: SingleChildScrollView( // 這個 SingleChildScrollView 負責下方內容的垂直滑動
                child: Column( // 這個 Column 包含所有需要垂直滑動的內容
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 可左右拉動的可點擊主題色按鈕列 (這個是水平滑動)
                    // 注意: 原來的 Row(mainAxisAlignment: MainAxisAlignment.start, children: [ SingleChildScrollView(...) ])
                    // 在 Column 中不需要 Row 的外層，可以直接放 SingleChildScrollView
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row( // 這個 Row 放在水平 SingleChildScrollView 裡面是正確的
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 使用 _selectedTopicIndex 來控制主題按鈕的選中狀態
                          buildSelectableButton('景點', getCardGradientColors()[0], 0, _selectedTopicIndex == 0, _onTopicTapped),
                          SizedBox(width: 12),
                          buildSelectableButton('住宿', getCardGradientColors()[0], 1, _selectedTopicIndex == 1, _onTopicTapped),
                          SizedBox(width: 12),
                          buildSelectableButton('親子', getCardGradientColors()[0], 2, _selectedTopicIndex == 2, _onTopicTapped),
                          SizedBox(width: 12),
                          // ... 其他按鈕
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // "為你推薦" 部分 (包含一個水平滑動的 ListView)
                    Text(
                      '為你推薦',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(
                      height: 210, // 固定高度給水平 ListView
                      child: ListView( // 這個是水平滑動，沒問題
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildImageRecommendationCard(
                            imagePath: 'assets/images/jiufen.png',
                            title: '九份老街',
                            matchRate: '88%',
                            tags: ['親子', '民宿', '湖畔'],
                          ),
                          SizedBox(width: 12.0), // 在水平卡片之間添加間距
                          buildImageRecommendationCard(
                            imagePath: 'assets/images/jinshan.jpg',
                            title: '金山老街',
                            matchRate: '85%',
                            tags: ['親子', '自然'],
                          ),
                          SizedBox(width: 12.0),
                          buildImageRecommendationCard(
                            imagePath: 'assets/images/recommends/art_museum.png',
                            title: '朱銘美術館',
                            matchRate: '85%',
                            tags: ['藝術', '文青'],
                          ),
                          // ... 其他推薦卡片
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // "當前城市推薦" 部分 (使用 Column 替代垂直 ListView)
                    Text(
                      '當前城市推薦：台北',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '景點',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8.0), // 添加一些間距

                    // 使用 Column 使卡片垂直堆疊，並讓它們貢獻於父級 SingleChildScrollView 的高度
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 保持與父 Column 對齊
                      children: [
                        // buildFeaturedCard('金山老街', '85%'),
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/Songshan_Cultural_and_Creative_Park.jpg',
                          title: '松三文創園區',
                          matchRate: '79%',
                          tags: ['購物', '景點', '夜景'],
                        ),
                        SizedBox(height: 12.0),
                        // buildFeaturedCard('九份老街', '88%'),
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/taipei_zoo.png',
                          title: '台北市立木柵動物園',
                          matchRate: '73%',
                          tags: ['親子', '景點'],
                        ),
                        SizedBox(height: 12.0),
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/Taipei_101_blue_hour_2016.jpg',
                          title: '台北101',
                          matchRate: '68%',
                          tags: ['購物', '景點', '夜景'],
                        ),
                        // buildFeaturedCard('金山老街', '85%'),
                        // 如果還有更多卡片，繼續在這裡添加，並在它們之間加上 SizedBox
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '美食',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 保持與父 Column 對齊
                      children: [
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/Shilin_Night_Market.jpg',
                          title: '士林夜市',
                          matchRate: '79%',
                          tags: ['美食', '景點', '夜市'],
                        ),
                        SizedBox(height: 12.0),
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/west_door.jpg',
                          title: '西門紅樓',
                          matchRate: '73%',
                          tags: ['購物', '美食', '夜市'],
                        ),
                        SizedBox(height: 12.0),
                        buildImageRecommendationCard(
                          imagePath: 'assets/images/ximending.jpg',
                          title: '西門區',
                          matchRate: '68%',
                          tags: ['購物', '美食'],
                        ),
                        // 如果還有更多卡片，繼續在這裡添加，並在它們之間加上 SizedBox
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '旅館',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),


                    SizedBox(height: 20.0), // 在底部增加一些額外的空間，確保最後的內容不會被底部導航欄遮擋
                  ],
                ),
              ),
            ),
            // --- 可垂直滑動的部分結束 ---
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 修改 buildSelectableButton 函式，接收更多參數來控制選中狀態和點擊事件
  Widget buildSelectableButton(String text, Color color, int index, bool isSelected, Function(int) onTapCallback) {
    return GestureDetector(
      onTap: () {
        onTapCallback(index); // 呼叫傳入的點擊處理函式
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300], // 根據 isSelected 參數決定顏色
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: GetFontSize(),
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87, // 根據 isSelected 參數決定文字顏色
            shadows: [
              Shadow(
                color: Colors.grey.withOpacity(0.6),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // buildRoundedButton 保持不變
  Widget buildRoundedButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: GetFontSize(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // buildFeaturedCard 保持不變 (已移除固定寬度)
  Widget buildFeaturedCard(String title, String matchRate) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: getCardGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: GetFontSize() + 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              matchRate,
              style: TextStyle(
                color: Colors.white,
                fontSize: GetFontSize(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // buildImageRecommendationCard 保持不變
  Widget buildImageRecommendationCard({
    required String imagePath,
    required String title,
    required String matchRate,
    required List<String> tags,
  }) {
    return Container(
      width: 240,
      margin: EdgeInsets.only(right: 12.0), // 水平 ListView 中的卡片之間間距
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getCardGradientColors(),
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags.map((tag) => GestureDetector(
                    onTap: () {
                      // 標籤點擊事件
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor(tag),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text(
                  '與你偏好 $matchRate 符合',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Spacer(),
                Icon(Icons.favorite_border, size: 18, color: Colors.grey),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }



  Color tagColor(String tag) {
    switch (tag) {
      case '親子': return Colors.green;
      case '自然': return Colors.blue;
      case '文青': return Colors.indigo;
      case '藝術': return Colors.purple;
      case '民宿': return Colors.blueAccent;
      case '湖畔': return Colors.teal;
      case '步道': return Colors.orange;
      case '美食': return Colors.red;
      case '景點': return Colors.purple;
      case '活動': return Colors.pink;
      case '旅館': return Colors.brown;
      case '夜市': return Colors.amber;
      case '購物': return Colors.cyan;
      default: return Colors.grey;
    }
  }
}



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
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildNavBarItem(Icons.home, 0, '探索'),
              buildNavBarItem(Icons.tag, 1, '分類'),
              buildFloatingNavBarItem(Icons.airplanemode_active_outlined, 2, ''),
              buildNavBarItem(Icons.calendar_today, 3, '行程'),
              buildNavBarItem(Icons.person_outline, 4, '我的'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String label) {
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: GetFontSize()-2,
              color: selectedIndex == index ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingNavBarItem(IconData icon, int index, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),

      child: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => onItemTapped(index),
          backgroundColor: Color(0xFF00e4ff),
          child: Icon(icon, color: Colors.white),
          elevation: 0,
          shape: const CircleBorder(), // 圓形按鈕
        ),
      ),
    );
  }
}