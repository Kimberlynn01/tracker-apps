// ignore_for_file: sized_box_for_whitespace, avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../functions/service/expense/expense.dart';
import '../models/expense.dart';

class FormsExpenses extends StatefulWidget {
  const FormsExpenses({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<FormsExpenses> createState() => _FormsExpensesState();
}

const uuid = Uuid();

class _FormsExpensesState extends State<FormsExpenses> {
  String username = '';
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisue;

  final ExpenseService _expenseService = ExpenseService();

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day, now.minute);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void initState() {
    _getUsername();
    super.initState();
  }

  void _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Danu';
    });
  }

  void _sumbitExpenseData() async {
    // Mendapatkan nilai username dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null) {
      print('Username not found in SharedPreferences.');
      return;
    }

    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          titleTextStyle: const TextStyle(color: Colors.red, fontSize: 30),
          title: const Text('Invalid Input'),
          content: const Text(
            'Make sure to fill out all existing field!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      );
      return;
    }

    final expense = Expense(
      id: uuid.v4(),
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      username: username,
    );

    _expenseService.addExpense(expense).then((_) {
      print('Expense added to Firebase!');
      widget.onAddExpense(expense);
      Navigator.pop(context);
    }).catchError((error) {
      print('Error adding expense: $error');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: const Text('Failed to add expense'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const Text(
              'Modal Daily',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                maxLength: 25,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).focusColor,
                  labelText: 'Title',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).focusColor,
                        prefixText: '\$',
                        labelText: 'Amount',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Row(
                  children: [
                    Text(_selectedDate == null
                        ? 'No date selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: DropdownButton(
                      isDense: true,
                      underline: const SizedBox(),
                      alignment: Alignment.center,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).cardColor)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _sumbitExpenseData,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
