import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _amountController =
      TextEditingController();

  final TextEditingController _noteController =
      TextEditingController();

  final ExpenseService _expenseService =
      ExpenseService();

  String? _selectedCategory;

  DateTime _selectedDate = DateTime.now();

  bool _isLoading = false;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
    'Education',
    'Entertainment',
    'Other',
  ];

  // ==========================================
  // EDIT MODE
  // ==========================================

  bool get _isEditMode => widget.expense != null;

  // ==========================================
  // INIT
  // ==========================================

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      final expense = widget.expense!;

      _titleController.text = expense.title;

      _amountController.text =
          expense.amount.toString();

      _noteController.text = expense.note;

      _selectedCategory = expense.category;

      _selectedDate = expense.date;
    }
  }

  // ==========================================
  // SELECT DATE
  // ==========================================

  Future<void> _selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // ==========================================
  // FORMAT DATE
  // ==========================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ==========================================
  // SAVE EXPENSE
  // ==========================================

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final expense = Expense(
        id: widget.expense?.id ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(),

        title: _titleController.text.trim(),

        amount: double.parse(
          _amountController.text.trim(),
        ),

        category: _selectedCategory!,

        date: _selectedDate,

        note: _noteController.text.trim(),
      );

      if (_isEditMode) {
        await _expenseService.updateExpense(
          expense,
        );
      } else {
        await _expenseService.addExpense(
          expense,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Expense updated successfully!'
                : 'Expense added successfully!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to save expense. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        title: Text(
          _isEditMode
              ? 'Edit Expense'
              : 'Add Expense',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            30,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==========================================
                // HEADER
                // ==========================================

                Text(
                  _isEditMode
                      ? 'Update your expense details'
                      : 'Add a new expense',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                ),

                const SizedBox(height: 20),

                // ==========================================
                // TITLE
                // ==========================================

                TextFormField(
                  controller: _titleController,

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText: 'Expense Title',
                    hintText:
                        'e.g. Lunch, Bus fare',

                    prefixIcon: Icon(
                      Icons.title,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter an expense title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==========================================
                // AMOUNT
                // ==========================================

                TextFormField(
                  controller: _amountController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'e.g. 1500.00',

                    prefixIcon: Icon(
                      Icons.payments_outlined,
                    ),

                    prefixText: 'Rs. ',
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }

                    final amount =
                        double.tryParse(
                      value.trim(),
                    );

                    if (amount == null ||
                        amount <= 0) {
                      return 'Please enter a valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==========================================
                // CATEGORY
                // ==========================================

                DropdownButtonFormField<String>(
                  initialValue:
                      _selectedCategory,

                  decoration:
                      const InputDecoration(
                    labelText: 'Category',

                    prefixIcon: Icon(
                      Icons.category_outlined,
                    ),
                  ),

                  items:
                      _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please select a category';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==========================================
                // DATE
                // ==========================================

                InkWell(
                  borderRadius:
                      BorderRadius.circular(12),

                  onTap: _selectDate,

                  child: InputDecorator(
                    decoration:
                        const InputDecoration(
                      labelText: 'Date',

                      prefixIcon: Icon(
                        Icons.calendar_month,
                      ),
                    ),

                    child: Text(
                      _formatDate(
                        _selectedDate,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // NOTE
                // ==========================================

                TextFormField(
                  controller: _noteController,

                  maxLines: 4,

                  textInputAction:
                      TextInputAction.newline,

                  decoration:
                      const InputDecoration(
                    labelText: 'Note (Optional)',
                    hintText:
                        'Enter additional details',

                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: 55,
                      ),
                      child: Icon(
                        Icons.notes_outlined,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==========================================
                // SAVE BUTTON
                // ==========================================

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : _saveExpense,

                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isEditMode
                                ? Icons.save_outlined
                                : Icons.add,
                          ),

                    label: Text(
                      _isLoading
                          ? 'Saving...'
                          : _isEditMode
                              ? 'Update Expense'
                              : 'Add Expense',

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}