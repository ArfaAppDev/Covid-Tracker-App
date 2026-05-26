// lib/screens/countries_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/covid_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/error_view.dart';
import 'country_detail_screen.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CovidProvider>();
      if (provider.countriesState == LoadState.idle) {
        provider.fetchCountries();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const _sortOptions = {
    'cases': 'Total Cases',
    'deaths': 'Deaths',
    'recovered': 'Recovered',
    'active': 'Active',
    'tests': 'Tests',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Countries',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Search country...',
                            prefixIcon: Icon(Icons.search_rounded, size: 18),
                          ),
                          onChanged: (v) =>
                              context.read<CovidProvider>().setSearchQuery(v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _SortButton(options: _sortOptions),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Country list
            Expanded(
              child: Consumer<CovidProvider>(
                builder: (_, provider, __) {
                  if (provider.countriesState == LoadState.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ShimmerCountryList(),
                    );
                  }

                  if (provider.countriesState == LoadState.error) {
                    return ErrorView(
                      message:
                          provider.countriesError ?? 'Unknown error occurred.',
                      onRetry: () =>
                          context.read<CovidProvider>().fetchCountries(),
                    );
                  }

                  final countries = provider.countries;

                  if (countries.isEmpty) {
                    return const Center(
                      child: Text(
                        'No countries found.',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.accent,
                    backgroundColor: AppTheme.cardBg,
                    onRefresh: () =>
                        context.read<CovidProvider>().fetchCountries(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      itemCount: countries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final country = countries[i];
                        return _CountryTile(
                          rank: i + 1,
                          country: country,
                          onTap: () {
                            Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => CountryDetailScreen(
                                  countryName: country.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  final int rank;
  final dynamic country;
  final VoidCallback onTap;

  const _CountryTile({
    required this.rank,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 28,
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Flag
              _Flag(url: country.flagUrl),
              const SizedBox(width: 10),
              // Name & cases
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppFormatters.compact(country.active)} active',
                      style: const TextStyle(
                        color: AppTheme.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Cases
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppFormatters.compact(country.cases),
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${AppFormatters.compact(country.deaths)} deaths',
                    style: const TextStyle(
                      color: AppTheme.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final String url;
  const _Flag({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        width: 36,
        height: 24,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.flag_rounded, color: AppTheme.textSecondary, size: 14),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        url,
        width: 36,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 36,
          height: 24,
          color: AppTheme.surface,
          child: const Icon(Icons.flag_rounded, color: AppTheme.textSecondary, size: 14),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final Map<String, String> options;
  const _SortButton({required this.options});

  @override
  Widget build(BuildContext context) {
    return Consumer<CovidProvider>(
      builder: (_, provider, __) => PopupMenuButton<String>(
        color: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: provider.setSortBy,
        itemBuilder: (_) => options.entries
            .map(
              (e) => PopupMenuItem(
                value: e.key,
                child: Row(
                  children: [
                    Icon(
                      e.key == provider.sortBy
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: e.key == provider.sortBy
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.value,
                      style: TextStyle(
                        color: e.key == provider.sortBy
                            ? AppTheme.accent
                            : AppTheme.textPrimary,
                        fontWeight: e.key == provider.sortBy
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.sort_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
