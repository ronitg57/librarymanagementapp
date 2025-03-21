// lib/screens/admin/book_management.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookManagementScreen extends StatefulWidget {
  @override
  _BookManagementScreenState createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    try {
      final books = await _bookService.getAllBooks();
      setState(() => _books = books);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading books: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Book> get _filteredBooks {
    if (_searchQuery.isEmpty) return _books;
    final query = _searchQuery.toLowerCase();
    return _books.where((book) =>
      book.title.toLowerCase().contains(query) ||
      book.author.toLowerCase().contains(query) ||
      book.isbn.toLowerCase().contains(query)
    ).toList();
  }

  Future<void> _showAddEditBookDialog([Book? book]) async {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: book?.title ?? '');
    final _subtitleController = TextEditingController(text: book?.subtitle ?? '');
    final _authorController = TextEditingController(text: book?.author ?? '');
    final _coAuthorController = TextEditingController(text: book?.coAuthor ?? '');
    final _isbnController = TextEditingController(text: book?.isbn ?? '');
    final _publisherController = TextEditingController(text: book?.publisher ?? '');
    final _placeController = TextEditingController(text: book?.placeOfPublisher ?? '');
    final _editionController = TextEditingController(text: book?.edition ?? '');
    final _accessionController = TextEditingController(text: book?.accessionNo ?? '');
    final _bookNoController = TextEditingController(text: book?.bookNo ?? '');
    final _classNoController = TextEditingController(text: book?.classNo ?? '');
    final _callNoController = TextEditingController(text: book?.callNo ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book == null ? 'Add New Book' : 'Edit Book'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title *'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _subtitleController,
                  decoration: InputDecoration(labelText: 'Subtitle'),
                ),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Author *'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _coAuthorController,
                  decoration: InputDecoration(labelText: 'Co-Author'),
                ),
                TextFormField(
                  controller: _isbnController,
                  decoration: InputDecoration(labelText: 'ISBN *'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _publisherController,
                  decoration: InputDecoration(labelText: 'Publisher'),
                ),
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(labelText: 'Place of Publisher'),
                ),
                TextFormField(
                  controller: _editionController,
                  decoration: InputDecoration(labelText: 'Edition'),
                ),
                TextFormField(
                  controller: _accessionController,
                  decoration: InputDecoration(labelText: 'Accession No *'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _bookNoController,
                  decoration: InputDecoration(labelText: 'Book No *'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _classNoController,
                  decoration: InputDecoration(labelText: 'Class No'),
                ),
                TextFormField(
                  controller: _callNoController,
                  decoration: InputDecoration(labelText: 'Call No'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final newBook = Book(
                  id: book?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                  author: _authorController.text,
                  coAuthor: _coAuthorController.text,
                  isbn: _isbnController.text,
                  publisher: _publisherController.text,
                  placeOfPublisher: _placeController.text,
                  edition: _editionController.text,
                  accessionNo: _accessionController.text,
                  bookNo: _bookNoController.text,
                  classNo: _classNoController.text,
                  callNo: _callNoController.text,
                );

                if (book == null) {
                  await _bookService.addBook(newBook);
                } else {
                  await _bookService.updateBook(newBook);
                }

                Navigator.pop(context);
                _loadBooks();
              }
            },
            child: Text(book == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showQRCode(Book book) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code for ${book.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: jsonEncode(book.toJson()),
              size: 200,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 16),
            Text('Scan this QR code to get book details', 
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await _bookService.deleteBook(book.id);
      _loadBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBooks,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Books',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? Center(child: Text('No books found'))
                    : ListView.builder(
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(book.title),
                              subtitle: Text('${book.author} - ISBN: ${book.isbn}'),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'qr',
                                    child: ListTile(
                                      leading: Icon(Icons.qr_code),
                                      title: Text('Generate QR'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete, color: Colors.red),
                                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'qr':
                                      await _showQRCode(book);
                                      break;
                                    case 'edit':
                                      await _showAddEditBookDialog(book);
                                      break;
                                    case 'delete':
                                      await _confirmDelete(book);
                                      break;
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditBookDialog(),
        child: Icon(Icons.add),
        tooltip: 'Add New Book',
      ),
    );
  }
}