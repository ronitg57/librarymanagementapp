import 'dart:convert';
import '../models/book.dart';

class QRService {
  String generateQRData(Book book) {
    final Map<String, dynamic> bookData = {
      'title': book.title,
      'subtitle': book.subtitle,
      'author': book.author,
      'coAuthor': book.coAuthor,
      'isbn': book.isbn,
      'publisher': book.publisher,
      'placeOfPublisher': book.placeOfPublisher,
      'edition': book.edition,
      'accessionNo': book.accessionNo,
      'bookNo': book.bookNo,
      'classNo': book.classNo,
      'callNo': book.callNo,
    };
    return jsonEncode(bookData);
  }

  Book parseQRData(String qrData) {
    final Map<String, dynamic> bookData = jsonDecode(qrData);
    return Book.fromJson(bookData);
  }
}