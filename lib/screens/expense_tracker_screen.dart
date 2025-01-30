import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';

class ExpenseTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data ?? [];
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ExpenseCard(expense: expense);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new expense
        },
        child: Icon(Icons.add),
      ),
    );
  }
}