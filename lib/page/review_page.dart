import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'all_page.dart';

class FeedbackStatsPage extends StatelessWidget {
  final double averageRating;
  final Map<String, int> wordFrequencies; // e.g. {'景點': 12, '乾淨': 9, '便捷': 5}

  const FeedbackStatsPage({
    super.key,
    required this.averageRating,
    required this.wordFrequencies,
  });

  @override
  Widget build(BuildContext context) {
    final topWords = wordFrequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('使用者回饋統計'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⭐ 平均星等', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(
              child: Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 32),
            const Text('🔍 熱門關鍵詞', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topWords.take(10).map((e) => Chip(
                label: Text('#${e.key} (${e.value})'),
                backgroundColor: Colors.blue.shade100,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
