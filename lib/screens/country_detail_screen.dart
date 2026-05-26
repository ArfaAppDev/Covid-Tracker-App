// lib/screens/country_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/covid_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/trend_chart.dart';
import '../widgets/error_view.dart';
import '../widgets/shimmer_loader.dart';

class CountryDetailScreen extends StatefulWidget {
  final String countryName;

  const CountryDetailScreen({super.key, required this.countryName});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CovidProvider>().fetchCountryDetail(widget.countryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CovidProvider>(
        builder: (_, provider, __) {
          if (provider.countryDetailState == LoadState.loading) {
            return const _LoadingView();
          }

          if (provider.countryDetailState == LoadState.error) {
            return Scaffold(
              appBar: AppBar(title: Text(widget.countryName)),
              body: ErrorView(
                message: provider.countryDetailError ?? 'Unknown error.',
                onRetry: () => context
                    .read<CovidProvider>()
                    .fetchCountryDetail(widget.countryName),
              ),
            );
          }

          final country = provider.selectedCountry;
          final history = provider.selectedCountryHistory;

          if (country == null) return const SizedBox();

          return CustomScrollView(
            slivers: [
              // Collapsible AppBar
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.textPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: 56,
                    bottom: 16,
                  ),
                  title: Text(
                    country.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.surface, AppTheme.primary],
                          ),
                        ),
                      ),
                      if (country.flagUrl.isNotEmpty)
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Opacity(
                            opacity: 0.12,
                            child: Image.network(
                              country.flagUrl,
                              width: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 60,
                        bottom: 48,
                        child: Row(
                          children: [
                            if (country.flagUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  country.flagUrl,
                                  width: 52,
                                  height: 34,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const SizedBox(),
                                ),
                              ),
                            const SizedBox(width: 10),
                            if (country.continent != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.accent.withOpacity(0.4),
                                  ),
                                ),
                                child: Text(
                                  country.continent!,
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Last updated
                    Text(
                      'Updated ${AppFormatters.formatDate(country.updated)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats grid
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
                          value: AppFormatters.compact(country.cases),
                          todayValue: AppFormatters.compact(country.todayCases),
                          color: AppTheme.accent,
                          icon: Icons.coronavirus_rounded,
                        ),
                        StatCard(
                          label: 'DEATHS',
                          value: AppFormatters.compact(country.deaths),
                          todayValue: AppFormatters.compact(country.todayDeaths),
                          color: AppTheme.danger,
                          icon: Icons.monitor_heart_outlined,
                        ),
                        StatCard(
                          label: 'RECOVERED',
                          value: AppFormatters.compact(country.recovered),
                          todayValue:
                              AppFormatters.compact(country.todayRecovered),
                          color: AppTheme.success,
                          icon: Icons.health_and_safety_outlined,
                        ),
                        StatCard(
                          label: 'ACTIVE',
                          value: AppFormatters.compact(country.active),
                          color: AppTheme.warning,
                          icon: Icons.local_hospital_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'CRITICAL',
                            value: AppFormatters.compact(country.critical),
                            color: AppTheme.critical,
                            icon: Icons.warning_amber_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'TESTS',
                            value: AppFormatters.compact(country.tests),
                            color: AppTheme.textSecondary,
                            icon: Icons.science_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Per million stats
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Per Million Population',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _PerMillionRow(
                              label: 'Cases',
                              value: country.casesPerOneMillion,
                              color: AppTheme.accent,
                            ),
                            _PerMillionRow(
                              label: 'Deaths',
                              value: country.deathsPerOneMillion,
                              color: AppTheme.danger,
                            ),
                            _PerMillionRow(
                              label: 'Tests',
                              value: country.testsPerOneMillion,
                              color: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Population
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
                              'Population',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              AppFormatters.compact(country.population),
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

                    // Historical chart
                    if (history != null) ...[
                      const SizedBox(height: 16),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TrendChart(timeline: history.timeline),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PerMillionRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _PerMillionRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            AppFormatters.compact(value),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ShimmerBox(width: double.infinity, height: 120, borderRadius: 16),
          SizedBox(height: 16),
          ShimmerStatGrid(),
        ],
      ),
    );
  }
}
