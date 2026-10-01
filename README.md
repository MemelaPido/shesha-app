# Shesha Phase 1

Production-structured Flutter prototype implementing:

- Splash
- Login
- Register
- Dashboard
- Named routes
- Provider-based session state
- Reusable widgets
- API-ready service abstraction

## Create iOS and Android platform folders

From this project directory run:

```bash
flutter create . --platforms=android,ios
flutter pub get
flutter run
```

On Windows or Linux, Flutter can generate the iOS folder, but building and signing the iOS app requires macOS with Xcode.

## Demo behavior

- Splash automatically opens Login.
- Sign in accepts any non-empty cellphone and password.
- Create account stores the entered name in Provider and opens Dashboard.
- Sign out clears the mock session and returns to Login.

The mock `AuthService` can later be replaced by calls to the Shesha PHP REST API.
