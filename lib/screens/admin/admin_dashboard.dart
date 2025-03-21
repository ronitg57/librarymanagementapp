import 'package:flutter/material.dart';
import 'book_management.dart';
import 'user_management.dart';
import 'inventory_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
            'Book Management',
            Icons.library_books,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookManagementScreen()),
            ),
          ),
          _buildDashboardItem(
            context,
            'User Management',
            Icons.people,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserManagementScreen()),
            ),
          ),
          _buildDashboardItem(
            context,
            'Inventory',
            Icons.inventory,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => InventoryManagementScreen()),
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