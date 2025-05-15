import 'package:flutter/material.dart';
import 'package:Wandering/auth.dart';
import 'all_page.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = {
      'name': 'Unknown',
      'email': 'cycugdsc@gmail.com',
      'location': '台北市, 台灣',
      'birthday': '2004/06/01',
      'gender': '女性',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('用戶資訊'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '個人資料',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoTile('暱稱', userInfo['name']!),
            _buildInfoTile('電子郵件', userInfo['email']!),
            _buildInfoTile('居住地', userInfo['location']!),
            _buildInfoTile('生日', userInfo['birthday']!),
            _buildInfoTile('性別', userInfo['gender']!),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('返回'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getCardGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
