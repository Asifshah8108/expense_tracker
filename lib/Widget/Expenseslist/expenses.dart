import 'package:expense_tracker/Widget/Expenseslist/expenses_list.dart';
import 'package:expense_tracker/Widget/Expenseslist/new_expense.dart';
import 'package:expense_tracker/Widget/chart/chart.dart';
import 'package:flutter/material.dart';
import '../../Model/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Purchasing new phone",
        amount: 14999.00,
        category: Category.leisure,
        date: DateTime.now()),
    Expense(
        title: "mothly Shopping from Dmart",
        amount: 5500.99,
        category: Category.food,
        date: DateTime.now())
  ];

  void _addModalBottom() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,//added to ensure that app dosent take camera area it avoids it and take a safe area
      context: context,
      builder: (ctx) => NewExpense(onaddExpense: _addexpense),
    );
  }

  void _addexpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseindex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text("Expense Deleted"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseindex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;//used to store the with of the running device in differnt mode
    Widget mainContent = const Center(
      child: Text("No expenses added yet!"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
          expenses: _registeredExpenses, onremoveexpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _addModalBottom, icon: const Icon(Icons.add))
        ],
      ),
      body: width<600 ?Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child:
                mainContent, //expanded is used because we are using Listview inside a colum which will not display our items
          ),
        ],
      ):Row(children: [
          Expanded(
            child:
            Chart(expenses: _registeredExpenses),
            ),//used Expanded to avoid error when landscaped
          Expanded(
            child:
                mainContent, //expanded is used because we are using Listview inside a colum which will not display our items
          ),
        ],),
    );
  }
}
