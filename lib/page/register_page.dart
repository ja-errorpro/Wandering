import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:Wandering/auth.dart';
import 'all_page.dart'; // 匯入所有頁面

class Register extends StatelessWidget {
  // TODO: Add TextEditingControllers for input fields
  // TODO: Implement registration logic

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController userEmailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('註冊一個新帳號'),
        centerTitle: true, // 新增這行來居中標題
      ),
      body: Padding(
        // 添加 Padding 使內容不貼邊
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              // autofocus: true, // 光標（在桌面設備上）會自動出現在該輸入框中。可能會影響使用者體驗，建議移除
              decoration: InputDecoration(
                labelText: "使用者名稱",
                hintText: "Yiji",
                prefixIcon: Icon(Icons.person),
              ),
              controller: userNameController,
              // TODO: Assign a TextEditingController
            ),
            const SizedBox(height: 12), // 增加 TextField 之間的間距
            TextField(
              // autofocus: true, // 光標（在桌面設備上）會自動出現在該輸入框中。
              decoration: InputDecoration(
                labelText: "電子郵箱",
                hintText: "Yiji@example.com",
                prefixIcon: Icon(Icons.mail),
              ),
              controller: userEmailController,
              // TODO: Assign a TextEditingController
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: "密碼",
                hintText: "請輸入密碼",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              controller: passwordController,
              // TODO: Assign a TextEditingController
            ),
            const SizedBox(height: 24), // 按鈕上方的間距

            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual registration logic using the input from TextField controllers
                print('執行註冊...'); // 暫時印出訊息
                // 導向註冊頁面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );

                // 註冊成功後可能導航到其他頁面或顯示訊息
                // Provider.of<AuthModel>(
                //   context,
                //   listen: false,
                // ).register(context, userNameController.text, userEmailController.text, passwordController.text);
                // 導向到登入頁面
                

              },
              child: const Text('註冊'),
            ),
          ],
        ),
      ),
    );
  }
}

