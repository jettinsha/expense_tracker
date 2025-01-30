import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';

class WeeklyTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Tracker'),
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

          // Group expenses by week
          final Map<String, List<Expense>> weeklyExpenses = {};
          for (final expense in expenses) {
            final week =
                '${expense.date.year}-W${_getWeekNumber(expense.date)}';
            weeklyExpenses.putIfAbsent(week, () => []).add(expense);
          }

          return ListView.builder(
            itemCount: weeklyExpenses.length,
            itemBuilder: (context, index) {
              final week = weeklyExpenses.keys.elementAt(index);
              final totalAmount = weeklyExpenses[week]!
                  .map((e) => e.amount)
                  .reduce((a, b) => a + b);

              return ExpansionTile(
                title: Text('Week: $week'),
                subtitle: Text(
                    'Total Expenses: Rs ${totalAmount.toStringAsFixed(2)}'),
                children: weeklyExpenses[week]!
                    .map((expense) => ExpenseCard(expense: expense))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final firstMonday =
        startOfYear.add(Duration(days: (8 - startOfYear.weekday) % 7));
    final weekNumber = ((date.difference(firstMonday).inDays) / 7).floor() + 1;
    return weekNumber;
  }
}
