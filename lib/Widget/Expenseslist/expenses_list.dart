import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/Widget/Expenseslist/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onremoveexpense});
  final List<Expense> expenses;
  final void Function(Expense expense) onremoveexpense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses
          .length, //itemcount is used to set no of elements to be displayed on screen
      itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            onremoveexpense(expenses[index]);
          },
          key: ValueKey(ExpensesItem(expenses[index])),
           background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.27),
            margin: Theme.of(context).cardTheme.margin,
           ),
          child: ExpensesItem(expenses[
              index])), //dismissible is used to get swipe do delete function
    ); //using builder so that it only loads data which is visible so that it can improve performance of app
  }
}
