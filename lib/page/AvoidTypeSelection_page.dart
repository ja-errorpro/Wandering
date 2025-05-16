import 'package:flutter/material.dart';
import 'all_page.dart'; // 若接到 Summary 或 MainPage
import './../preference_data.dart';

class AvoidTypeSelectionPage extends StatefulWidget {
  const AvoidTypeSelectionPage({super.key});

  @override
  State<AvoidTypeSelectionPage> createState() => _AvoidTypeSelectionPageState();
}

class _AvoidTypeSelectionPageState extends State<AvoidTypeSelectionPage> {
  final List<Map<String, dynamic>> avoidTypes = [
    {'label': '人多的地方', 'icon': Icons.groups},
    {'label': '高消費景點', 'icon': Icons.attach_money},
    {'label': '行程太緊湊', 'icon': Icons.schedule},
    {'label': '冒險刺激活動', 'icon': Icons.dangerous},
    {'label': '潮濕悶熱氣候', 'icon': Icons.wb_cloudy},
    {'label': '高溫炎熱地點', 'icon': Icons.sunny},
    {'label': '吵雜環境', 'icon': Icons.volume_up},
    {'label': '不乾淨的空間', 'icon': Icons.cleaning_services},
    {'label': '害怕動物', 'icon': Icons.pets},
  ];

  final Set<String> selected = {};

  bool get isValid => selected.isNotEmpty;

  void _toggleSelection(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else {
        selected.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getCardGradientColors()[0],
      appBar: AppBar(
        title: const Text('設定您的偏好'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PreferenceSummaryPage()),
              );
            },
            child: const Text('Skip', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '避開這些，讓旅程更自在',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: avoidTypes.map((item) {
                  final label = item['label'] as String;
                  final isSelected = selected.contains(label);

                  return GestureDetector(
                    onTap: () => _toggleSelection(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getCardGradientColors()[1]
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? getCardGradientColors()[2]
                              : Colors.white70,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'],
                              size: 32,
                              color:
                              isSelected ? Colors.white : Colors.black),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Ink(
                decoration: isValid
                    ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(12)),
                )
                    : const BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                  BorderRadius.all(Radius.circular(12)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isValid
                      ? () {
                    // 儲存
                    setSelectedListByName(
                        'selectedAvoidTypes', selected.toList());

                    // 結束導引導入主頁
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PreferenceSummaryPage()),
                    );
                  }
                      : null,
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: const Text(
                      '下一頁',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
