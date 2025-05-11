import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'icons.dart'; // 匯入圖片 Icon
import 'register.dart'; // 匯入註冊
import 'preference_selection.dart'; // 匯入偏好設定
import 'permissions.dart'; // 向使用者要求權限
import 'package:provider/provider.dart';
// import 'auth.dart';

void main() async {
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wandering App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wandering App Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<AuthModel>(
    //   builder: (context, auth, child) => HomePage(context),
    // );
    return HomePage(context);
  }

  Widget HomePage(BuildContext context) {
    if (true) {
      // !auth.isAuthenticated
      // 使用者未驗證，導航到 Register 頁面
      // 使用 Navigator 替換當前頁面為 Register 頁面
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Register()),
        );
      });
      // 在導航時返回一個空的容器或載入指示器
      return Container();
    } else {
      // 使用者已驗證，顯示主要內容
      return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: MainIcon(), // 顯示自訂圖片 icon
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const MainIcon(), // 主頁面也顯示一次 Icon
              const SizedBox(height: 16),
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}
