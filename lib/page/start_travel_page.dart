import 'package:flutter/material.dart';
import 'dart:ui';
import 'all_page.dart';
class StartTravelPage extends StatefulWidget {
  const StartTravelPage({super.key});

  @override
  State<StartTravelPage> createState() => _StartTravelPageState();
}

class _StartTravelPageState extends State<StartTravelPage> {
  int _selectedIndex = 2;
  String? selectedRegion;
  List<String> selectedTags = [];
  DateTimeRange? selectedDateRange;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExplorePage()),
      );
    }
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
    // else if (index == 3) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProfilePage()),
    // );
    // }
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/attractions-image.jpg',
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/wandering_5.PNG',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _tappableInputField(
                    context,
                    label: selectedRegion ?? '輸入您想去的地區',
                    onTap: () => _selectRegion(context),
                  ),
                  const SizedBox(height: 16),
                  _tappableInputField(
                    context,
                    label: selectedTags.isEmpty ? '選擇你想玩的景點或類型' : selectedTags.join('、'),
                    onTap: () => _selectTags(context),
                  ),
                  const SizedBox(height: 16),
                  _tappableInputField(
                    context,
                    label: selectedDateRange == null
                        ? '輸入預定的時間'
                        : '${selectedDateRange!.start.year}/${selectedDateRange!.start.month}/${selectedDateRange!.start.day} - ${selectedDateRange!.end.year}/${selectedDateRange!.end.month}/${selectedDateRange!.end.day}',
                    onTap: () => _selectDateRange(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: 240,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7beec5),
                    Color(0xFF01e6fa),
                    Color(0xFF32c8ff),
                    Color(0xFFc0e8cb),
                  ],
                ),
              ),
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Execute search with selected values
                },
                icon: const Icon(Icons.airplanemode_active, color: Colors.white),
                label: const Text(
                  '一鍵搜尋',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _tappableInputField(BuildContext context, {required String label, required VoidCallback onTap}) {
    bool isDateField = label.contains('/');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDateField
              ? LinearGradient(
            colors: [
              Color(0xFF7beec5),
              Color(0xFF01e6fa),
              Color(0xFF32c8ff),
              Color(0xFFc0e8cb),
            ],
          )
              : null,
          color: isDateField ? null : Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: isDateField ? Colors.white : Colors.black54,
            fontSize: 14,
            fontWeight: isDateField ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _selectRegion(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('選擇地區'),
        children: [
          '亞洲', '歐洲', '美洲', '非洲', '大洋洲'
        ].map((e) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, e),
          child: Text(e),
        )).toList(),
      ),
    );
    if (result != null) setState(() => selectedRegion = result);
  }

  Future<void> _selectTags(BuildContext context) async {
    final tagMap = {
      '旅遊風格': ['任意風格', '輕鬆自由', '深度文化', '戶外冒險'],
      '景點類型': ['都可以', '自然景觀', '博物館', '主題樂園'],
      '住宿類型': ['都可以', '青年旅館', '飯店', '民宿']
    };
    final selected = <String>[];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('選擇類型（每類必選一個）', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...tagMap.entries.map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: entry.value.map((tag) => ChoiceChip(
                        label: Text(tag),
                        selected: selected.contains(tag),
                        onSelected: (_) {
                          entry.value.forEach(selected.remove);
                          setModalState(() => selected.add(tag));
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                )),
                ElevatedButton(
                  onPressed: () {
                    if (selected.length >= 3) {
                      setState(() => selectedTags = List.from(selected));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('確認'),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => selectedDateRange = picked);
  }
}
