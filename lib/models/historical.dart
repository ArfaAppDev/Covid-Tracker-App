// lib/models/historical.dart
class HistoricalTimeline {
  final Map<String, int> cases;
  final Map<String, int> deaths;
  final Map<String, int> recovered;

  const HistoricalTimeline({
    required this.cases,
    required this.deaths,
    required this.recovered,
  });

  factory HistoricalTimeline.fromJson(Map<String, dynamic> json) {
    Map<String, int> parseTimeline(dynamic raw) {
      if (raw == null || raw is! Map) return {};
      return (raw as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
      );
    }

    return HistoricalTimeline(
      cases: parseTimeline(json['cases']),
      deaths: parseTimeline(json['deaths']),
      recovered: parseTimeline(json['recovered']),
    );
  }
}

class Historical {
  final String? country;
  final List<String>? provinces;
  final HistoricalTimeline timeline;

  const Historical({
    this.country,
    this.provinces,
    required this.timeline,
  });

  factory Historical.fromJson(Map<String, dynamic> json) {
    return Historical(
      country: json['country'] as String?,
      provinces: (json['province'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      timeline: HistoricalTimeline.fromJson(
        json['timeline'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
