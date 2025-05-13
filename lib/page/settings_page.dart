import 'package:flutter/material.dart';
import 'all_page.dart'; // 匯入 導入下一個頁面


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
        title: Text('設定'),
      ),
      body: SingleChildScrollView( // 確保頁面內容可以滾動
        child: ExpansionPanelList(
          elevation: 1, // 設定陰影
          expandedHeaderPadding: EdgeInsets.all(0), // 設定展開時 Header 的內邊距
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded[index] = !isExpanded; // 切換展開狀態
            });
          },
          children: [
            // 帳號與登入管理
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('帳號與登入管理'),
                  trailing: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  ),
                );
              },
              body: Column(
                children: [
                  ListTile(
                    title: Text('登入'),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      });
                    },
                  ),
                  ListTile(
                    title: Text('登出'),
                    onTap: () {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(builder: (context) => logout()),
                      //   );
                      // });
                    },
                  ),
                  ListTile(
                    title: Text('刪除帳號'),
                    onTap: () {
                      // TODO: 執行刪除帳號操作
                    },
                  ),
                ],
              ),
              isExpanded: _isExpanded[0],
            ),

            // 偏好與語言
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('偏好與語言'),
                  trailing: Icon(Icons.keyboard_arrow_right), // 這個不會展開，所以箭頭固定
                );
              },
              body: SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: false, // 保持關閉狀態
              canTapOnHeader: true, // 允許點擊 Header 觸發回調 (如果需要處理點擊事件)
            ),

            // 外觀與操作
             ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('外觀與操作'),
                  trailing: Icon(Icons.keyboard_arrow_right), // 這個不會展開，所以箭頭固定
                );
              },
              body: SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: false, // 保持關閉狀態
              canTapOnHeader: true, // 允許點擊 Header 觸發回調 (如果需要處理點擊事件)
            ),

            // 通知與提醒
             ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('通知與提醒'),
                  trailing: Icon(Icons.keyboard_arrow_right), // 這個不會展開，所以箭頭固定
                );
              },
              body: SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: false, // 保持關閉狀態
              canTapOnHeader: true, // 允許點擊 Header 觸發回調 (如果需要處理點擊事件)
            ),

            // 關於與支援
             ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('關於與支援'),
                  trailing: Icon(Icons.keyboard_arrow_right), // 這個不會展開，所以箭頭固定
                );
              },
              body: SizedBox(), // 這個面板沒有子選項，body 可以是空的或顯示其他內容
              isExpanded: false, // 保持關閉狀態
              canTapOnHeader: true, // 允許點擊 Header 觸發回調 (如果需要處理點擊事件)
            ),

          ],
        ),
      ),
    );
  }
}

