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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // if (index == 0) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ExplorePage()),
    //   );
    // }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainCategoryPage()),
      );
    }
    else if (index == 2) {
      Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => StartTravelPage()),
      );
    }
    else if (index == 3) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfilePage()),
      // );
    }
    else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildRoundedButton('住宿'),
                  buildRoundedButton('活動'),
                  buildRoundedButton('景點'),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                '為你推薦',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildImageRecommendationCard(
                      imagePath: 'assets/images/jiufen.png',
                      title: '九份老街',
                      matchRate: '88%',
                      tags: ['親子', '民宿', '湖畔'],
                    ),
                    buildImageRecommendationCard(
                      imagePath: 'assets/images/jinshan.jpg',
                      title: '金山老街',
                      matchRate: '85%',
                      tags: ['親子', '自然'],
                    ),
                    buildImageRecommendationCard(
                      imagePath: 'assets/images/wandering_init.png',
                      title: '金山老街',
                      matchRate: '85%',
                      tags: ['親子', '自然'],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '當前城市推薦',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '自然 × 美食 × 步道 > 九份老街 > 陽陽海',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildFeaturedCard('九份老街', '88%'),
                    buildFeaturedCard('金山老街', '85%'),
                    buildFeaturedCard('金山老街', '85%'),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
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

  Widget buildFeaturedCard(String title, String matchRate) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: [Color(0xFF00e4ff), Color(0xFF00c3ff), Color(0xFF7beec5)],
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

  Widget buildPlaceholderCard() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  Widget buildImageRecommendationCard({
    required String imagePath,
    required String title,
    required String matchRate,
    required List<String> tags,
  }) {
    return Container(
      width: 240,
      margin: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getCardGradientColors(theme: GetTheme(), page: 'explore'),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(tag: tag),
                        ),
                      );
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
      case '民宿': return Colors.blueAccent;
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
          height: 70,
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
              fontSize: 12,
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