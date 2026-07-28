# HypAuth - Privacy-First Authenticator App

HypAuth is a production-grade, privacy-first, 100% offline Authenticator application built with **Flutter (Dart 3)** following **Clean Architecture** and SOLID principles.

## Features

- 🔐 **100% Offline & Private**: Zero external API calls, zero analytics, zero cloud backends.
- 🔑 **Secure Secret Isolation**: OTP secrets are exclusively encrypted inside `flutter_secure_storage`.
- 📇 **Metadata Database**: Account names, issuers, favorites, and sort orders stored locally via `Isar`.
- ⚡ **RFC6238 Compliant TOTP Engine**:
  - Hash Algorithms: SHA1, SHA256, SHA512.
  - Token Digits: 6-digit & 8-digit.
  - Periods: 30-second & 60-second validity windows.
- 📷 **QR Code Scanner**: Auto-focus, instant parsing, error recovery, and duplicate detection.
- 🛡️ **Biometric Protection**: Face ID, Touch ID, Fingerprint, and device PIN fallback with auto-lock.
- 🎨 **Material 3 UI**: Smooth 60fps animations, dark/light themes, favorite pinning, search filter, and drag & drop reordering.

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App keys and configuration constants
│   ├── errors/          # Custom exceptions and failures
│   ├── router/          # GoRouter configuration
│   ├── services/        # TOTP engine, QR parser, Secure Storage, Database & Biometrics
│   ├── theme/           # Material 3 colors & typography
│   ├── utils/           # Base32 decoding and helpers
│   └── widgets/         # Countdown ring, custom toasts, empty states
├── features/
│   ├── accounts/        # Accounts domain, data (Isar), and presentation
│   ├── auth/            # Biometric unlock feature
│   ├── scanner/         # Camera & QR code parser
│   └── settings/        # App preferences & theme configuration
└── main.dart            # Application entry point & Riverpod provider container
```

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`

### Setup
```bash
flutter pub get
flutter run
```

### Running Tests
```bash
flutter test
```
