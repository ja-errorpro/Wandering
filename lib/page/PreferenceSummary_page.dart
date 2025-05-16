import 'package:flutter/material.dart';
import 'all_page.dart';
import './../preference_data.dart';

class PreferenceSummaryPage extends StatelessWidget {
  const PreferenceSummaryPage({super.key});

  /// 取得所有偏好資料
  Map<String, List<String>> getAllPreferences() {
    return {
      '旅遊風格': getSelectedListByName('selectedTravelStyles'),
      '景點類型': getSelectedListByName('selectedLocationTypes'),
      '住宿類型': getSelectedListByName('selectedAccommodationTypes'),
      '避免項目': getSelectedListByName('selectedAvoidTypes'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final preferences = getAllPreferences();

    return Scaffold(
      backgroundColor: getCardGradientColors()[0],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '選好了，讓我看看有什麼',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: preferences.entries.map((entry) {
                    final title = entry.key;
                    final values = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: values.isNotEmpty
                                  ? values.map((item) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade100,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList()
                                  : [
                                const Text(
                                  '尚未選擇',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.teal),
                  ),
                ),
                onPressed: () {
                  // 回到旅遊風格重新設定
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TravelStylePreferencePage()),
                  );
                },
                child: const Text('重新設定偏好'),
              ),
              const SizedBox(height: 12),
              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // 開始推薦流程或回主頁
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ExplorePage()),
                    );
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: const Text(
                      '開始推薦行程',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
