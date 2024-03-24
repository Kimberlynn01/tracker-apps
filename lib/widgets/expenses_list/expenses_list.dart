// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions/service/expense/expense.dart';
import '../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  ExpensesList({
    Key? key,
    required this.onRemoveExpense,
    required this.expenses,
    required this.username,
  }) : super(key: key);

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;
  final String username;

  final ExpenseService expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final String username = snapshot.data ?? '';
        return StreamBuilder<List<Expense>>(
          stream: expenseService.getExpensesStream(username).map((expenses) {
            expenses.sort((a, b) => a.username.compareTo(b.username));
            return expenses;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final List<Expense> sortedExpenses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: sortedExpenses.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(sortedExpenses[index].id),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                ),
                onDismissed: (direction) {
                  onRemoveExpense(
                    sortedExpenses[index],
                  );
                },
                child: ExpenseItem(
                  sortedExpenses[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }
}
