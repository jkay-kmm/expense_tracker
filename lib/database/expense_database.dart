import 'dart:async';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpense = [

  ];

  //initialize db

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  //Getter
  List<Expense> get allExpense => _allExpense;

  // Operations
  // Create

  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    await readExpenses();
  }

  // Read

  Future<void> readExpenses() async {
    List<Expense> fetchedExpense = await isar.expenses.where().findAll();
    _allExpense.clear();
    _allExpense.addAll(fetchedExpense);

    notifyListeners();
  }

  //Update

  Future<void> updateExpense(int id, Expense updateExpense) async {
    updateExpense.id = id;
    await isar.writeTxn(() => isar.expenses.put(updateExpense));

    await readExpenses();
  }

  //Delete
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));
    await readExpenses();
  }

  Future<Map<String, double>> calculateMonthlyTotals() async {
    //ensure the expense are read from the db
    await readExpenses();

    //create a map to keep track of total expense per month

    Map<String, double> monthlyTotals = {};

    //  iterate over all expense

    for (var expense in _allExpense) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';
      // if the month is not yet in the map , initalize to 0
      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }
      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }
    return monthlyTotals;
  }

  Future<double> calculateCurrentMonthTotal() async {
    await readExpenses();

    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    List<Expense> currentMonthExpense = _allExpense.where((expense) {
      return expense.date.month == currentMonth &&
          expense.date.year == currentYear;
    }).toList();
    double total =
        currentMonthExpense.fold(0, (sum, expense) => sum + expense.amount);
    return total;
  }

  // get start month
  int getStartMonth() {
    if (_allExpense.isEmpty) {
      return DateTime.now().month;
    }
    _allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpense.first.date.month;
  }

  // get start year
  int getStartYear() {
    if (_allExpense.isEmpty) {
      return DateTime.now().year;
    }
    _allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpense.first.date.year;
  }
}
