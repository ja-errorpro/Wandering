import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:table_calendar/table_calendar.dart';
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
    // 為了避免重複推送相同的頁面，可以在導航前檢查當前路由
    // 或者使用 pushReplacement 代替 push
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExplorePage()),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainCategoryPage()),
      );
    }
    else if (index == 2) {
      // 如果已經在 StartTravelPage，則不進行導航
      // 或者使用 pushReplacement 來確保 BottomNavigationBar 狀態正確
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => StartTravelPage()),
      // );
      // 如果使用 pushReplacement 則會重新載入頁面，通常如果已在當前頁面則不導航
    }
    else if (index == 4) { // index 4 是 ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'assets/images/wandering_6.PNG',
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
                    isDateField: false,
                  ),
                  const SizedBox(height: 16),
                  _tappableInputField(
                    context,
                    label: selectedTags.isEmpty ? '選擇你想玩的景點或類型' : selectedTags.join('、'),
                    onTap: () => _selectTags(context),
                    isDateField: false,
                  ),
                  const SizedBox(height: 16),
                  _tappableInputField(
                    context,
                    label: selectedDateRange == null
                        ? '輸入預定的時間'
                        : '${selectedDateRange!.start.year}/${selectedDateRange!.start.month}/${selectedDateRange!.start.day} - ${selectedDateRange!.end.year}/${selectedDateRange!.end.month}/${selectedDateRange!.end.day}',
                    onTap: () => _selectDateRange(context),
                    isDateField: true, // 這是日期欄位，應用漸層色
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
                gradient: LinearGradient(
                  colors: getCardGradientColors(), // 使用定義好的漸層顏色
                ),
              ),
              child: TextButton.icon(
                onPressed: () {
                  if (selectedRegion == null || selectedRegion!.isEmpty ||
                      selectedTags.isEmpty ||
                      selectedDateRange == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('請完成所有欄位'),
                        content: const Text('請選擇地區、類型和日期範圍後再搜尋。'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('確定'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  // TODO: Execute search with selected values
                  print('Selected Region: $selectedRegion');
                  print('Selected Tags: $selectedTags');
                  print('Selected Date Range: $selectedDateRange');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GeneratedLoadingPage()),
                  );
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('一鍵', style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 4),
                    Icon(Icons.airplanemode_active, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text('搜尋', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
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

  // 修改 _tappableInputField 以明確傳遞 isDateField 參數
  Widget _tappableInputField(BuildContext context, {required String label, required VoidCallback onTap, required bool isDateField}) {
    //bool isDateField = label.contains('/'); // 不再依賴 label 內容判斷
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // gradient: isDateField // 如果是日期欄位，應用漸層
          //     ? LinearGradient(
          //   colors: getCardGradientColors(), // 使用定義好的漸層顏色
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // )
          //     : null,
          color: Colors.white, // 背景色為白色
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black54, // 欄位文字黑色
            fontSize: 14,
            fontWeight: FontWeight.normal, // 日期欄位文字加粗
          ),
          overflow: TextOverflow.ellipsis, // 防止文字過長溢出
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
          '台北市', '新北市', '基隆市', '桃園市', '新竹市', '新竹縣', '苗栗縣',
          '台中市', '彰化縣', '南投縣', '雲林縣', '嘉義市', '嘉義縣',
          '台南市', '高雄市', '屏東縣', '宜蘭縣', '花蓮縣', '台東縣',
          '澎湖縣', '金門縣', '連江縣'
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
      '旅遊風格': ['文化體驗', '自然景觀', '美食探索', '小眾秘境', '夜生活', '運動戶外', '購物逛街', '文青藝文', '親子同樂', '慢活療癒'],
      '景點類型': ['博物館', '地標建築', '市場/夜市', '老街', '公園／廣場', '咖啡廳', '藝文空間', '廟宇／宗教地', '夜景觀景點', '步道/自然', '海邊／湖畔'],
      '住宿類型': ['青年旅館', '民宿', '星級飯店', '豪華渡假村', '露營/野營', '公寓/套房', '任意皆可'],
      '避免的地點': ['無', '人多的地方', '高消費景點', '行程太緊湊', '冒險刺激活動', '潮濕悶熱氣候', '高溫炎熱地點', '吵雜環境', '不乾淨的空間', '害怕動物']
      // 您可以在這裡添加更多分類和標籤
    };
    // 使用一個本地變數來追蹤選取的標籤，只在確認時更新外部的 selectedTags
    final selected = <String>[];
    // 初始化時如果已有選取的標籤，則加入到 local selected 中
    selected.addAll(selectedTags);


    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 確保底部彈窗可以拉伸，以便 ConstraintBox 生效
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          // === 加入 ConstrainedBox 來設定最大高度 ===
          return ConstrainedBox(
            constraints: BoxConstraints(
              // 設定最大高度為螢幕高度的 80%
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            // 將 SingleChildScrollView 包裹在 ConstrainedBox 裡面
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // 鍵盤彈起時自動調整高度
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Column 維持最小尺寸
                  crossAxisAlignment: CrossAxisAlignment.start, // 左對齊內容
                  children: [
                    const Center( // 標題居中
                      child: Text(
                        '選擇類型（每類必選一個）',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16), // 增加間距

                    // 遍歷每個類別及其標籤
                    ...tagMap.entries.map((entry) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 類別名稱左對齊
                      children: [
                        Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8), // 類別名稱與標籤間距
                        Wrap(
                          spacing: 8, // 標籤之間的水平間距
                          runSpacing: 8, // 標籤之間的垂直間距
                          children: entry.value.map((tag) {
                            final isSelected = selected.contains(tag);
                            return ChoiceChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (_) {
                                setModalState(() {
                                  // 移除同一類別中已經選取的標籤
                                  entry.value.forEach((otherTag) {
                                    if (selected.contains(otherTag)) {
                                      selected.remove(otherTag);
                                    }
                                  });
                                  // 加入當前選取的標籤
                                  selected.add(tag);
                                });
                              },
                              // 自訂選取和未選取時的顏色
                              selectedColor: getCardGradientColors().first.withOpacity(0.8), // 選取時的背景色 (假設 getCardGradientColors() 存在並返回 List<Color>)
                              backgroundColor: Colors.grey[200], // 未選取時的背景色
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87, // 選取時文字白色，未選取時黑色
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder( // 自訂邊框形狀
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: getCardGradientColors().first, // 漸層的第一個顏色作為選取時的邊框色
                                  width: 1,
                                ),
                              ),
                              elevation: isSelected ? 4 : 1, // 選取時增加陰影
                              pressElevation: 2, // 按下時的陰影
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16), // 每類標籤組之間的間距
                      ],
                    )).toList(),

                    // 確認按鈕
                    Center( // 確認按鈕居中
                      child: ElevatedButton(
                        // 檢查每個類別是否都有選到至少一個標籤
                        onPressed: tagMap.keys.every((category) {
                          final tagsInCategory = tagMap[category]!;
                          return tagsInCategory.any((tag) => selected.contains(tag));
                        })
                            ? () {
                          // 過濾掉所有類別的 "任意風格", "都可以" 標籤，只保留具體的選取
                          // 這裡保留了您原來的邏輯，處理「任意風格」或「都可以」的情況
                          final resultTags = selected.where((tag) => !['任意風格', '都可以'].contains(tag)).toList();
                          setState(() => selectedTags = resultTags.isEmpty && selected.isNotEmpty ? selected : resultTags);
                          Navigator.pop(context);
                        }
                            : null, // 如果有類別沒有選取，按鈕禁用
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getCardGradientColors().first, // 按鈕背景色使用主題色
                          foregroundColor: Colors.white, // 按鈕文字顏色
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('確認選擇'),
                      ),
                    ),
                    const SizedBox(height: 8), // 按鈕下方間距
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 讓 DraggableScrollableSheet 自己的圓角可見
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, // 初始高度佔螢幕的比例
        minChildSize: 0.5, // 最小高度
        maxChildSize: 0.9, // 最大高度
        expand: false,
        builder: (context, scrollController) => CustomDateRangePicker(
          // 將漸層顏色傳遞給 CustomDateRangePicker
          themeColors: getCardGradientColors(),
          onConfirm: (start, end) {
            setState(() {
              selectedDateRange = DateTimeRange(start: start, end: end);
            });
            // 在 CustomDateRangePicker 內部已經 pop 了，這裡不需要再 pop
          },
          // 如果想傳入當前已選擇的日期範圍以使 Picker 初始化顯示
          initialRange: selectedDateRange,
        ),
      ),
    );
  }
}


class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTime start, DateTime end) onConfirm;
  final List<Color> themeColors; // 接收主題顏色列表
  final DateTimeRange? initialRange; // 接收初始選定的日期範圍
  final ScrollController? scrollController;

  const CustomDateRangePicker({
    super.key,
    required this.onConfirm,
    required this.themeColors,
    this.initialRange,
    this.scrollController,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();
  late final DateTime _normalizedToday;

  @override
  void initState() {
    super.initState();
    _normalizedToday = DateTime(_today.year, _today.month, _today.day);

    if (widget.initialRange != null) {
      _rangeStart = widget.initialRange!.start;
      _rangeEnd = widget.initialRange!.end;
      _focusedDay = widget.initialRange!.start;
      if (_rangeStart!.isBefore(_normalizedToday)) {
        _focusedDay = _normalizedToday;
      }
    } else {
      _focusedDay = _normalizedToday;
    }
  }

  // 檢查給定日期是否在今天或之後
  bool _isSelectable(DateTime day) {
    // 將要檢查的日期也規範化，移除時間部分
    final normalizedDay = DateTime(day.year, day.month, day.day);
    // 如果規範化後的日期在規範化後的今天或之後，則返回 true
    return !normalizedDay.isBefore(_normalizedToday);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.themeColors.isNotEmpty ? widget.themeColors.first : Colors.blue;
    final Color rangeFillColor = widget.themeColors.isNotEmpty ? widget.themeColors.first.withOpacity(0.2) : Colors.blue.withOpacity(0.2);
    final LinearGradient rangeMarkerGradient = LinearGradient(
      colors: widget.themeColors.isNotEmpty ? widget.themeColors : [Colors.blue, Colors.lightBlueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.only(bottom: 16),
          ),
          const Text(
            '選擇日期範圍 (今天或之後)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              // --- 修改點 3: 將接收到的 scrollController 賦值給 SingleChildScrollView ---
              // controller: widget.scrollController,
              child: TableCalendar(
                firstDay: _normalizedToday, // 將最早可顯示日期設定為今天
                lastDay: DateTime.utc(_today.year + 5, 12, 31), // 5 年後
                focusedDay: _focusedDay,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                onRangeSelected: (start, end, focusedDay) {
                  if (start != null && _isSelectable(start)) {
                    setState(() {
                      _rangeStart = start;
                      _rangeEnd = end;
                      _focusedDay = focusedDay;
                    });
                  } else if (start == null && end == null) {
                    setState(() {
                      _rangeStart = null;
                      _rangeEnd = null;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                selectedDayPredicate: (day) => false, // rangeSelectionMode 優先
                enabledDayPredicate: _isSelectable, // 不可選取當天之前的日期

                // --- 日曆樣式自訂 ---
                calendarStyle: CalendarStyle(
                  disabledTextStyle: TextStyle(color: Colors.grey[400], decoration: TextDecoration.lineThrough),
                  disabledDecoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),

                  isTodayHighlighted: true,
                  rangeHighlightColor: rangeFillColor,
                  rangeStartDecoration: BoxDecoration( gradient: rangeMarkerGradient, shape: BoxShape.circle, ),
                  rangeStartTextStyle: const TextStyle(color: Colors.white),
                  rangeEndDecoration: BoxDecoration( gradient: rangeMarkerGradient, shape: BoxShape.circle, ),
                  rangeEndTextStyle: const TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration( gradient: rangeMarkerGradient, shape: BoxShape.circle, ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration( color: primaryColor.withOpacity(0.4), shape: BoxShape.circle, ),
                  todayTextStyle: const TextStyle(color: Colors.black87),
                  defaultDecoration: const BoxDecoration( shape: BoxShape.circle, color: Colors.transparent, ),
                  defaultTextStyle: const TextStyle(color: Colors.black87),
                  weekendDecoration: const BoxDecoration( shape: BoxShape.circle, color: Colors.transparent, ),
                  weekendTextStyle: const TextStyle(color: Colors.redAccent),
                  outsideDaysVisible: false,
                  // rangeTextStyle: const TextStyle(color: Colors.black87),
                  outsideTextStyle: const TextStyle(color: Colors.grey),
                ),

                // --- 日曆標頭樣式自訂 ---
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                  // leftIcon: Icon(Icons.chevron_left, color: Colors.black54),
                  // rightIcon: Icon(Icons.chevron_right, color: Colors.black54),
                ),

                // --- 星期標籤樣式自訂 ---
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black54),
                  weekendStyle: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            // 只有當開始日期和結束日期都已選擇，且開始日期不晚於結束日期時，按鈕才可用
            onPressed: _rangeStart != null && _rangeEnd != null && !_rangeStart!.isAfter(_rangeEnd!)
                ? () {
              widget.onConfirm(_rangeStart!, _rangeEnd!);
              Navigator.pop(context);
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              disabledBackgroundColor: (primaryColor).withOpacity(0.3),
              disabledForegroundColor: Colors.white.withOpacity(0.6),
            ),
            child: const Text('確認選擇'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}