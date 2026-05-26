// lib/services/covid_provider.dart
import 'package:flutter/foundation.dart';
import '../models/global_stats.dart';
import '../models/country.dart';
import '../models/historical.dart';
import 'covid_service.dart';

enum LoadState { idle, loading, success, error }

class CovidProvider extends ChangeNotifier {
  final CovidService _service;

  CovidProvider({CovidService? service})
      : _service = service ?? CovidService();

  // ─── Global ───────────────────────────────────────────────────────────────
  LoadState _globalState = LoadState.idle;
  GlobalStats? _globalStats;
  Historical? _globalHistorical;
  String? _globalError;

  LoadState get globalState => _globalState;
  GlobalStats? get globalStats => _globalStats;
  Historical? get globalHistorical => _globalHistorical;
  String? get globalError => _globalError;

  // ─── Countries ────────────────────────────────────────────────────────────
  LoadState _countriesState = LoadState.idle;
  List<Country> _countries = [];
  String? _countriesError;
  String _searchQuery = '';
  String _sortBy = 'cases';

  LoadState get countriesState => _countriesState;
  String? get countriesError => _countriesError;
  String get sortBy => _sortBy;

  List<Country> get countries {
    if (_searchQuery.isEmpty) return _countries;
    final query = _searchQuery.toLowerCase();
    return _countries
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();
  }

  // ─── Selected Country ─────────────────────────────────────────────────────
  LoadState _countryDetailState = LoadState.idle;
  Country? _selectedCountry;
  Historical? _selectedCountryHistory;
  String? _countryDetailError;

  LoadState get countryDetailState => _countryDetailState;
  Country? get selectedCountry => _selectedCountry;
  Historical? get selectedCountryHistory => _selectedCountryHistory;
  String? get countryDetailError => _countryDetailError;

  // ─── Actions ──────────────────────────────────────────────────────────────

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    fetchCountries(sortBy: sort);
  }

  Future<void> fetchGlobalData({bool silent = false}) async {
    if (!silent) {
      _globalState = LoadState.loading;
      _globalError = null;
      notifyListeners();
    }

    try {
      final results = await Future.wait([
        _service.fetchGlobalStats(),
        _service.fetchGlobalHistorical(lastDays: 30),
      ]);

      _globalStats = results[0] as GlobalStats;
      _globalHistorical = results[1] as Historical;
      _globalState = LoadState.success;
    } on ApiException catch (e) {
      _globalError = e.message;
      _globalState = LoadState.error;
    } catch (e) {
      _globalError = 'Unexpected error: $e';
      _globalState = LoadState.error;
    }

    notifyListeners();
  }

  Future<void> fetchCountries({String sortBy = 'cases'}) async {
    _countriesState = LoadState.loading;
    _countriesError = null;
    notifyListeners();

    try {
      _countries = await _service.fetchAllCountries(sortBy: sortBy);
      _countriesState = LoadState.success;
    } on ApiException catch (e) {
      _countriesError = e.message;
      _countriesState = LoadState.error;
    } catch (e) {
      _countriesError = 'Unexpected error: $e';
      _countriesState = LoadState.error;
    }

    notifyListeners();
  }

  Future<void> fetchCountryDetail(String countryName) async {
    _countryDetailState = LoadState.loading;
    _countryDetailError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchCountry(countryName),
        _service.fetchCountryHistorical(countryName, lastDays: 30),
      ]);

      _selectedCountry = results[0] as Country;
      _selectedCountryHistory = results[1] as Historical;
      _countryDetailState = LoadState.success;
    } on ApiException catch (e) {
      _countryDetailError = e.message;
      _countryDetailState = LoadState.error;
    } catch (e) {
      _countryDetailError = 'Unexpected error: $e';
      _countryDetailState = LoadState.error;
    }

    notifyListeners();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      fetchGlobalData(silent: false),
      fetchCountries(sortBy: _sortBy),
    ]);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
