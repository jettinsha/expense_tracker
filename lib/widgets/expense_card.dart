import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(expense.description),
        subtitle: Text('${expense.category} - ${expense.date.toString()}'),
        trailing: Text(
          'Rs ${expense.amount.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
