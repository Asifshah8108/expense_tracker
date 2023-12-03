import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid(); //declaring uuid to use id generator
final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const iconCategory = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid
            .v4(); //id is used as an initializer because we are not passing it as a constructor
  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final Category
      category; //using a predefined category so that typo error dosent occur
  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allexpense, this.category)
      : expenses = allexpense
            .where((expense) => expense.category == category)
            .toList();

  double get totalexpense {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
