// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:course_udemy_expense_tracker_app/widgets/chart/chart.dart';
import 'package:course_udemy_expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:course_udemy_expense_tracker_app/widgets/form_expenses.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/service/expense/expense.dart';
import '../models/expense.dart';
import 'logout.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  String? username;
  final List<Expense> _registerdExpenses = [];
  final ExpenseService _expenseService = ExpenseService();
  final CustomPopupMenuController _customPopupMenuController =
      CustomPopupMenuController();
  late StreamSubscription<List<Expense>> _subscription;

  @override
  void initState() {
    super.initState();
    sharedPreferences();
    _initExpenses();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FormsExpenses(onAddExpense: _addExpense),
      ),
    );
  }

  void sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
    if (username != null) {
      _initExpenses();
    }
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }

  Future<void> _initExpenses() async {
    _subscription =
        _expenseService.getExpensesStream(username ?? '').listen((expenses) {
      if (mounted) {
        setState(() {
          _registerdExpenses.clear();
          _registerdExpenses.addAll(expenses);
        });
      }
    });
  }

  void _removeExpense(Expense expense) async {
    setState(() {
      _registerdExpenses.remove(expense);
    });

    await _expenseService.removeExpense(expense.id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Center(
              child: Text(
                'Tracker Deleted',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          );
        });
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Tracker Not Found'),
    );

    if (_registerdExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        username: username ?? '',
        expenses: _registerdExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseOverlay,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: [
          CustomPopupMenu(
            controller: _customPopupMenuController,
            arrowColor: Theme.of(context).cardColor,
            barrierColor: const Color(0x44181616),
            arrowSize: 16,
            menuBuilder: () {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Theme.of(context).cardColor,
                  width: 145,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          _customPopupMenuController.hideMenu();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Logout'),
                        onTap: () {
                          _customPopupMenuController.hideMenu();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const Logout()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            pressType: PressType.singleClick,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          )
        ],
        centerTitle: true,
        title: const Text(
          'Tracker Apps',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Chart(expenses: _registerdExpenses),
          Expanded(
            child: mainContent,
          )
        ],
      ),
    );
  }
}
