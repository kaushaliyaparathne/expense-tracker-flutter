import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import 'add_expense_screen.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() =>
      _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState
    extends State<ExpenseHistoryScreen> {
  final ExpenseService _expenseService =
      ExpenseService();

  // ==========================================
  // FILTER VALUES
  // ==========================================

  String _selectedCategory = 'All';

  DateTime? _selectedDate;

  final List<String> _categories = [
    'All',
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
  // FORMAT AMOUNT
  // ==========================================

  String _formatAmount(double amount) {
    return 'Rs. ${amount.toStringAsFixed(2)}';
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
  // CATEGORY ICON
  // ==========================================

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;

      case 'Transport':
        return Icons.directions_bus;

      case 'Shopping':
        return Icons.shopping_bag;

      case 'Bills':
        return Icons.receipt_long;

      case 'Health':
        return Icons.health_and_safety;

      case 'Education':
        return Icons.school;

      case 'Entertainment':
        return Icons.movie;

      case 'Other':
        return Icons.category;

      default:
        return Icons.category;
    }
  }

  // ==========================================
  // SELECT DATE
  // ==========================================

  Future<void> _selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now(),
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
  // CLEAR DATE
  // ==========================================

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  // ==========================================
  // SAME DATE
  // ==========================================

  bool _isSameDate(
    DateTime date1,
    DateTime date2,
  ) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // ==========================================
  // FILTER EXPENSES
  // ==========================================

  List<Expense> _filterExpenses(
    List<Expense> expenses,
  ) {
    return expenses.where((expense) {
      if (_selectedCategory != 'All' &&
          expense.category != _selectedCategory) {
        return false;
      }

      if (_selectedDate != null) {
        if (!_isSameDate(
          expense.date,
          _selectedDate!,
        )) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // ==========================================
  // DELETE EXPENSE
  // ==========================================

  Future<void> _deleteExpense(
    Expense expense,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_outline,
            size: 40,
            color: Theme.of(context)
                .colorScheme
                .error,
          ),

          title: const Text(
            'Delete Expense?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'Are you sure you want to delete '
            '"${expense.title}"?',
            textAlign: TextAlign.center,
          ),

          actionsAlignment:
              MainAxisAlignment.center,

          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            const SizedBox(width: 8),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _expenseService.deleteExpense(
        expense.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Expense deleted successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to delete expense.',
          ),
        ),
      );
    }
  }

  // ==========================================
  // EDIT EXPENSE
  // ==========================================

  Future<void> _editExpense(
    Expense expense,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddExpenseScreen(
          expense: expense,
        ),
      ),
    );
  }

  // ==========================================
  // LOADING STATE
  // ==========================================

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),

          SizedBox(height: 16),

          Text(
            'Loading expenses...',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ERROR STATE
  // ==========================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Theme.of(context)
                  .colorScheme
                  .error,
            ),

            const SizedBox(height: 16),

            const Text(
              'Something went wrong.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Please try again.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE
  // ==========================================

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
            ),

            SizedBox(height: 20),

            Text(
              'No expenses yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Start tracking your expenses today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // FILTER SECTION
  // ==========================================

  Widget _buildFilterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),

                const SizedBox(width: 8),

                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,

              decoration:
                  const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),

              items: _categories.map(
                (category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,

                    icon: const Icon(
                      Icons.calendar_month,
                    ),

                    label: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : _formatDate(
                              _selectedDate!,
                            ),
                      overflow:
                          TextOverflow.ellipsis,
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(
                        double.infinity,
                        52,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                if (_selectedDate != null) ...[
                  const SizedBox(width: 8),

                  IconButton(
                    tooltip: 'Clear Date',
                    onPressed:
                        _clearDateFilter,
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EXPENSE CARD
  // ==========================================

  Widget _buildExpenseCard(
    Expense expense,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),

          leading: CircleAvatar(
            child: Icon(
              _getCategoryIcon(
                expense.category,
              ),
            ),
          ),

          title: Text(
            expense.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Padding(
            padding:
                const EdgeInsets.only(top: 4),
            child: Text(
              '${expense.category} • '
              '${_formatDate(expense.date)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAmount(
                      expense.amount,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),

              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                ),
                tooltip: 'Edit',
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                onPressed: () {
                  _editExpense(expense);
                },
              ),

              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                ),
                tooltip: 'Delete',
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                onPressed: () {
                  _deleteExpense(expense);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),

        builder: (context, snapshot) {
          // ==========================================
          // LOADING
          // ==========================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // ==========================================
          // ERROR
          // ==========================================

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          // ==========================================
          // ALL EXPENSES
          // ==========================================

          final allExpenses =
              snapshot.data ?? [];

          // ==========================================
          // EMPTY
          // ==========================================

          if (allExpenses.isEmpty) {
            return _buildEmptyState();
          }

          // ==========================================
          // FILTER
          // ==========================================

          final filteredExpenses =
              _filterExpenses(
            allExpenses,
          );

          // ==========================================
          // MAIN UI
          // ==========================================

          return Column(
            children: [
              // FILTERS
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  12,
                  8,
                  12,
                  0,
                ),
                child: _buildFilterSection(),
              ),

              // RESULT COUNT
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      '${filteredExpenses.length} '
                      'expense(s) found',
                      style: TextStyle(
                        color:
                            Colors.grey.shade700,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // FILTERED EMPTY / LIST
              // ==========================================

              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 55,
                              ),

                              SizedBox(height: 16),

                              Text(
                                'No expenses found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                'Try changing your filters.',
                                textAlign:
                                    TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics:
                            const AlwaysScrollableScrollPhysics(),

                        padding:
                            const EdgeInsets.fromLTRB(
                          12,
                          4,
                          12,
                          100,
                        ),

                        itemCount:
                            filteredExpenses.length,

                        itemBuilder:
                            (context, index) {
                          final expense =
                              filteredExpenses[
                                  index];

                          return _buildExpenseCard(
                            expense,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}