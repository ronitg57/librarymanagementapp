// lib/screens/admin/inventory_management.dart
import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../services/qr_service.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final BookService _bookService = BookService();
  List<Book> _inventory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    try {
      final inventory = await _bookService.getInventory();
      setState(() => _inventory = inventory);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading inventory: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadInventory,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _inventory.length,
              itemBuilder: (context, index) {
                final book = _inventory[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text('ISBN: ${book.isbn}'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Generate QR'),
                          value: 'qr',
                        ),
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'qr') {
                          // Implement QR generation
                        } else if (value == 'edit') {
                          // Implement edit
                          await _editBook(book);
                        } else if (value == 'delete') {
                          // Implement delete
                          await _deleteBook(book);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addBook() async {
    // Implement add book dialog
  }

  Future<void> _editBook(Book book) async {
    // Implement edit book dialog
  }

  Future<void> _deleteBook(Book book) async {
    // Implement delete confirmation dialog
  }
}