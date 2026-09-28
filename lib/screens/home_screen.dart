import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import 'add_expense_screen.dart';
import 'expense_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseService _expenseService = ExpenseService();

  // ==========================================
  // GET MONTH NAME
  // ==========================================

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  // ==========================================
  // FORMAT AMOUNT
  // ==========================================

  String _formatAmount(double amount) {
    return 'Rs. ${amount.toStringAsFixed(2)}';
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
  // CATEGORY PIE CHART
  // ==========================================

  Widget _buildCategoryPieChart(
    Map<String, double> categoryTotals,
  ) {
    final total = categoryTotals.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    if (total == 0) {
      return const SizedBox.shrink();
    }

    final sections = categoryTotals.entries.map(
      (entry) {
        final percentage = (entry.value / total) * 100;

        return PieChartSectionData(
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    ).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Expense Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 45,
                  sectionsSpace: 2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ...categoryTotals.entries.map(
              (entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        child: Icon(
                          _getCategoryIcon(entry.key),
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Text(
                        _formatAmount(entry.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
        mainAxisAlignment: MainAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(
                fontSize: 14,
              ),
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
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 150),

          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
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
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOTAL EXPENSE CARD
  // ==========================================

  Widget _buildTotalExpenseCard(
    BuildContext context,
    double totalExpenses,
    DateTime now,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  child: const Icon(
                    Icons.account_balance_wallet,
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Expenses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${_getMonthName(now.month)} ${now.year}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              _formatAmount(totalExpenses),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CATEGORY SUMMARY
  // ==========================================

  Widget _buildCategorySummary(
    Map<String, double> categoryTotals,
  ) {
    return Card(
      child: Column(
        children: categoryTotals.entries.map(
          (entry) {
            return ListTile(
              leading: CircleAvatar(
                child: Icon(
                  _getCategoryIcon(entry.key),
                ),
              ),

              title: Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: Text(
                _formatAmount(entry.value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ==========================================
  // RECENT EXPENSE CARD
  // ==========================================

  Widget _buildExpenseCard(Expense expense) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),

        leading: CircleAvatar(
          child: Icon(
            _getCategoryIcon(expense.category),
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

        subtitle: Text(
          expense.category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: Text(
          _formatAmount(expense.amount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
    final now = DateTime.now();

    return Scaffold(
      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Expense History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ExpenseHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // ==========================================
      // BODY
      // ==========================================

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
          // CURRENT MONTH EXPENSES
          // ==========================================

          final currentMonthExpenses =
              allExpenses.where((expense) {
            return expense.date.year == now.year &&
                expense.date.month == now.month;
          }).toList();

          // ==========================================
          // TOTAL
          // ==========================================

          double totalExpenses = 0.0;

          for (final expense
              in currentMonthExpenses) {
            totalExpenses += expense.amount;
          }

          // ==========================================
          // CATEGORY TOTALS
          // ==========================================

          final Map<String, double> categoryTotals =
              {};

          for (final expense
              in currentMonthExpenses) {
            categoryTotals[expense.category] =
                (categoryTotals[expense.category] ?? 0) +
                    expense.amount;
          }

          // ==========================================
          // MAIN UI
          // ==========================================

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },

            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                100,
              ),

              children: [
                // ==========================================
                // MONTH
                // ==========================================

                Text(
                  '${_getMonthName(now.month)} ${now.year}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                ),

                const SizedBox(height: 12),

                // ==========================================
                // TOTAL EXPENSES
                // ==========================================

                _buildTotalExpenseCard(
                  context,
                  totalExpenses,
                  now,
                ),

                const SizedBox(height: 24),

                // ==========================================
                // CATEGORY SUMMARY TITLE
                // ==========================================

                Text(
                  'Category Summary',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                // ==========================================
                // CATEGORY SUMMARY
                // ==========================================

                if (categoryTotals.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'No expenses this month.',
                        ),
                      ),
                    ),
                  )
                else
                  _buildCategorySummary(
                    categoryTotals,
                  ),

                // ==========================================
                // PIE CHART
                // ==========================================

                if (categoryTotals.isNotEmpty) ...[
                  const SizedBox(height: 18),

                  _buildCategoryPieChart(
                    categoryTotals,
                  ),
                ],

                const SizedBox(height: 24),

                // ==========================================
                // RECENT EXPENSES TITLE
                // ==========================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ExpenseHistoryScreen(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ==========================================
                // CURRENT MONTH EMPTY
                // ==========================================

                if (currentMonthExpenses.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'No expenses this month.',
                        ),
                      ),
                    ),
                  )

                // ==========================================
                // EXPENSE LIST
                // ==========================================

                else
                  ...currentMonthExpenses
                      .take(10)
                      .map(
                        (expense) =>
                            _buildExpenseCard(expense),
                      ),
              ],
            ),
          );
        },
      ),

      // ==========================================
      // ADD EXPENSE BUTTON
      // ==========================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}