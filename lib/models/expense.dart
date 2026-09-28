import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    final dynamic dateValue = map['date'];

    DateTime expenseDate;

    if (dateValue is Timestamp) {
      expenseDate = dateValue.toDate();
    } else if (dateValue is String) {
      expenseDate = DateTime.parse(dateValue);
    } else if (dateValue is DateTime) {
      expenseDate = dateValue;
    } else {
      expenseDate = DateTime.now();
    }

    return Expense(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      amount: map['amount'] is num
          ? (map['amount'] as num).toDouble()
          : double.tryParse(map['amount']?.toString() ?? '0') ?? 0.0,
      category: map['category']?.toString() ?? '',
      date: expenseDate,
      note: map['note']?.toString() ?? '',
    );
  }
}