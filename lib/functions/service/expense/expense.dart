// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import '../../../models/expense.dart';

class ExpenseService {
  final DatabaseReference _expenseRef =
      FirebaseDatabase.instance.ref().child('expense');

  Future<void> addExpense(Expense expense) async {
    try {
      await _expenseRef.push().set({
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date.toString(),
        'category': expense.category.toString(),
        'username': expense.username,
      });
    } catch (error) {
      print('Error adding expense: $error');
    }
  }

  Stream<List<Expense>> getExpensesStream(String username) {
    return _expenseRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        return <Expense>[];
      }

      final List<Expense> expenses = [];
      data.forEach((key, value) {
        if (value['username'] == username) {
          // Filter data berdasarkan username
          final expense = Expense(
            username: username,
            id: key.toString(),
            title: value['title'],
            amount: double.parse(value['amount'].toString()),
            date: DateTime.parse(value['date']),
            category: Category.values.firstWhere(
              (e) => e.toString() == value['category'],
              orElse: () =>
                  Category.food, // Provide a default category if necessary
            ),
          );
          expenses.add(expense);
        }
      });

      return expenses;
    });
  }

  Future<void> removeExpense(String id) async {
    try {
      await _expenseRef.child(id).remove();
    } catch (error) {
      print('Error removing expense: $error');
    }
  }
}
