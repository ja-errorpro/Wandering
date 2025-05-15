import 'package:flutter/material.dart';
import 'dart:ui';
import 'all_page.dart';


import 'package:flutter/material.dart';

class MainCategoryPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'label': '住宿', 'image': 'assets/images/avatar.png'},
    {'label': '景點', 'image': 'assets/images/avatar.png'},
    {'label': '娛樂', 'image': 'assets/images/Category/jinshan.jpg'},
    {'label': '文化', 'image': 'assets/images/Category/jinshan.jpg'},
    {'label': '風景', 'image': 'assets/images/Category/wandering_1.PNG'},
    {'label': '交通', 'image': 'assets/images/Category/wandering_1.PNG'},
    {'label': '飲食', 'image': 'assets/images/Category/app_name_1.PNG'},
    {'label': '旅行社', 'image': 'assets/images/Category/app_name_1.PNG'},
    {'label': '慶典', 'image': 'assets/images/Category/app_name_1.PNG'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('選擇你喜歡的標籤'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '您隨時可以更改您的標籤喜好',
              style: TextStyle(color: Colors.lightBlue, fontSize: 14),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: 點擊後導向該分類頁
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            category['image']!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black38,
                            alignment: Alignment.center,
                            child: Text(
                              category['label']!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String tag;

  const CategoryPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#$tag'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '分類頁：$tag',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
