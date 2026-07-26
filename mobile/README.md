# Nivaas Mobile Application

A mobile-first, accessible, offline-ready Society Management Application built specifically for Indian Housing Societies.

---

## 🏛️ Architecture Overview

The application follows **Feature-First Clean Architecture** combined with **Flutter Riverpod** for state management and **Isar (SQLite)** for on-device reactive storage.

```
lib/
├── main.dart
├── app/
│   ├── app.dart                   # Root MaterialApp with GoRouter & Theme
│   ├── config/
│   │   ├── app_config.dart        # Global app settings container
│   │   ├── env_config.dart        # Environment settings (Dev, Staging, Prod)
│   │   ├── routes/                # GoRouter declarative routes & route names
│   │   └── theme/                 # Material 3 design system tokens & themes
│   ├── observers/                 # Navigation & logging observers
│   └── providers/                 # Project-wide Riverpod state providers
├── core/
│   ├── constants/                 # API, App, Asset, Storage, Validation constants
│   ├── error/                     # Exceptions, Failures, Global Error Handler
│   ├── localization/              # AppLocalizations infrastructure (en, hi, mr, gu)
│   ├── logging/                   # Structured LoggerService abstraction
│   ├── network/                   # Dio ApiClient, Interceptors, ErrorMapper, NetworkInfo
│   ├── offline/                   # IsarDatabaseService, Outbox Queue, Sync interfaces
│   ├── permissions/               # PermissionService (Camera, Storage, SMS, Location)
│   ├── security/                  # SecureStorageService, TokenManager, Pinning hooks
│   ├── services/                  # AppLifecycleService, ConnectivityService
│   └── utils/                     # Formatters, Validators, Debouncer, Throttler, Extensions
├── shared/
│   ├── models/                    # ApiResponse envelope, UserRole
│   ├── repositories/              # BaseRepository with guard wrappers
│   └── widgets/                   # AppScaffold, PlaceholderView
└── features/                      # Modular Business Features
    ├── auth/
    ├── visitor/
    ├── billing/
    └── helpdesk/
```

---

## 🚀 Environment Configuration

Support for 3 environments without hardcoded URLs:

- **Development**: `EnvConfig.development()` -> `https://dev-api.nivaas.app/api/v1`
- **Staging**: `EnvConfig.staging()` -> `https://staging-api.nivaas.app/api/v1`
- **Production**: `EnvConfig.production()` -> `https://api.nivaas.app/api/v1`

---

## 💻 How to Run & Test

```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run unit & widget tests
flutter test

# Run application
flutter run
```

---

## 🎨 Design System Alignment

All tokens in `lib/app/config/theme/` strictly align with `DESIGN_SYSTEM.md`:
- Primary Brand: `#1A73E8` (Google Blue)
- Success / Approved: `#188038` (Deep Green)
- Alert / Deny / SOS: `#D93025` (Deep Red)
- 8pt Grid Spacing (`xs: 4`, `s: 8`, `m: 16`, `l: 24`, `xl: 32`)
- Minimum Touch Target Area: **48x48 dp**
