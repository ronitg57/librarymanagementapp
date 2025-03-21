// lib/services/loan_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/loan.dart';
import '../models/book.dart';
import 'auth_service.dart';

class LoanService {
  static const String LOANS_KEY = 'loans';
  final AuthService _authService = AuthService();

  Future<List<Loan>> getUserLoans() async {
    final userId = await _authService.getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final prefs = await SharedPreferences.getInstance();
    final loansString = prefs.getString(LOANS_KEY) ?? '[]';
    final List<dynamic> loansList = jsonDecode(loansString);
    
    return loansList
        .map((loan) => Loan.fromJson(loan))
        .where((loan) => loan.userId == userId)
        .toList();
  }

  Future<void> returnBook(String loanId) async {
    final prefs = await SharedPreferences.getInstance();
    final loansString = prefs.getString(LOANS_KEY) ?? '[]';
    final List<dynamic> loansList = jsonDecode(loansString);
    final loans = loansList.map((loan) => Loan.fromJson(loan)).toList();

    final index = loans.indexWhere((loan) => loan.id == loanId);
    if (index != -1) {
      final updatedLoan = Loan(
        id: loans[index].id,
        userId: loans[index].userId,
        book: loans[index].book,
        issueDate: loans[index].issueDate,
        dueDate: loans[index].dueDate,
        returnDate: DateTime.now(),
      );
      loans[index] = updatedLoan;
      await prefs.setString(LOANS_KEY, jsonEncode(loans.map((l) => l.toJson()).toList()));
    }
  }

  Future<void> addLoan(Book book) async {
    final userId = await _authService.getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final prefs = await SharedPreferences.getInstance();
    final loansString = prefs.getString(LOANS_KEY) ?? '[]';
    final List<dynamic> loansList = jsonDecode(loansString);
    final loans = loansList.map((loan) => Loan.fromJson(loan)).toList();

    final newLoan = Loan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      book: book,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 14)),
      returnDate: null,
    );

    loans.add(newLoan);
    await prefs.setString(LOANS_KEY, jsonEncode(loans.map((l) => l.toJson()).toList()));
  }
}