import 'package:Wandering/main.dart';
import 'package:flutter/material.dart';
import 'all_page.dart'; // 匯入 導入下一個頁面
import 'package:Wandering/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Wandering/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 控制各分類是否展開
  bool _isAccountExpanded = false;
  bool _isPreferenceExpanded = false;
  bool _isAppearanceExpanded = false;
  bool _isNotificationExpanded = false;
  bool _isSupportExpanded = false;

  bool _gpsEnabled = true;
  bool _systemNotificationEnabled = true;
  bool _trip_expiration_reminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff), // 淺藍綠背景
      appBar: AppBar(
        title: Text('設定', style: TextStyle(fontSize: GetFontSize())),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExpansionTile(
            title: '帳號與登入管理',
            isExpanded: _isAccountExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isAccountExpanded = expanded),
            children: [
              ListTile(
                title: Text('登出', style: TextStyle(fontSize: GetFontSize())),
                onTap: () {
                  // 執行登出操作
                  Provider.of<AuthModel>(context, listen: false).logout();
                  // 退出所有頁面後跳到主頁
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'Wandering App Home'),
                    ),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                title: Text('刪除帳號', style: TextStyle(fontSize: GetFontSize(), color: Colors.red)),
                onTap: () {
                  // 執行刪除帳號操作
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('確認刪除', style: TextStyle(fontSize: GetFontSize())),
                      content: Text('您確定要刪除帳號嗎？此操作無法撤銷。', style: TextStyle(fontSize: GetFontSize())),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('取消', style: TextStyle(fontSize: GetFontSize())),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: 執行刪除帳號邏輯
                            Navigator.of(context).pop();
                          },
                          child: Text('確認', style: TextStyle(fontSize: GetFontSize(), color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          _buildExpansionTile(
            title: '外觀與操作',
            isExpanded: _isAppearanceExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isAppearanceExpanded = expanded),
            children: [
              ListTile(
                title: Text('主題模式', style: TextStyle(fontSize: GetFontSize())),
                onTap: () {
                  // 顯示主題選擇對話框
                  _showThemeDialog();
                },
              ),
              ListTile(
                title: Text('語言', style: TextStyle(fontSize: GetFontSize())),
                onTap: () {
                  // 顯示語言選擇對話框
                  _showLanguageDialog();
                },
              ),
              ListTile(
                title: Text('字體大小', style: TextStyle(fontSize: GetFontSize())),
                subtitle: StatefulBuilder(
                  builder: (context, setLocalState) {
                    double sliderValue = GetFontSize(); // 初始值
                    return Slider(
                      value: sliderValue,
                      min: 10.0,
                      max: 22.0,
                      divisions: 6,
                      label: sliderValue.toStringAsFixed(0),
                      activeColor: getCardGradientColors()[2], // 設定拉桿顏色
                      inactiveColor: getCardGradientColors()[0], // 設定未選中顏色
                      onChanged: (value) {
                        setLocalState(() {
                          sliderValue = value;
                        });
                        SetFontSize(value);
                        setState(() {}); // 刷新父級畫面（設定區域、文字樣式會即時變）
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: Text('導航模式切換', style: TextStyle(fontSize: GetFontSize())),
                trailing: Switch(
                  value: _gpsEnabled,
                  activeColor: getCardGradientColors()[2],
                  onChanged: (bool value) {
                    setState(() {
                      _gpsEnabled = value;
                      // 這裡可以加入儲存設定或觸發推播相關邏輯
                    });
                  },
                ),
              ),

            ],
          ),
          _buildExpansionTile(
            title: '通知與提醒',
            isExpanded: _isNotificationExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isNotificationExpanded = expanded),
            children: [
              ListTile(
                title: Text('系統推播開關', style: TextStyle(fontSize: GetFontSize())),
                trailing: Switch(
                  value: _systemNotificationEnabled,
                  activeColor: getCardGradientColors()[2],
                  onChanged: (bool value) {
                    setState(() {
                      _systemNotificationEnabled = value;
                      // 這裡可以加入儲存設定或觸發推播相關邏輯
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('行程到期提醒', style: TextStyle(fontSize: GetFontSize())),
                trailing: Switch(
                  value: _trip_expiration_reminder,
                  activeColor: getCardGradientColors()[2],
                  onChanged: (bool value) {
                    setState(() {
                      _trip_expiration_reminder = value;
                      // 這裡可以加入儲存設定或觸發推播相關邏輯
                    });
                  },
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: '關於與支援',
            isExpanded: _isSupportExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isSupportExpanded = expanded),
            children: [
              ListTile(
                title: Text('App版本資訊', style: TextStyle(fontSize: GetFontSize())),
                trailing: Text(
                  'v1.0.0',
                  style: TextStyle(fontSize: GetFontSize() - 4, color: Colors.grey),
                ),
              ),
              ListTile(
                title: Text('聯絡我們', style: TextStyle(fontSize: GetFontSize())),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ContactPage()),
                  );
                },
              ),
              ListTile(title: Text('法律條款', style: TextStyle(fontSize: GetFontSize()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required bool isExpanded,
    required void Function(bool) onExpansionChanged,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4), // 模擬玻璃擬態
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: GetFontSize())),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        onExpansionChanged: onExpansionChanged,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16),
        children: children,
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentTheme = GetTheme();
        return AlertDialog(
          title: Text('選擇主題', style: TextStyle(fontSize: GetFontSize())),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['grand blue', 'uncolored','fall' , 'the forest', 'bubble candy', 'Lavender', 'sunrise', 'rainbow']
                .map((theme) => RadioListTile<String>(
              title: Text(theme, style: TextStyle(fontSize: GetFontSize())),
              value: theme,
              groupValue: currentTheme,
              onChanged: (value) async {
                if (value != null) {
                  // 顯示 loading 對話框
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("正在為你套用新設定⋯⋯"),
                        ],
                      ),
                    ),
                  );

                  await Future.delayed(Duration(milliseconds: 800));

                  // 儲存主題設定
                  SetTheme(value);

                  // 關閉 loading 對話框
                  Navigator.of(context).pop();

                  // 跳轉回 ExplorePage 並刷新
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ExplorePage()),
                  );
                }
              },
            ))
                .toList(),
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentLanguage = GetLanguage();
        return AlertDialog(
          title: Text('選擇主題', style: TextStyle(fontSize: GetFontSize())),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['zh-tw', 'zh-cn']
                .map((Language) => RadioListTile<String>(
              title: Text(Language, style: TextStyle(fontSize: GetFontSize())),
              value: Language,
              groupValue: currentLanguage,
              onChanged: (value) async {
                if (value != null) {
                  // 顯示 loading 對話框
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("正在為你套用新設定⋯⋯"),
                        ],
                      ),
                    ),
                  );

                  await Future.delayed(Duration(milliseconds: 800));

                  // 儲存語言設定
                  setLanguage(value);

                  // 關閉 loading 對話框
                  Navigator.of(context).pop();

                  // 跳轉回 ExplorePage 並刷新
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ExplorePage()),
                  );
                }
              },
            ))
                .toList(),
          ),
        );
      },
    );
  }
}
