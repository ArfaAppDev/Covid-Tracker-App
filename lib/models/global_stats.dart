// lib/models/global_stats.dart
class GlobalStats {
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int critical;
  final int casesPerOneMillion;
  final int deathsPerOneMillion;
  final int tests;
  final int testsPerOneMillion;
  final int population;
  final int activePerOneMillion;
  final int recoveredPerOneMillion;
  final int criticalPerOneMillion;
  final String? affectedCountries;

  const GlobalStats({
    required this.updated,
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.todayRecovered,
    required this.active,
    required this.critical,
    required this.casesPerOneMillion,
    required this.deathsPerOneMillion,
    required this.tests,
    required this.testsPerOneMillion,
    required this.population,
    required this.activePerOneMillion,
    required this.recoveredPerOneMillion,
    required this.criticalPerOneMillion,
    this.affectedCountries,
  });

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      updated: (json['updated'] as num?)?.toInt() ?? 0,
      cases: (json['cases'] as num?)?.toInt() ?? 0,
      todayCases: (json['todayCases'] as num?)?.toInt() ?? 0,
      deaths: (json['deaths'] as num?)?.toInt() ?? 0,
      todayDeaths: (json['todayDeaths'] as num?)?.toInt() ?? 0,
      recovered: (json['recovered'] as num?)?.toInt() ?? 0,
      todayRecovered: (json['todayRecovered'] as num?)?.toInt() ?? 0,
      active: (json['active'] as num?)?.toInt() ?? 0,
      critical: (json['critical'] as num?)?.toInt() ?? 0,
      casesPerOneMillion: (json['casesPerOneMillion'] as num?)?.toInt() ?? 0,
      deathsPerOneMillion: (json['deathsPerOneMillion'] as num?)?.toInt() ?? 0,
      tests: (json['tests'] as num?)?.toInt() ?? 0,
      testsPerOneMillion: (json['testsPerOneMillion'] as num?)?.toInt() ?? 0,
      population: (json['population'] as num?)?.toInt() ?? 0,
      activePerOneMillion: (json['activePerOneMillion'] as num?)?.toInt() ?? 0,
      recoveredPerOneMillion:
          (json['recoveredPerOneMillion'] as num?)?.toInt() ?? 0,
      criticalPerOneMillion:
          (json['criticalPerOneMillion'] as num?)?.toInt() ?? 0,
      affectedCountries: json['affectedCountries']?.toString(),
    );
  }

  /// Returns a copy of this [GlobalStats] with given fields replaced.
  GlobalStats copyWith({
    int? updated,
    int? cases,
    int? todayCases,
    int? deaths,
    int? todayDeaths,
    int? recovered,
    int? todayRecovered,
    int? active,
    int? critical,
    int? casesPerOneMillion,
    int? deathsPerOneMillion,
    int? tests,
    int? testsPerOneMillion,
    int? population,
    int? activePerOneMillion,
    int? recoveredPerOneMillion,
    int? criticalPerOneMillion,
    String? affectedCountries,
  }) {
    return GlobalStats(
      updated: updated ?? this.updated,
      cases: cases ?? this.cases,
      todayCases: todayCases ?? this.todayCases,
      deaths: deaths ?? this.deaths,
      todayDeaths: todayDeaths ?? this.todayDeaths,
      recovered: recovered ?? this.recovered,
      todayRecovered: todayRecovered ?? this.todayRecovered,
      active: active ?? this.active,
      critical: critical ?? this.critical,
      casesPerOneMillion: casesPerOneMillion ?? this.casesPerOneMillion,
      deathsPerOneMillion: deathsPerOneMillion ?? this.deathsPerOneMillion,
      tests: tests ?? this.tests,
      testsPerOneMillion: testsPerOneMillion ?? this.testsPerOneMillion,
      population: population ?? this.population,
      activePerOneMillion: activePerOneMillion ?? this.activePerOneMillion,
      recoveredPerOneMillion:
          recoveredPerOneMillion ?? this.recoveredPerOneMillion,
      criticalPerOneMillion:
          criticalPerOneMillion ?? this.criticalPerOneMillion,
      affectedCountries: affectedCountries ?? this.affectedCountries,
    );
  }
}
