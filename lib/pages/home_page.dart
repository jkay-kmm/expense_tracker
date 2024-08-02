import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/my_list_tile.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper_function.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<Map<String, double>>? _monthTotalsFuture;

  Future<double>? _calculateCurrentMonthTotail;

  @override
  void initState() {
    //read db on inital startup
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    // load future

    refreshData();
    super.initState();
  }

//refresh graph data
  void refreshData() {
    _monthTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
    _calculateCurrentMonthTotail =
        Provider.of<ExpenseDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  //open new expense box
  void openNewExpenseBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tạo mới"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //user input -> expense name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Tên mục"),
                  ),
                  //user input -> expense amount
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Giá"
                        ""),
                  )
                ],
              ),
              actions: [
                // cancel button
                _cancelButton(),

                //save button
                _createNewExpenseButton(),
              ],
            ));
  }

// open dit box
  void openEditBox(Expense expense) {
    String existingName = expense.name;
    String existringAmount = expense.amount.toString();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Chỉnh sửa"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //user input -> expense name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: existingName),
                  ),
                  //user input -> expense amount
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(hintText: existringAmount),
                  )
                ],
              ),
              actions: [
                // cancel button
                _cancelButton(),

                //save button
                _editExpenseButton(expense),
              ],
            ));
  }

// open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Xóa"),
              actions: [
                // cancel button
                _cancelButton(),

                //save button
                _deleteExpenseButton(expense.id),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      //get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      //calculate the number of months sinxe the first month
      int monthCount =
          calculateMonthCount(startYear, startMonth, currentYear, currentMonth);
      // only display the expense for the current month
      List<Expense> currentMonthExpenses = value.allExpense.where((expense) {
        return expense.date.year == currentYear &&
            expense.date.month == currentMonth;
      }).toList();
      // return UI
      return Scaffold(
          backgroundColor: Colors.grey.shade100,
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: FutureBuilder<double>(
              future: _calculateCurrentMonthTotail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$' + snapshot.data!.toStringAsFixed(2)),
                      Text(getCurrentMonthName())
                    ],
                  );
                } else {
                  return Text("Loading.....");
                }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // graph ui
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                      future: _monthTotalsFuture,
                      builder: (context, snapshot) {
                        //data is load
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, double> monthlyTotals =
                              snapshot.data ?? {};
                          //create the list of monthy summary
                          List<double> monthlySummary = List.generate(
                            monthCount,
                            (index) {
                              int year =
                                  startYear + (startMonth + index - 1) ~/ 12;
                              int month = (startMonth + index - 1) % 12 + 1;
                              String yearMonthKey = '$year-$month';
                              return monthlyTotals[yearMonthKey] ?? 0.0;
                            },
                          );
                          return MyBargraph(
                              monthlySummary: monthlySummary,
                              startMonth: startMonth);
                        } else {
                          return const Center(
                            child: Text("Loading...."),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Expense list ui
                Expanded(
                  child: ListView.builder(
                      itemCount: currentMonthExpenses.length,
                      itemBuilder: (context, index) {
                        // reverse the index to show latest item first
                        int reversedIndex = currentMonthExpenses.length - 1 - index;
                        //get individual expense

                        Expense individuaExpense = currentMonthExpenses[index];

                        return MyListTile(
                          title: individuaExpense.name,
                          trailing: formatAmount(individuaExpense.amount),
                          onEditPressed: (context) =>
                              openEditBox(individuaExpense),
                          onDeletePressed: (context) =>
                              openDeleteBox(individuaExpense),
                        );
                      }),
                ),
              ],
            ),
          ));
    });
  }

//Cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        //pop box
        Navigator.pop(context);
        //clear controller
        nameController.clear();
        amountController.clear();
      },
      child: const Text("Hủy bỏ"),
    );
  }
  // Save button -> create new expense

  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);

          //create new expense
          Expense newExpense = Expense(
              name: nameController.text,
              amount: converStringToDouble(amountController.text),
              date: DateTime.now(), username: '', password: '');

          //save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          // refresh graph
          refreshData();
          //clear controller

          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Lưu"),
    );
  }

  // Save button -> Edit existing expense
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);
          Expense updateExpense = Expense(
              name: nameController.text.isNotEmpty
                  ? nameController.text
                  : expense.name,
              amount: amountController.text.isNotEmpty
                  ? converStringToDouble(amountController.text)
                  : expense.amount,
              date: DateTime.now(), username: '', password: '');

          //old expense id
          int existingId = expense.id;

          //save to db

          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updateExpense);
          // refresh graph
          refreshData();
        }
      },
      child: const Text("Lưu"),
    );
  }

  // Delete button
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // pop box

        Navigator.pop(context);

        // delete expense from db

        await context.read<ExpenseDatabase>().deleteExpense(id);
        // refresh graph
        refreshData();
      },
      child: const Text("Xóa"),
    );
  }
}
