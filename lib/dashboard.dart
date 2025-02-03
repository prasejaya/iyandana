import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Inisialisasi index halaman yang sedang aktif
  int _selectedIndex = 0;

  // Daftar halaman untuk setiap tab
  final List<Widget> _pages = [
    HomeScreen(),
    ChatScreen(),
    UploadScreen(),
    ProfileScreen(),
  ];

  // Fungsi untuk menangani perubahan tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: _pages[_selectedIndex],  // Menampilkan halaman berdasarkan index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ikon untuk menu Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_emoticon), // Ikon emoticon untuk Chat
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), // Ikon plus untuk Upload
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar( // Ikon foto untuk Profile
              backgroundImage: AssetImage('assets/images/default_profile.png'), // Ganti dengan path foto default
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Halaman untuk Home
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Home'));
  }
}

// Halaman untuk Chat
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Chat'));
  }
}

// Halaman untuk Upload
class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Upload'));
  }
}

// Halaman untuk Profile
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Profile'));
  }
}
