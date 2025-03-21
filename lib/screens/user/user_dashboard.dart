import 'package:flutter/material.dart';
import 'book_search.dart';
import 'qr_scanner.dart';
import 'my_loans.dart';
import 'profile.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Implement logout
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          _buildDashboardItem(
            context,
            'Search Books',
            Icons.search,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookSearchScreen()),
            ),
          ),
          _buildDashboardItem(
            context,
            'Scan QR',
            Icons.qr_code_scanner,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QRScannerScreen()),
            ),
          ),
          _buildDashboardItem(
            context,
            'My Loans',
            Icons.book,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyLoansScreen()),
            ),
          ),
          _buildDashboardItem(
            context,
            'Profile',
            Icons.person,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}