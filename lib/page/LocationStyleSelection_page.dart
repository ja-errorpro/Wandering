import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'all_page.dart';
// import 'package:provider/provider.dart'; // 導入 Provider
// import './../preference_data.dart'; // 確保導入你的 preference_data.dart (包含 LocationType 枚舉和 UserPreferences 類)

// import 'package:Wandering/model/user_database_handler.dart';
// import 'package:Wandering/auth.dart';
// import 'package:Wandering/model/user_model.dart';


class LocationTypeSelectionPage extends StatefulWidget {
  const LocationTypeSelectionPage({super.key});

  @override
  State<LocationTypeSelectionPage> createState() =>
      _LocationTypeSelectionPageState();
}

class _LocationTypeSelectionPageState extends State<LocationTypeSelectionPage> {
  final List<Map<String, dynamic>> locationTypes = [
    {'label': '博物館', 'icon': Icons.museum},
    {'label': '地標建築', 'icon': Icons.location_city},
    {'label': '市場/夜市', 'icon': Icons.storefront},
    {'label': '老街', 'icon': Icons.forest},
    {'label': '公園／廣場', 'icon': Icons.park},
    {'label': '咖啡廳', 'icon': Icons.local_cafe},
    {'label': '藝文空間', 'icon': Icons.menu_book},
    {'label': '廟宇／宗教地', 'icon': Icons.temple_buddhist},
    {'label': '夜景觀景點', 'icon': Icons.nightlight},
    {'label': '步道/自然', 'icon': Icons.hiking},
    {'label': '海邊／湖畔', 'icon': Icons.waves},
  ];

  final Set<String> selected = {};

  bool get isValid => selected.isNotEmpty;
  bool get isMaxSelected => selected.length >= 5;
  
  void _toggleSelection(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else if (!isMaxSelected) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccommodationTypeSelectionPage(),
                ),
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
                '那些地方會令你停下腳步?（ 1~5 項）',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: locationTypes.map((item) {
                  final label = item['label'] as String;
                  final isSelected = selected.contains(label);
                  final disabled = !isSelected && isMaxSelected;

                  return GestureDetector(
                    onTap: () => _toggleSelection(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getCardGradientColors()[1]
                            : (disabled ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? getCardGradientColors()[2] : Colors.white70,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: disabled ? 0.4 : 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 32, color: isSelected ? Colors.white : Colors.black),
                            const SizedBox(height: 8),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
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
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                )
                    : const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isValid
                      ? () {
                    // 儲存偏好
                    setSelectedListByName(
                      'selectedLocationTypes',
                      selected.toList(),
                    );

                    // 導向下一頁
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AccommodationTypeSelectionPage(),
                      ),
                    );
                  }
                      : null,
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: const Text(
                      '下一步',
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