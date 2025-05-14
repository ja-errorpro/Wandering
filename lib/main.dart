import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'icons.dart'; // 匯入圖片 Icon
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'page/all_page.dart'; // 匯入所有頁面
import 'permissions.dart'; // 向使用者要求權限
import 'package:provider/provider.dart';
import 'auth.dart'; // 登入
import 'permissions.dart';

Future<bool> isFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 檢查 'first_launch' 這個 key 是否存在或其值為 true
  bool isFirst = prefs.getBool('first_launch') ?? true; // 預設為 true
  return isFirst;
}

void setFirstLaunchDone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 設定 'first_launch' 為 false，表示 App 已經開啟過
  await prefs.setBool('first_launch', false);
}

Future<void> CheckNeccessaryPermissions(BuildContext context) async {
  var permission_manager = PermissionManager();
  permission_manager.message = '需要一些權限才能繼續使用';
  permission_manager.deniedmessage = '檢測到權限被拒，請同意權限後才能繼續使用';
  permission_manager.getPermission(context, Permission.location);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // runApp(MyApp()); // 假設你的主頁面路由是 '/'

  runApp(
    ChangeNotifierProvider(create: (context) => AuthModel(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
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

  void _EnterWelcomePage(BuildContext context) async {
    bool firstLaunch = await isFirstLaunch();
    await CheckNeccessaryPermissions(context);
    if (firstLaunch) {
      // 如果是第一次開啟，導航到 GuidingPage 頁面、初始化全域數據
      initializeGlobals();
      // 使用 Navigator 替換當前頁面為 Register 頁面
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GuidingPage()),
        );
      });
      // runApp(MyApp(initialRoute: '/register')); // 假設你的註冊頁面路由是 '/register'
      setFirstLaunchDone(); // 設定標誌為已開啟過
    }
    // 不是第一次開啟，或者剛開啟過歡迎頁面，導航到主頁
  }

  Widget HomePage(BuildContext context) {
    // 判斷是否需要導航到歡迎頁面
    _EnterWelcomePage(context);
    return Consumer<AuthModel>(
      builder: (context, auth, child) => _buildHomePage(context, auth),
    );
  }

  Widget _buildHomePage(BuildContext context, AuthModel auth) {
    if (!auth.isAuthenticated) {
      // !auth.isAuthenticated
      // 使用者未驗證，導航到 Register 頁面

      // 在導航時返回一個空的容器或載入指示器
      return MaterialApp(home: Login());
    } else {
      return MaterialApp(home: ExplorePage());
    }
  }
}


/*  // 使用者已驗證，顯示主要內容
      return MaterialApp(
        home: Scaffold(
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
        ),
      ); */