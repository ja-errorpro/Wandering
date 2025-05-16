import 'package:flutter/material.dart';
import 'dart:ui';
import 'all_page.dart';

class MainCategoryPage extends StatefulWidget {
  const MainCategoryPage({super.key});

  @override
  State<MainCategoryPage> createState() => _MainCategoryPageState();
}

class _MainCategoryPageState extends State<MainCategoryPage> {
  final Map<String, List<String>> categories = {
    '旅遊風格': ['任意皆可', '文化體驗', '自然景觀', '美食探索', '小眾秘境','夜生活','運動戶外', '購物逛街', '文青藝文','親子同樂', '慢活療癒'],
    '景點類型': ['任意皆可', '博物館', '地標建築', '市場/夜市', '老街', '公園／廣場', '咖啡廳', '藝文空間', '廟宇／宗教地', '夜景觀景點', '步道/自然', '海邊／湖畔'],
    '住宿類型': ['任意皆可', '青年旅館', '民宿', '星級飯店', '豪華渡假村', '露營/野營', '公寓/套房'],
  };

  final Map<String, Set<String>> selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('探索分類'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: categories.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value.map((tag) => ChoiceChip(
                      label: Text(tag),
                      selected: selectedTags[entry.key]?.contains(tag) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          selectedTags.putIfAbsent(entry.key, () => <String>{});
                          if (selected) {
                            selectedTags[entry.key]!.add(tag);
                          } else {
                            selectedTags[entry.key]!.remove(tag);
                          }
                        });
                      },
                      selectedColor: getCardGradientColors()[2],
                      backgroundColor: getCardGradientColors()[2].withOpacity(0.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              )).toList(),
            ),
          ),
          Padding(

            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubCategoryPage(
                      categoryTitle: '已選擇',
                      subcategorySelections: selectedTags,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: getCardGradientColors(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(minWidth: 88, minHeight: 36),
                  child: const Text('查看推薦內容', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void setLoveItem(String item) {
  // 實作收藏邏輯，可替換為後端或本地儲存
  debugPrint('收藏：\$item');
}

class SubCategoryPage extends StatelessWidget {
  final String categoryTitle;
  final Map<String, Set<String>> subcategorySelections;

  const SubCategoryPage({
    super.key,
    required this.categoryTitle,
    required this.subcategorySelections,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSingleCategory = subcategorySelections.length == 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$categoryTitle 推薦內容'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: subcategorySelections.entries.map((entry) {
                final List<String> tags = entry.value.toList();
                tags.shuffle();
                final randomTags = tags.take(3).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    isSingleCategory
                        ? SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: randomTags.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          return _buildRecommendationCard(randomTags[index]);
                        },
                      ),
                    )
                        : Column(
                      children: randomTags.map((tag) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildRecommendationCard(tag),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: getCardGradientColors(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExplorePage()),
                  );
                },
                icon: const Icon(Icons.explore),
                label: const Text('返回探索頁'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ).copyWith(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String tag) {
    final mockData = {
     '文化體驗': ['華山1914文創園區', '活動豐富，有市集與展覽。', 'huashan.jpg'],
     '自然景觀': ['陽明山國家公園', '春天賞花、秋天賞楓，台北最美自然景觀。', 'yangmingshan.jpg'],
     '美食探索': ['寧夏夜市', '充滿台灣道地小吃，越夜越熱鬧。', 'Ningxia Night Market.jpg'],
     '小眾秘境': ['貓空', '搭乘纜車欣賞茶園風光與台北市景。', 'Maokong.jpg'],
     '夜生活': ['西門町', '熱鬧的街頭表演與深夜美食天堂。', 'ximending.jpg'],
     '購物逛街': ['三創數位生活園區', '匯集3C、動漫、影音等多元產品。', 'Syntrend_Creative_Park.jpg'],
     '文青藝文': ['松山文創園區', '充滿設計感的小店與不定期展覽。', 'Songshan_Cultural_and_Creative_Park.jpg'],
     '親子同樂': ['台北市立動物園', '適合全家大小一同遊玩，觀賞各種動物。', 'taipei_zoo.png'],
     '慢活療癒': ['青田街', '充滿日式氛圍的靜謐巷弄，適合散步。', 'Qingtian_Street.jpg'],
     '博物館': ['故宮博物院', '典藏豐富中華文化藝術精髓。', 'The_Palace_Museum.jpg'],
     '地標建築': ['台北101', '可俯瞰台北市景的壯觀地標。', 'Taipei_101_blue_hour_2016.jpg'],
     '市場/夜市': ['士林夜市', '台北最具代表性的夜市之一，美食種類豐富。', 'Shilin_Night_Market.jpg'],
     '老街': ['九份老街', '充滿懷舊氛圍的山城老街，可體驗礦業文化。', 'Jioufen_Shuchi_Street.jpg'],
     '公園／廣場': ['大安森林公園', '台北市中心的綠意盎然，適合野餐與休憩。', 'Daan_Park.jpg'],
     '咖啡廳': ['好樣VVG', '充滿風格的特色咖啡廳，提供精緻餐點。', 'vgg.jpg'],
     '藝文空間': ['華山Legacy', '舉辦演唱會、藝文表演的場地。', 'Legacy.jpg'],
     '廟宇／宗教地': ['龍山寺', '香火鼎盛的傳統寺廟，建築精美。', 'Mengjia_Longshan_Temple.jpg'],
     '夜景觀景點': ['象山', '可輕鬆登頂欣賞台北101夜景。', 'Kowloon_Peak_in_2020.jpg'],
     '步道/自然': ['劍潭山親山步道', '輕鬆好走的步道，可欣賞基隆河與市景。', 'trial.jpg'],
     '海邊／湖畔': ['大稻埕碼頭', '適合傍晚散步與看夕陽。', 'dadaocheng.jpg'],
     '青年旅館': ['你好台北青年旅館', '簡約舒適，提供背包客經濟實惠的住宿選擇。', 'Hostel.jpg'],
     '民宿': ['悠然小居', '舒適溫馨的設計，近捷運站交通方便。', 'Leisurely Secret Cabin.jpg'],
     '星級飯店': ['台北圓山大飯店', '時尚設計，位於台北核心地段。', 'Grand Hotel.jpg'],
     '豪華渡假村': ['北投麗禧溫泉酒店', '享受頂級溫泉體驗與精緻服務。', 'Grand View Hot Spring Resort Beitou.jpg'],
     '露營/野營': ['陽明山冷水坑露營區', '親近自然的露營體驗。', 'tent.jpg'],
     '公寓/套房': ['Home Hotel Da-An', '提供舒適且有設計感的公寓式住宿。', 'Home Hotel Da-An.jpg'],
    };
    final entry = mockData[tag] ?? ['推薦地點', '這是預設描述文字。', 'default.jpg'];
    final title = entry[0];
    final desc = entry[1];
    final img = entry[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/recommends/$img',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(desc, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                    onPressed: () {
                      setLoveItem(tag);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.blueAccent),
                    onPressed: () {
                      // TODO: implement share logic (e.g., Share.share(tag));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
