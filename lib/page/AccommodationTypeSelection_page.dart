import 'package:flutter/material.dart';
import 'all_page.dart';
import './../preference_data.dart';

class AccommodationTypeSelectionPage extends StatefulWidget {
  const AccommodationTypeSelectionPage({super.key});

  @override
  State<AccommodationTypeSelectionPage> createState() =>
      _AccommodationTypeSelectionPageState();
}

class _AccommodationTypeSelectionPageState
    extends State<AccommodationTypeSelectionPage> {
  final List<Map<String, dynamic>> accommodationTypes = [
    {'label': '青年旅館', 'icon': Icons.bed},
    {'label': '民宿', 'icon': Icons.home},
    {'label': '星級飯店', 'icon': Icons.hotel},
    {'label': '豪華渡假村', 'icon': Icons.villa},
    {'label': '露營／野營', 'icon': Icons.park},
    {'label': '公寓／套房', 'icon': Icons.apartment},
    {'label': '任意皆可', 'icon': Icons.shuffle},
  ];

  final Set<String> selected = {};

  bool get isValid => selected.isNotEmpty;
  bool get isMaxSelected => selected.length >= 3;

  void _toggleSelection(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else if (label == '任意皆可') {
        // 任意皆可清除所有其他選項，單獨選它
        selected
          ..clear()
          ..add(label);
      } else {
        if (selected.contains('任意皆可')) {
          selected.remove('任意皆可');
        }
        if (selected.length < 3) {
          selected.add(label);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('最多只能選擇 3 項喔！'),
              duration: Duration(seconds: 1),
            ),
          );
        }
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
                MaterialPageRoute(builder: (_) => const AvoidTypeSelectionPage()),
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
                '哪種住宿風格最適合你？（最多 3 項）',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: accommodationTypes.map((item) {
                  final label = item['label'] as String;
                  final isSelected = selected.contains(label);
                  final isDisabled = !isSelected &&
                      selected.length >= 3 &&
                      !selected.contains('任意皆可') &&
                      label != '任意皆可';

                  return GestureDetector(
                    onTap: () => !isDisabled ? _toggleSelection(label) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getCardGradientColors()[1]
                            : isDisabled
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? getCardGradientColors()[2]
                              : Colors.white70,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: isDisabled ? 0.4 : 1.0,
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
                    // 特別邏輯：任意皆可轉換成 6 項全選
                    List<String> finalList = selected.contains('任意皆可')
                        ? [
                      '青年旅館',
                      '民宿',
                      '星級飯店',
                      '豪華渡假村',
                      '露營／野營',
                      '公寓／套房',
                    ]
                        : selected.toList();

                    setSelectedListByName(
                        'selectedAccommodationTypes', finalList);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                          const AvoidTypeSelectionPage()),
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
