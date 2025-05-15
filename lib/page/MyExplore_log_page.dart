import 'package:flutter/material.dart';
import 'all_page.dart'; // 匯入所有頁面

class MyExploreLogPage extends StatelessWidget {
  const MyExploreLogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> logs = [
      {
        'title': '九份老街探訪',
        'date': '2024/04/12',
        'detail': '造訪了九份老街，品嚐芋圓、草仔粿與傳統茶館美景，並拍攝了山城夜景。'
      },
      {
        'title': '金山溫泉放鬆之旅',
        'date': '2024/04/05',
        'detail': '入住金山溫泉飯店，享受私人湯屋與在地海產，傍晚至磺港散步拍照。'
      },
      {
        'title': '淡水河岸美食散策',
        'date': '2024/03/28',
        'detail': '走訪淡水老街，品嚐阿給、魚丸湯及鐵蛋，黃昏時分欣賞夕陽與街頭藝人表演。'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的探索紀錄'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final log = logs[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: getCardGradientColors(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                log['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                log['date']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(log['title']!),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('日期：${log['date']}'),
                        const SizedBox(height: 12),
                        Text(log['detail'] ?? ''),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('關閉'),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}