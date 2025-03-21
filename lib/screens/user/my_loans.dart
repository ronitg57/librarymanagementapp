// lib/screens/user/my_loans.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/loan.dart';
import '../../services/loan_service.dart';

class MyLoansScreen extends StatefulWidget {
  @override
  _MyLoansScreenState createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen> {
  final LoanService _loanService = LoanService();
  List<Loan> _loans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    setState(() => _isLoading = true);
    try {
      final loans = await _loanService.getUserLoans();
      setState(() => _loans = loans);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading loans: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Loans'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadLoans,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _loans.isEmpty
              ? Center(child: Text('No loans found'))
              : ListView.builder(
                  itemCount: _loans.length,
                  itemBuilder: (context, index) {
                    final loan = _loans[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loan.book.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 8),
                            Text('Author: ${loan.book.author}'),
                            Text('ISBN: ${loan.book.isbn}'),
                            SizedBox(height: 8),
                            Text('Issue Date: ${_formatDate(loan.issueDate)}'),
                            Text('Due Date: ${_formatDate(loan.dueDate)}'),
                            if (loan.returnDate != null)
                              Text('Returned: ${_formatDate(loan.returnDate!)}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status: ${loan.isOverdue ? 'Overdue' : loan.returnDate != null ? 'Returned' : 'Active'}',
                                  style: TextStyle(
                                    color: loan.isOverdue 
                                      ? Colors.red 
                                      : loan.returnDate != null 
                                        ? Colors.green 
                                        : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (loan.returnDate == null)
                                  ElevatedButton(
                                    onPressed: () => _returnBook(loan),
                                    child: Text('Return'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Future<void> _returnBook(Loan loan) async {
    try {
      await _loanService.returnBook(loan.id);
      await _loadLoans();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book returned successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error returning book: ${e.toString()}')),
      );
    }
  }
}