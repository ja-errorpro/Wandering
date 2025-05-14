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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff), // 淺藍綠背景
      appBar: AppBar(
        title: const Text('設定'),
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
                title: Text('登出'),
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
                title: Text('刪除帳號'),
                onTap: () {
                  // 執行刪除帳號操作
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('確認刪除'),
                      content: Text('您確定要刪除帳號嗎？此操作無法撤銷。'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: 執行刪除帳號邏輯
                            Navigator.of(context).pop();
                          },
                          child: Text('確認'),
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
                title: Text('主題模式'),
                onTap: () {
                  // 顯示主題選擇對話框
                  _showThemeDialog();
                },
              ),
              ListTile(
                title: Text('字體大小'),
                subtitle: StatefulBuilder(
                  builder: (context, setLocalState) {
                    double sliderValue = GetFontSize().toDouble();
                    return Slider(
                      value: sliderValue,
                      min: 10.0,
                      max: 24.0,
                      divisions: 7,
                      label: sliderValue.toStringAsFixed(0),
                      onChanged: (value) {
                        setLocalState(() {}); // 更新 Slider 本地 UI
                        SetFontSize(value.toInt());
                        setState(() {}); // 若 ExplorePage 也需要重繪
                      },
                    );
                  },
                ),
              ),

              ListTile(title: Text('導航模式切換')),
            ],
          ),
          _buildExpansionTile(
            title: '通知與提醒',
            isExpanded: _isNotificationExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isNotificationExpanded = expanded),
            children: const [
              ListTile(title: Text('系統推播開關')),
              ListTile(title: Text('行程到期提醒')),
            ],
          ),
          _buildExpansionTile(
            title: '關於與支援',
            isExpanded: _isSupportExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _isSupportExpanded = expanded),
            children: const [
              ListTile(title: Text('App版本資訊')),
              ListTile(title: Text('聯絡我們')),
              ListTile(title: Text('法律條款')),
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
          title: Text('選擇主題'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['default', 'sunset', 'forest', 'pastel']
                .map((theme) => RadioListTile<String>(
              title: Text(theme),
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


}



/*


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 用於控制 ExpansionPanel 的展開狀態
  List<bool> _isExpanded = [false, false, false, false, false]; // 對應五個主要設定項

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // 確保頁面內容可以滾動
        child: ExpansionPanelList(
          elevation: 1, // 設定陰影
          expandedHeaderPadding: EdgeInsets.zero, // 設定展開時 Header 的內邊距
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              // Collapse all panels except the one that was tapped
              for (int i = 0; i < _isExpanded.length; i++) {
                if (i == index) {
                  _isExpanded[i] = !isExpanded;
                } else {
                  _isExpanded[i] = false;
                }
              }
            });
          },
          children: [
            // 帳號與登入管理
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text('帳號與登入管理'),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: Column(
                children: [
                  ListTile(
                    title: const Text('登入'),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('登出'),
                    onTap: () {
                      Provider.of<AuthModel>(context, listen: false).logout();
                    },
                  ),
                  ListTile(
                    title: const Text('刪除帳號'),
                    onTap: () {
                      // TODO: 執行刪除帳號操作
                    },
                  ),
                ],
              ),
              isExpanded: _isExpanded[0],
              canTapOnHeader: true, // 允許點擊 Header 觸發回調
            ),

            // 偏好與語言
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text('偏好與語言'),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: const SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: _isExpanded[1],
              canTapOnHeader: true, // 允許點擊 Header 觸發回調
            ),

            // 外觀與操作
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text('外觀與操作'),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: const SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: _isExpanded[2],
              canTapOnHeader: true, // 允許點擊 Header 觸發回調
            ),

            // 通知與提醒
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text('通知與提醒'),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: const SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: _isExpanded[3],
              canTapOnHeader: true, // 允許點擊 Header 觸發回調
            ),

            // 關於與支援
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text('關於與支援'),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: const SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: _isExpanded[4],
              canTapOnHeader: true, // 允許點擊 Header 觸發回調
            ),
          ],
        ),
      ),
    );
  }
}


 */