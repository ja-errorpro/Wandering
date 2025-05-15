import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'all_page.dart'; // 匯入所有頁面

class InfoSharePage extends StatelessWidget {
  const InfoSharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('關於我們'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wandering App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Wandering 是一款智慧旅行規劃 App，致力於依據使用者偏好打造個性化行程，讓旅行探索更直覺、更自由。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '開發團隊',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text('• 開發者：Wanderning Team'),
                  const Text('• 聯絡信箱：cycugdsc@gmail.com'),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ShareAppButton(),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ShareAppButton extends StatelessWidget {
  const ShareAppButton({Key? key}) : super(key: key);

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '分享至',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(context, Icons.message, 'Line', 'https://line.me/R/msg/text/?快來下載Wandering App! https://your-app-download-link.com'),
                  _buildShareButton(context, Icons.facebook, 'Facebook', 'https://www.facebook.com/sharer/sharer.php?u=https://your-app-download-link.com'),
                  _buildShareButton(context, Icons.camera_alt, 'Instagram', 'https://your-app-download-link.com'),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消', style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget _buildShareButton(BuildContext context, IconData icon, String label, String url) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await Share.share(url);
            Navigator.pop(context);
          },
          child: CircleAvatar(
            radius: 28,
            backgroundColor: getCardGradientColors().first,
            child: Icon(icon, size: 28, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getCardGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showShareOptions(context),
        icon: const Icon(Icons.share),
        label: const Text('點此分享 Wandering App'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}