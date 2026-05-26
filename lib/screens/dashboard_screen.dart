// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/covid_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/trend_chart.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/error_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CovidProvider>().fetchGlobalData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accent,
          backgroundColor: AppTheme.cardBg,
          onRefresh: () => context.read<CovidProvider>().fetchGlobalData(),
          child: Consumer<CovidProvider>(
            builder: (_, provider, __) {
              if (provider.globalState == LoadState.loading) {
                return const _LoadingView();
              }

              if (provider.globalState == LoadState.error) {
                return ErrorView(
                  message: provider.globalError ?? 'Unknown error occurred.',
                  onRetry: () => context.read<CovidProvider>().fetchGlobalData(),
                );
              }

              final stats = provider.globalStats;
              final historical = provider.globalHistorical;

              if (stats == null) {
                return const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Global Overview',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Updated ${AppFormatters.formatDate(stats.updated)}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.public_rounded,
                          color: AppTheme.accent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stat grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatCard(
                        label: 'TOTAL CASES',
                        value: AppFormatters.compact(stats.cases),
                        todayValue: AppFormatters.compact(stats.todayCases),
                        color: AppTheme.accent,
                        icon: Icons.coronavirus_rounded,
                      ),
                      StatCard(
                        label: 'DEATHS',
                        value: AppFormatters.compact(stats.deaths),
                        todayValue: AppFormatters.compact(stats.todayDeaths),
                        color: AppTheme.danger,
                        icon: Icons.monitor_heart_outlined,
                      ),
                      StatCard(
                        label: 'RECOVERED',
                        value: AppFormatters.compact(stats.recovered),
                        todayValue: AppFormatters.compact(stats.todayRecovered),
                        color: AppTheme.success,
                        icon: Icons.health_and_safety_outlined,
                      ),
                      StatCard(
                        label: 'ACTIVE',
                        value: AppFormatters.compact(stats.active),
                        color: AppTheme.warning,
                        icon: Icons.local_hospital_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Critical & Tests row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'CRITICAL',
                          value: AppFormatters.compact(stats.critical),
                          color: AppTheme.critical,
                          icon: Icons.warning_amber_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'TESTS',
                          value: AppFormatters.compact(stats.tests),
                          color: AppTheme.textSecondary,
                          icon: Icons.science_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Recovery rate
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recovery Rate',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: stats.cases > 0
                                  ? stats.recovered / stats.cases
                                  : 0,
                              minHeight: 10,
                              backgroundColor: AppTheme.surface,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.success,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppFormatters.percentOf(
                                  stats.recovered,
                                  stats.cases,
                                ),
                                style: const TextStyle(
                                  color: AppTheme.success,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Mortality: ${AppFormatters.percentOf(stats.deaths, stats.cases)}',
                                style: const TextStyle(
                                  color: AppTheme.danger,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trend Chart
                  if (historical != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '30-Day Trend',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TrendChart(timeline: historical.timeline),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Population info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            color: AppTheme.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'World Population',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            AppFormatters.compact(stats.population),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerBox(width: 200, height: 28),
        SizedBox(height: 6),
        ShimmerBox(width: 160, height: 12),
        SizedBox(height: 20),
        ShimmerStatGrid(),
      ],
    );
  }
}
