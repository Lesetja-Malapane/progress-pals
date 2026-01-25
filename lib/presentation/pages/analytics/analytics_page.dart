import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/data/datasources/local/database_service.dart';
import 'package:progress_pals/data/models/habit_model.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<HabitModel> _habits = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    try {
      final habits = await _databaseService.getHabits();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userHabits = habits.where((h) => h.userId == userId).toList();
      setState(() => _habits = userHabits);
    } catch (e) {
      Logger().e('Error loading habits: $e');
    }
    setState(() => _isLoading = false);
  }

  HabitModel? _getBestHabitThisWeek() {
    if (_habits.isEmpty) return null;
    return _habits.reduce(
      (a, b) => a.completedCount > b.completedCount ? a : b,
    );
  }

  int _getTotalCompletedThisWeek() {
    return _habits.fold(0, (sum, habit) => sum + habit.completedCount);
  }

  Map<String, int> _getCompletionFrequency() {
    final frequency = <String, int>{};
    for (final habit in _habits) {
      if (habit.lastCompletedDate != null) {
        final dateKey =
            '${habit.lastCompletedDate!.day}/${habit.lastCompletedDate!.month}';
        frequency[dateKey] = (frequency[dateKey] ?? 0) + 1;
      }
    }
    return frequency;
  }

  int _getCompletionPercentage() {
    if (_habits.isEmpty) return 0;
    final totalTarget = _habits.fold<int>(
      0,
      (sum, habit) => sum + habit.repeatPerWeek,
    );
    final totalCompleted = _getTotalCompletedThisWeek();
    return totalTarget > 0 ? ((totalCompleted / totalTarget) * 100).toInt() : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No analytics yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create habits to see analytics',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Completion Percentage
                    _buildStatCard(
                      'Weekly Completion',
                      '${_getCompletionPercentage()}%',
                      AppColors.primary,
                      Icons.trending_up,
                    ),
                    const SizedBox(height: 16),

                    // Total Completed This Week
                    _buildStatCard(
                      'Completed This Week',
                      '${_getTotalCompletedThisWeek()}',
                      Colors.green,
                      Icons.check_circle,
                    ),
                    const SizedBox(height: 24),

                    // Best Habit This Week
                    const Text(
                      'Best Habit This Week',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _getBestHabitThisWeek() != null
                        ? _buildHabitCard(_getBestHabitThisWeek()!)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 24),

                    // All Habits Summary
                    const Text(
                      'All Habits',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._habits
                        .map(
                          (habit) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildHabitProgressCard(habit),
                          ),
                        )
                        .toList(),

                    const SizedBox(height: 24),

                    // Completion Frequency Chart
                    const Text(
                      'Completion Frequency',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFrequencyChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(HabitModel habit) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${habit.completedCount}/${habit.repeatPerWeek} completions',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitProgressCard(HabitModel habit) {
    final progress = habit.repeatPerWeek > 0
        ? (habit.completedCount / habit.repeatPerWeek).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${habit.completedCount}/${habit.repeatPerWeek}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? Colors.green : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyChart() {
    final frequency = _getCompletionFrequency();
    if (frequency.isEmpty) {
      return Center(
        child: Text(
          'No completion data yet',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final maxFrequency = frequency.values.isEmpty
        ? 1
        : frequency.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: frequency.entries.map((entry) {
            final percentage = (entry.value / maxFrequency) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 24,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
