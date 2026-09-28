import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ADD expense
  Future<void> addExpense(Expense expense) async {
    await _firestore
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toMap());
  }

  // GET expenses
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Expense.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  // UPDATE expense
  Future<void> updateExpense(Expense expense) async {
    await _firestore
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toMap());
  }

  // DELETE expense
  Future<void> deleteExpense(String id) async {
    await _firestore
        .collection('expenses')
        .doc(id)
        .delete();
  }
}