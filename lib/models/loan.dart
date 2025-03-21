// lib/models/loan.dart
import 'book.dart';

class Loan {
  final String id;
  final String userId;
  final Book book;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  Loan({
    required this.id,
    required this.userId,
    required this.book,
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
  });

  bool get isOverdue {
    if (returnDate != null) return false;
    return DateTime.now().isAfter(dueDate);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'book': book.toJson(),
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      userId: json['userId'],
      book: Book.fromJson(json['book']),
      issueDate: DateTime.parse(json['issueDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null 
          ? DateTime.parse(json['returnDate'])
          : null,
    );
  }
}