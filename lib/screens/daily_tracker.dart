import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';

class DailyTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Tracker'),
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

          // Group expenses by day
          final Map<String, List<Expense>> dailyExpenses = {};
          for (final expense in expenses) {
            final day = expense.date.toIso8601String().split('T')[0];
            dailyExpenses.putIfAbsent(day, () => []).add(expense);
          }

          return ListView.builder(
            itemCount: dailyExpenses.length,
            itemBuilder: (context, index) {
              final day = dailyExpenses.keys.elementAt(index);
              final totalAmount = dailyExpenses[day]!
                  .map((e) => e.amount)
                  .reduce((a, b) => a + b);

              return ExpansionTile(
                title: Text('Date: $day'),
                subtitle: Text(
                    'Total Expenses: Rs ${totalAmount.toStringAsFixed(2)}'),
                children: dailyExpenses[day]!
                    .map((expense) => ExpenseCard(expense: expense))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
