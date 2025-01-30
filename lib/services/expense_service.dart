import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add expense
  Future<void> addExpense(Expense expense) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .add(expense.toMap());
  }

  // Fetch expenses
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromMap(doc.data())).toList());
  }
}
