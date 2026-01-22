import 'package:flutter/material.dart';

/// Reusable Empty State widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor ?? Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for no goals
class EmptyGoalsState extends StatelessWidget {
  final VoidCallback? onAddGoal;

  const EmptyGoalsState({super.key, this.onAddGoal});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.flag_outlined,
      title: 'No learning goals yet',
      message: 'Set goals to track your learning journey and stay motivated',
      actionLabel: 'Add Your First Goal',
      onAction: onAddGoal,
      iconColor: Colors.blue,
    );
  }
}

/// Empty state for no schedule
class EmptyScheduleState extends StatelessWidget {
  final VoidCallback? onGeneratePlan;

  const EmptyScheduleState({super.key, this.onGeneratePlan});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.calendar_today_outlined,
      title: 'No plan for today',
      message: 'Generate a personalized daily plan based on your goals and schedule',
      actionLabel: 'Generate Plan',
      onAction: onGeneratePlan,
      iconColor: Colors.purple,
    );
  }
}

/// Empty state for no opportunities
class EmptyOpportunitiesState extends StatelessWidget {
  final VoidCallback? onAddOpportunity;

  const EmptyOpportunitiesState({super.key, this.onAddOpportunity});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.explore_outlined,
      title: 'No opportunities yet',
      message: 'Add internships, hackathons, scholarships, and more to track',
      actionLabel: 'Add Opportunity',
      onAction: onAddOpportunity,
      iconColor: Colors.green,
    );
  }
}

/// Empty state for search results
class EmptySearchState extends StatelessWidget {
  final String searchQuery;

  const EmptySearchState({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No results found',
      message: 'Try adjusting your search or filters to find what you\'re looking for',
    );
  }
}

/// Empty state for filtered results
class EmptyFilterState extends StatelessWidget {
  final VoidCallback? onClearFilters;

  const EmptyFilterState({super.key, this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.filter_list_off,
      title: 'No items match your filters',
      message: 'Try adjusting or clearing your filters',
      actionLabel: 'Clear Filters',
      onAction: onClearFilters,
    );
  }
}

/// Loading state with animation
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success state with animation
class SuccessState extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onDone;

  const SuccessState({
    super.key,
    required this.title,
    this.message,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onDone != null) ...[
              const SizedBox(height: 32),
              FilledButton(
                onPressed: onDone,
                child: const Text('Done'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// No internet connection state
class NoInternetState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'No internet connection',
      message: 'Please check your connection and try again',
      actionLabel: 'Retry',
      onAction: onRetry,
      iconColor: Colors.orange,
    );
  }
}