// lib/services/book_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/book.dart';

class BookService {
  static const String BOOKS_KEY = 'books';

  // Sample initial books data
  List<Map<String, dynamic>> get initialBooks => [
    {
      "id": "1",
      "title": "Data Structures",
      "subtitle": "Advanced Concepts",
      "author": "John Smith",
      "coAuthor": "Jane Doe",
      "isbn": "978-1234567890",
      "publisher": "Tech Books",
      "placeOfPublisher": "New York",
      "edition": "2nd",
      "accessionNo": "ACC001",
      "bookNo": "B001",
      "classNo": "CS101",
      "callNo": "DSA-01"
    },
    // Add more sample books here
  ];

  Future<void> importInitialBooks() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(BOOKS_KEY)) {
      final List<Book> books = initialBooks
          .map((bookData) => Book.fromJson(bookData))
          .toList();
      await prefs.setString(BOOKS_KEY, jsonEncode(books.map((b) => b.toJson()).toList()));
    }
  }

  Future<List<Book>> getAllBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? booksJson = prefs.getString(BOOKS_KEY);
    
    if (booksJson == null) {
      return [];
    }
    
    List<dynamic> booksList = jsonDecode(booksJson);
    return booksList.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<Book>> searchBooks(String query) async {
    final books = await getAllBooks();
    final normalizedQuery = query.toLowerCase();
    return books.where((book) =>
      book.title.toLowerCase().contains(normalizedQuery) ||
      book.author.toLowerCase().contains(normalizedQuery) ||
      book.isbn.toLowerCase().contains(normalizedQuery)
    ).toList();
  }

  Future<void> addBook(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getAllBooks();
    books.add(book);
    await prefs.setString(BOOKS_KEY, jsonEncode(books.map((b) => b.toJson()).toList()));
  }

  Future<void> updateBook(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getAllBooks();
    final index = books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      books[index] = book;
      await prefs.setString(BOOKS_KEY, jsonEncode(books.map((b) => b.toJson()).toList()));
    }
  }

  Future<void> deleteBook(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getAllBooks();
    books.removeWhere((b) => b.id == id);
    await prefs.setString(BOOKS_KEY, jsonEncode(books.map((b) => b.toJson()).toList()));
  }

  Future<List<Book>> getInventory() async {
    return getAllBooks();
  }
}