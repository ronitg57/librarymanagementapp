// lib/screens/user/book_search.dart
import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final _searchController = TextEditingController();
  final _bookService = BookService();
  List<Book> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Books')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search books',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _performSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final book = _searchResults[index];
                      return ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        onTap: () {
                          // Show book details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final results = await _bookService.searchBooks(query);
      setState(() => _searchResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching books: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}