import 'dart:io';

import 'package:expense_tracker/Model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onaddExpense});
  final void Function(Expense expense) onaddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void _savetitleinput(String inputvalue) {
  //   _enteredTitle = inputvalue;
  // }
  DateTime? _selecteddate;
  Category _selectedCategory = Category.leisure;

  void _presentdatepicker() async {
    //async is used in case of future widgets or functions and us used with awaits keyword
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickeddate = await showDatePicker(
        //used to show calendar when calendar icon is clicked
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selecteddate = pickeddate;
    });
  }

  void _showdialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Invalid Input"),
                content:
                    const Text("Make sure all the fields are filled properly!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("ok"))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content:
                    const Text("Make sure all the fields are filled properly!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("ok"))
                ],
              ));
    }
  }

  void _submitExpensedata() {
    final enteredAmount = double.tryParse(_amountcontroller.text);
    final amountisInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titlecontroller.text.trim().isEmpty ||
        amountisInvalid ||
        _selecteddate == null) {
      _showdialog();
      return;
    }
    widget.onaddExpense(Expense(
        title: _titlecontroller.text,
        amount: enteredAmount,
        date: _selecteddate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardspace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          // onChanged: _savetitleinput,
                          controller: _titlecontroller,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          //expanded should be used if you are using row inside row or column to avoid error
                          controller: _amountcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefixText: '₹ '),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    // onChanged: _savetitleinput,
                    controller: _titlecontroller,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (Category) => DropdownMenuItem(
                                  value: Category,
                                  child: Text(Category.name.toUpperCase()),
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
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selecteddate == null
                                ? "Date not selected"
                                : formatter.format(
                                    _selecteddate!)), //! is used to tell flutter that we are sure it is not null
                            IconButton(
                                onPressed: _presentdatepicker,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          //expanded should be used if you are using row inside row or column to avoid error
                          controller: _amountcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefixText: '₹ '),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selecteddate == null
                                ? "Date not selected"
                                : formatter.format(
                                    _selecteddate!)), //! is used to tell flutter that we are sure it is not null
                            IconButton(
                                onPressed: _presentdatepicker,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context); //used to close the popup
                          },
                          child: const Text(
                            "Cancel",
                            // style:TextStyle(color: Color.fromARGB(255, 19, 131, 222)),
                          )),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: _submitExpensedata,
                              child: const Text(
                                "Save Expenses",
                                // style:TextStyle(color: Color.fromARGB(255, 19, 131, 222)),
                              )),
                        ],
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (Category) => DropdownMenuItem(
                                  value: Category,
                                  child: Text(Category.name.toUpperCase()),
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
                          }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context); //used to close the popup
                          },
                          child: const Text(
                            "Cancel",
                            // style:TextStyle(color: Color.fromARGB(255, 19, 131, 222)),
                          )),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: _submitExpensedata,
                              child: const Text(
                                "Save Expenses",
                                // style:TextStyle(color: Color.fromARGB(255, 19, 131, 222)),
                              )),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
