import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import './../preference_data.dart'; // 確保導入你的 preference_data.dart
// import './../savePreferencesLocally.dart'; // 導入
import 'package:Wandering/model/user_model.dart';
import 'package:Wandering/preference_data.dart';
import 'package:Wandering/auth.dart';
import 'all_page.dart';

class TravelStylePreferencePage extends StatefulWidget {
  const TravelStylePreferencePage({super.key});

  @override
  State<TravelStylePreferencePage> createState() =>
      _TravelStylePreferencePageState();
}

class _TravelStylePreferencePageState extends State<TravelStylePreferencePage> {
  final List<Map<String, dynamic>> travelStyles = [
    // {'label': '任意皆可', 'icon': Icons.all_inclusive},
    {'label': '文化體驗', 'icon': Icons.account_balance},
    {'label': '自然景觀', 'icon': Icons.terrain},
    {'label': '美食探索', 'icon': Icons.restaurant},
    {'label': '小眾秘境', 'icon': Icons.map},
    {'label': '夜生活', 'icon': Icons.nightlife},
    {'label': '運動戶外', 'icon': Icons.directions_bike},
    {'label': '購物逛街', 'icon': Icons.shopping_bag},
    {'label': '文青藝文', 'icon': Icons.palette},
    {'label': '親子同樂', 'icon': Icons.family_restroom},
    {'label': '慢活療癒', 'icon': Icons.spa},
  ];

  final Set<String> selected = {};

  bool get isValid => selected.isNotEmpty;
  bool get isMaxSelected => selected.length >= 3;

  void toggleSelection(String label) {
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
              // 導向下一頁
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LocationTypeSelectionPage(),
                ),
              );
            },
            child: const Text('Skip', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '依照我的喜好推薦行程（ 1~3 項）',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: travelStyles.map((item) {
                  final label = item['label'] as String;
                  final isSelected = selected.contains(label);
                  final disabled = !isSelected && isMaxSelected;

                  return GestureDetector(
                    onTap: () => toggleSelection(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getCardGradientColors()[1]
                            : (disabled
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? getCardGradientColors()[2]
                              : Colors.white70,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: disabled ? 0.4 : 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              size: 32,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
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
                            ),
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
                          UserModel? user = Provider.of<AuthModel>(
                            context,
                            listen: false,
                          ).userModel;
                          if (user != null) {
                            user.preferences?.travelStyles = selected;
                            user.updateTravelStyle(context, selected.toList());
                          } else {
                            print('Error: UserModel is null');
                          }

                          setSelectedListByName(
                            'selectedTravelStyles',
                            selected.toList(),
                          );

                          // 導向下一頁
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LocationTypeSelectionPage(),
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
