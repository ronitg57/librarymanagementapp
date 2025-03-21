// lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String coAuthor;
  final String isbn;
  final String publisher;
  final String placeOfPublisher;
  final String edition;
  final String accessionNo;
  final String bookNo;
  final String classNo;
  final String callNo;

  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.coAuthor,
    required this.isbn,
    required this.publisher,
    required this.placeOfPublisher,
    required this.edition,
    required this.accessionNo,
    required this.bookNo,
    required this.classNo,
    required this.callNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'coAuthor': coAuthor,
      'isbn': isbn,
      'publisher': publisher,
      'placeOfPublisher': placeOfPublisher,
      'edition': edition,
      'accessionNo': accessionNo,
      'bookNo': bookNo,
      'classNo': classNo,
      'callNo': callNo,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      author: json['author'],
      coAuthor: json['coAuthor'],
      isbn: json['isbn'],
      publisher: json['publisher'],
      placeOfPublisher: json['placeOfPublisher'],
      edition: json['edition'],
      accessionNo: json['accessionNo'],
      bookNo: json['bookNo'],
      classNo: json['classNo'],
      callNo: json['callNo'],
    );
  }
}