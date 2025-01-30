import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';

class MonthlyTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Tracker'),
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

          // Group expenses by month
          final Map<String, List<Expense>> monthlyExpenses = {};
          for (final expense in expenses) {
            final month = '${expense.date.year}-${expense.date.month}';
            monthlyExpenses.putIfAbsent(month, () => []).add(expense);
          }

          return ListView.builder(
            itemCount: monthlyExpenses.length,
            itemBuilder: (context, index) {
              final month = monthlyExpenses.keys.elementAt(index);
              final totalAmount = monthlyExpenses[month]!
                  .map((e) => e.amount)
                  .reduce((a, b) => a + b);

              return ExpansionTile(
                title: Text('Month: $month'),
                subtitle: Text(
                    'Total Expenses: Rs ${totalAmount.toStringAsFixed(2)}'),
                children: monthlyExpenses[month]!
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
