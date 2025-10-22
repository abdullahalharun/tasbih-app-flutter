# Firebase Setup Instructions

⚠️ **IMPORTANT**: Firebase configuration files are NOT included in this repository for security reasons.

## Setup Steps

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Add your app for each platform (iOS, Android, Web, etc.)

### 2. Download Configuration Files

#### For Android:

1. Download `google-services.json` from Firebase Console
2. Place it at: `android/app/google-services.json`

#### For iOS:

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it at: `ios/Runner/GoogleService-Info.plist`

#### For macOS:

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it at: `macos/Runner/GoogleService-Info.plist`

### 3. Generate firebase_options.dart

Run the FlutterFire CLI to generate the configuration:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will generate `lib/firebase_options.dart` with your Firebase credentials.

### 4. Verify Setup

Make sure these files exist and are in `.gitignore`:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

## Security Note

Never commit these files to version control as they contain sensitive API keys.
