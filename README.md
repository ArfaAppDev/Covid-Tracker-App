# 🦠 COVID-19 Tracker — Flutter App

A clean, null-safe Flutter application that fetches live COVID-19 statistics from the [disease.sh](https://disease.sh) REST API (no API key required).

---

## ✨ Features

| Feature | Details |
|---|---|
| 🌍 Global Dashboard | Total cases, deaths, recovered, active, critical, tests |
| 📊 30-Day Trend Charts | Interactive line chart with case/death/recovery toggle |
| 🗺️ Countries List | All countries sorted by cases/deaths/active, searchable |
| 🔍 Country Detail | Per-country stats + historical chart + per-million data |
| 🔄 Pull-to-refresh | Refresh any screen with swipe down |
| ⚡ Shimmer Loading | Skeleton screens while data loads |
| 🚫 Error States | User-friendly offline/error view with retry button |
| 🎨 Dark Theme | Custom dark Material 3 theme |

---

## 📦 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── global_stats.dart          # GlobalStats model (null-safe)
│   ├── country.dart               # Country + CountryInfo models
│   └── historical.dart            # Historical timeline model
├── services/
│   ├── covid_service.dart         # HTTP layer (disease.sh API)
│   └── covid_provider.dart        # ChangeNotifier state manager
├── screens/
│   ├── home_screen.dart           # Bottom nav host
│   ├── dashboard_screen.dart      # Global stats screen
│   ├── countries_screen.dart      # Countries list + search/sort
│   └── country_detail_screen.dart # Country detail + charts
├── widgets/
│   ├── stat_card.dart             # Reusable stat card
│   ├── trend_chart.dart           # fl_chart line chart
│   ├── shimmer_loader.dart        # Shimmer skeletons
│   └── error_view.dart            # Error + retry widget
└── utils/
    └── app_theme.dart             # Theme, colors, formatters
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0 (Dart ≥ 3.0 for full null safety)
- Android Studio / VS Code with Flutter plugin

### Setup

```bash
# 1. Clone or copy the project
cd covid_app

# 2. Install dependencies
flutter pub get

# 3. Run on a device/emulator
flutter run

# 4. Build release APK
flutter build apk --release
```

### Android permissions (already in AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 🌐 API Reference — disease.sh

All endpoints are free, no API key needed:

| Endpoint | Usage |
|---|---|
| `GET /v3/covid-19/all` | Global statistics |
| `GET /v3/covid-19/countries?sort=cases` | All countries sorted |
| `GET /v3/covid-19/countries/{name}` | Single country stats |
| `GET /v3/covid-19/historical/all?lastdays=30` | Global 30-day history |
| `GET /v3/covid-19/historical/{name}?lastdays=30` | Country 30-day history |
| `GET /v3/covid-19/continents` | Continent-level stats |

---

## 📚 Dependencies

```yaml
http: ^1.2.1          # HTTP client
fl_chart: ^0.68.0     # Line/bar/pie charts
shimmer: ^3.0.0       # Loading skeleton effect
intl: ^0.19.0         # Number & date formatting
provider: ^6.1.2      # State management
```

---

## 🏗️ Architecture

- **Models**: Immutable Dart classes with `fromJson` factories, full null safety with `??` defaults
- **Service**: `CovidService` — pure HTTP layer, throws typed `ApiException`
- **Provider**: `CovidProvider extends ChangeNotifier` — three separate load states (global, countries, country detail)
- **UI**: Stateless where possible; `Consumer<CovidProvider>` for reactive rebuilds

---

## 📱 Android Manifest

Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

*Data sourced from [disease.sh](https://disease.sh) — Open Disease Data API.*
