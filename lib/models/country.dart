// lib/models/country.dart
class CountryInfo {
  final int? id;
  final String? iso2;
  final String? iso3;
  final double? lat;
  final double? long;
  final String? flag;

  const CountryInfo({
    this.id,
    this.iso2,
    this.iso3,
    this.lat,
    this.long,
    this.flag,
  });

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
      id: (json['_id'] as num?)?.toInt(),
      iso2: json['iso2'] as String?,
      iso3: json['iso3'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      flag: json['flag'] as String?,
    );
  }
}

class Country {
  final String name;
  final CountryInfo? countryInfo;
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
  final String? continent;
  final int? activePerOneMillion;
  final int? recoveredPerOneMillion;
  final int? criticalPerOneMillion;
  final int updated;

  const Country({
    required this.name,
    this.countryInfo,
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
    this.continent,
    this.activePerOneMillion,
    this.recoveredPerOneMillion,
    this.criticalPerOneMillion,
    required this.updated,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['country'] as String? ?? 'Unknown',
      countryInfo: json['countryInfo'] != null
          ? CountryInfo.fromJson(json['countryInfo'] as Map<String, dynamic>)
          : null,
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
      continent: json['continent'] as String?,
      activePerOneMillion: (json['activePerOneMillion'] as num?)?.toInt(),
      recoveredPerOneMillion:
          (json['recoveredPerOneMillion'] as num?)?.toInt(),
      criticalPerOneMillion: (json['criticalPerOneMillion'] as num?)?.toInt(),
      updated: (json['updated'] as num?)?.toInt() ?? 0,
    );
  }

  String get flagUrl => countryInfo?.flag ?? '';
}
