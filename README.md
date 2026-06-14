# Teslo Shop

A Flutter e-commerce application for browsing and managing products, backed by a custom REST API. This educational project follows a Clean Architecture approach and showcases token-based authentication, state management with Riverpod, declarative routing with auth guards, form validation with Formz, and image uploads from the camera or gallery.

The backend used by this app lives in a separate repository: [flutter-backend-teslo](https://github.com/Klerith/flutter-backend-teslo), which includes Docker-based installation instructions.

## Demo

## Features

- **Authentication**: Email/password login with token-based sessions, an auth-status splash that decides the initial route, and route guards that protect product screens
- **Product Browsing**: Paginated product grid with infinite scroll, displayed in a masonry layout
- **Product Details**: View a single product's information, sizes, gender, stock, and image gallery
- **Create & Edit Products**: Add a new product or update an existing one through a validated form
- **Image Uploads**: Attach product photos taken with the camera or selected from the gallery
- **Form Validation**: Reactive, typed input validation powered by Formz
- **Local Persistence**: Auth token stored on-device so sessions survive app restarts
- **Clean Architecture**: Domain, infrastructure, and presentation layers with clear separation of concerns

## Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.9.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode / VS Code with Flutter extensions
- A running instance of the [backend REST API](https://github.com/Klerith/flutter-backend-teslo) and its base URL (the repository includes Docker setup instructions)

### Steps

1. Clone the repository:

```bash
git clone https://github.com/jumagu/teslo_shop_app.git
cd teslo_shop_app
```

2. Set up environment variables. Rename the file `.env.template` to `.env` and add your API base URL:

```bash
API_URL=your_api_url
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

### Available Commands

- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build appbundle` - Build Android App Bundle
- `flutter build ios` - Build iOS app (requires macOS)
- `flutter build windows` - Build Windows desktop app
- `flutter test` - Run tests
- `flutter clean` - Clean build artifacts

## Dependencies

- `flutter` - Flutter SDK
- `flutter_riverpod` (3.0.3) - State management solution
- `go_router` (17.0.1) - Declarative routing with auth redirects
- `dio` (5.9.0) - HTTP client for REST API calls
- `formz` (0.8.0) - Typed, reusable form-input validation
- `shared_preferences` (2.5.4) - Local key-value storage for the auth token
- `flutter_dotenv` (6.0.0) - Loads environment variables from `.env`
- `image_picker` (1.2.2) - Picks product images from the camera or gallery
- `flutter_staggered_grid_view` (0.7.0) - Masonry grid layout
- `google_fonts` (6.3.3) - Custom typography (Montserrat Alternates)

## License

This project is part of a Flutter course.
