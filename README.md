# Riverpod MVVM Architecture

A Flutter project demonstrating a clean, scalable architecture using **Riverpod** for state management and **MVVM** as the primary design pattern.

## 🏗️ Project Structure

The project is organized into a modular structure under `lib/src/` to ensure high maintainability and separation of concerns.

### 📂 `lib/src/core/`
Contains the bedrock of the application that remains constant across features.
- **`theme/`**: App-wide styling, colors, and asset path helpers.
- **`constants/`**: Fixed values, API endpoints, and configuration keys.
- **`ext/`**: Dart extensions for commonly used classes.

### 📂 `lib/src/common/`
Shared logic and UI components used throughout the app.
- **`widgets/`**: Reusable UI components (Buttons, Loaders, Skeletons).
- **`services/`**: Low-level infrastructure services (Storage, Connectivity).
- **`patterns/`**: Implementation of common patterns like `Result` and `AppState`.
- **`state_management/`**: Base classes and utilities for ViewModels.
- **`dependency_injectors/`**: Riverpod providers for global services.

### 📂 `lib/src/features/`
Feature-based modules. Each feature follows the MVVM pattern internally.
- **`auth/`**: Authentication logic, Login screens, and User profile management.
- **`home/`**: Primary application dashboard and main navigation.
- **`settings/`**: User preferences, theme switching, and app configuration.

Each feature typically contains:
- `models/`: Data structures.
- `views/`: UI layer (Widgets/Screens).
- `view_models/`: Business logic and state handling.
- `repositories/`: Data abstraction layer.
- `routes/`: Feature-specific route definitions.

### 📂 `lib/src/routes/`
Centralized navigation management using `GoRouter`.

---

## 🛠️ Key Technologies

- **State Management**: [Riverpod](https://riverpod.dev/) (Functional & Class-based providers).
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom interceptors for:
  - **Connectivity Checking**: Aborts requests if no internet is detected.
  - **Auth Interceptors**: Handles Bearer tokens and automatic token refreshing.
  - **Error Mapping**: Status codes mapped to typed enums (`HttpError`).
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) for declarative routing.
- **Local Storage**: [Shared Preferences](https://pub.dev/packages/shared_preferences).

## 🧩 Architectural Flow

1.  **View** watches a **ViewModel** (Provider).
2.  **ViewModel** calls a **Repository** method.
3.  **Repository** uses a **Service** (like `HttpService`) to fetch data.
4.  **Service** returns a **Result** (Success/Error).
5.  **ViewModel** updates its **State** based on the result.
6.  **View** reacts to the state change and updates the UI.

## 🚀 Getting Started

1.  **Dependencies**: Run `flutter pub get`.
2.  **Environment**: Ensure you are on Flutter SDK `^3.12.1`.
3.  **Run**: Execute `flutter run` to start the application.
