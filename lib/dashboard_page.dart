import 'package:flutter/material.dart';
import 'webview_page.dart';
import 'chat_page.dart';
import 'upload_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WebViewPage()),
              ),
              style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
              child: Text('Dashboard (Webview)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatPage()),
              ),
              style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
              child: Text('Chat'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UploadPage()),
              ),
              style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
              child: Text('Upload Property'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              ),
              style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
