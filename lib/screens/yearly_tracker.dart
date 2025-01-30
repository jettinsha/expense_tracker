import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';

class YearlyTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Yearly Tracker'),
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

          // Group expenses by year
          final Map<int, List<Expense>> yearlyExpenses = {};
          for (final expense in expenses) {
            final year = expense.date.year;
            yearlyExpenses.putIfAbsent(year, () => []).add(expense);
          }

          return ListView.builder(
            itemCount: yearlyExpenses.length,
            itemBuilder: (context, index) {
              final year = yearlyExpenses.keys.elementAt(index);
              final totalAmount = yearlyExpenses[year]!
                  .map((e) => e.amount)
                  .reduce((a, b) => a + b);

              return ExpansionTile(
                title: Text('Year: $year'),
                subtitle: Text(
                    'Total Expenses: Rs ${totalAmount.toStringAsFixed(2)}'),
                children: yearlyExpenses[year]!
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
