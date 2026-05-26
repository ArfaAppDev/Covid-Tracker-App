// lib/services/covid_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/global_stats.dart';
import '../models/country.dart';
import '../models/historical.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class CovidService {
  static const String _baseUrl = 'https://disease.sh/v3/covid-19';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  CovidService({http.Client? client}) : _client = client ?? http.Client();

  // ─── Global Stats ────────────────────────────────────────────────────────────

  Future<GlobalStats> fetchGlobalStats() async {
    final uri = Uri.parse('$_baseUrl/all');
    final data = await _getJson(uri);
    return GlobalStats.fromJson(data);
  }

  // ─── All Countries ───────────────────────────────────────────────────────────

  Future<List<Country>> fetchAllCountries({
    String sortBy = 'cases',
  }) async {
    final uri = Uri.parse('$_baseUrl/countries?sort=$sortBy&yesterday=false');
    final data = await _getJson(uri);

    if (data is! List) {
      throw const ApiException('Expected a list of countries');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(Country.fromJson)
        .toList();
  }

  // ─── Single Country ──────────────────────────────────────────────────────────

  Future<Country> fetchCountry(String countryName) async {
    final uri = Uri.parse('$_baseUrl/countries/$countryName');
    final data = await _getJson(uri);
    return Country.fromJson(data);
  }

  // ─── Historical (Global) ─────────────────────────────────────────────────────

  Future<Historical> fetchGlobalHistorical({int lastDays = 30}) async {
    final uri = Uri.parse('$_baseUrl/historical/all?lastdays=$lastDays');
    final data = await _getJson(uri);
    // Global historical wraps timeline at top level
    return Historical(
      country: 'Global',
      timeline: HistoricalTimeline.fromJson(data),
    );
  }

  // ─── Historical (Country) ────────────────────────────────────────────────────

  Future<Historical> fetchCountryHistorical(
    String countryName, {
    int lastDays = 30,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/historical/$countryName?lastdays=$lastDays',
    );
    final data = await _getJson(uri);
    return Historical.fromJson(data);
  }

  // ─── Continents ──────────────────────────────────────────────────────────────

  Future<List<Country>> fetchContinents() async {
    final uri = Uri.parse('$_baseUrl/continents');
    final data = await _getJson(uri);

    if (data is! List) {
      throw const ApiException('Expected a list of continents');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(Country.fromJson)
        .toList();
  }

  // ─── Private helper ──────────────────────────────────────────────────────────

  Future<dynamic> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const ApiException(
        'No internet connection. Check your network settings.',
      );
    } on HttpException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException {
      throw const ApiException('Invalid response format from server.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  void dispose() => _client.close();
}
