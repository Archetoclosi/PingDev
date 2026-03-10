# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ping is a cross-platform chat application built with Flutter (Dart) frontend and Firebase backend. It's an alpha-stage CV/portfolio project targeting iOS, Android, macOS, Windows, Web, and Linux.

## Build & Development Commands

### Flutter (frontend)
```bash
flutter pub get              # Install Dart dependencies
flutter run                  # Run on connected device/emulator
flutter analyze              # Run Dart linting/analysis
flutter test                 # Run tests (minimal coverage currently)
flutter build apk            # Build Android APK
flutter build web            # Build for web
```

### Firebase Cloud Functions (backend)
```bash
cd functions
npm install                  # Install Node.js dependencies
npm run build                # Compile TypeScript → lib/
npm run serve                # Run local emulator
npm run deploy               # Deploy to Firebase
```

## Architecture

### Tech Stack
- **Frontend:** Flutter/Dart (SDK ^3.11.0), Material 3, dark theme
- **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions, FCM)
- **Cloud Functions:** Node.js 20, TypeScript
- **Image hosting:** Cloudinary

### Source Structure
- `lib/screens/` — UI screens (auth, chat list, individual chat)
- `lib/services/` — Business logic layer (auth, chat, cloudinary, changelog)
- `lib/theme/` — Design constants (primary color: `#B77EF1`)
- `lib/widgets/` — Reusable components
- `functions/src/` — Firebase Cloud Functions (TypeScript)

### Service Layer
- **AuthService** — Firebase Auth + Firestore user profiles, persistent login via SharedPreferences
- **ChatService** — All Firestore chat operations (send, stream messages, unread tracking)
- **CloudinaryService** — Image upload to Cloudinary CDN (preset: `chatupload`)
- **ChangelogService** — Version detection from pubspec.yaml, "What's New" display logic

### Firestore Data Model
- **`users/{uid}`** — nickname, email, createdAt, fcmToken
- **`chats/{chatId}`** — participants array, unreadCounts map, lastMessageAt
  - Chat IDs are deterministic: two UIDs sorted lexicographically, joined with `_`
- **`chats/{chatId}/messages/{msgId}`** — text, imageUrl, senderId, type ("text"/"image"), timestamp

### Cloud Function: `onNewMessage`
Triggered on Firestore write to `chats/{chatId}/messages/{messageId}`. Increments recipient unread count, calculates total unread across all chats, sends FCM push notification with sender nickname and message preview.

## Key Patterns

- **State management:** StatefulWidget + StreamBuilder for real-time Firestore data (no Provider/Riverpod)
- **Navigation:** Named routes defined in `main.dart`
- **Async:** async/await for futures, StreamBuilder for subscriptions
- **UI:** Glassmorphism design with BackdropFilter, dark theme (`#1A1A2E` background)
- **Naming:** PascalCase classes, camelCase methods, underscore-prefixed privates

## Firebase Project
- Project ID: `pingcv` (configured in `.firebaserc`)
- Platform configs in `lib/firebase_options.dart`
