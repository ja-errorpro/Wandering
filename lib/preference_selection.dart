import 'package:flutter/material.dart';

class InitalPreference extends StatefulWidget {
  const InitalPreference({super.key});

  @override
  State<InitalPreference> createState() => _InitalPreferenceState();
}

class _InitalPreferenceState extends State<InitalPreference> {
  // 偏好類型資料 (保持不變)
  final List<String> travelStyles = [
    '文化體驗', '自然景觀', '美食探索', '小眾秘境', '夜生活', '都市漫遊'
  ];
  final List<String> locationTypes = [
    '博物館', '市場', '步道', '咖啡廳', '書店', '藝文空間', '老街'
  ];
  final List<String> avoidTypes = [
    '人多的地方', '高消費景點', '過度商業化', '吵雜空間', '長時間排隊'
  ];
  final List<String> accommodationTypes = [
    '青年旅館', '平價旅館', '設計旅店', '高級飯店', '民宿', '自然露營地', '療癒系住宿'
  ];

  // 狀態變數來儲存選取的偏好
  Set<String> selectedTravelStyles = {};
  Set<String> selectedLocationTypes = {};
  Set<String> selectedAvoids = {};
  Set<String> selectedAccommodations = {};

  // TODO: Add methods to update the selected sets based on user interaction (e.g., tapping on preference chips or checkboxes)

  // 驗證所有必要類別是否都有選擇
  bool _validateSelections() {
    return selectedTravelStyles.isNotEmpty &&
        selectedLocationTypes.isNotEmpty &&
        selectedAccommodations.isNotEmpty &&
        selectedAvoids.isNotEmpty;
  }

  // 顯示警告對話框
  void _showIncompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('請完成選擇'),
          content: const Text('請從每個類別中至少選擇一個偏好項目。'),
          actions: <Widget>[
            TextButton(
              child: const Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇你的旅遊偏好'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: Add UI elements (e.g., Checkboxes, Chip widgets) for each preference category
            //       Make sure to update the corresponding state variables (selectedTravelStyles, etc.) when a preference is selected or deselected.

            const Spacer(), // Pushes the button to the bottom

            ElevatedButton(
              onPressed: () {
                if (_validateSelections()) {
                  // 所有分類都有選，進行下一步或儲存
                  print('旅行風格: $selectedTravelStyles');
                  print('偏好地點: $selectedLocationTypes');
                  print('住宿類型: $selectedAccommodations');
                  print('避免類型: $selectedAvoids');
                  // TODO: Add navigation to the next screen or save logic here
                } else {
                  _showIncompleteDialog(); // 顯示警告
                }
              },
              child: const Text('完成選擇'),
            ),
          ],
        ),
      ),
    );
  }
}
//  extends StatelessWidget {
//   const InitalPreference({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 偏好類型資料
//     final List<String> travelStyles = [
//       '文化體驗', '自然景觀', '美食探索', '小眾秘境', '夜生活', '都市漫遊'
//     ];
//     final List<String> locationTypes = [
//       '博物館', '市場', '步道', '咖啡廳', '書店', '藝文空間', '老街'
//     ];
//     final List<String> avoidTypes = [
//       '人多的地方', '高消費景點', '過度商業化', '吵雜空間', '長時間排隊'
//     ];
//     final List<String> accommodationTypes = [
//       '青年旅館', '平價旅館', '設計旅店', '高級飯店', '民宿', '自然露營地', '療癒系住宿'
//     ];

//     Set<String> selectedTravelStyles = {};
//     Set<String> selectedLocationTypes = {};
//     Set<String> selectedAvoids = {};
//     Set<String> selectedAccommodations = {}; // 新增住宿偏好

//     return Scaffold(
//       appBar: AppBar(title: const Text('選擇你的旅遊偏好')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildSection('旅行風格', travelStyles, selectedTravelStyles),
//           _buildSection('偏好地點', locationTypes, selectedLocationTypes),
//           _buildSection('住宿類型', accommodationTypes, selectedAccommodations), // 新增區塊
//           _buildSection('避免類型', avoidTypes, selectedAvoids),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               print('旅行風格: $selectedTravelStyles');
//               print('偏好地點: $selectedLocationTypes');
//               print('住宿類型: $selectedAccommodations');
//               print('避免類型: $selectedAvoids');
//             },
//             child: const Text('完成選擇'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<String> options, Set<String> selectedSet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: options.map((option) {
//             final isSelected = selectedSet.contains(option);
//             return FilterChip(
//               label: Text(option),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   selected
//                       ? selectedSet.add(option)
//                       : selectedSet.remove(option);
//                 });
//               },
//               selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//               checkmarkColor: Theme.of(context).colorScheme.primary,
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }


//   bool _validateSelections() {
//     return selectedTravelStyles.isNotEmpty &&
//           selectedLocationTypes.isNotEmpty &&
//           selectedAccommodations.isNotEmpty &&
//           selectedAvoids.isNotEmpty;
//   }


//   void _showIncompleteDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('尚未完成'),
//         content: const Text('請至少選擇每個分類的一項偏好。'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('知道了'),
//           ),
//         ],
//       ),
//     );
//   }
// }



