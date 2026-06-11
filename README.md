# Riverpod MVVM Flutter Project

A robust and scalable Flutter application boilerplate implementing the **MVVM (Model-View-ViewModel)** architecture combined with **Riverpod** for state management.

## 🚀 Features

- **State Management**: Powered by [Riverpod](https://riverpod.dev/) for a reactive and testable architecture.
- **Navigation**: Structured routing using [GoRouter](https://pub.dev/packages/go_router).
- **Network Layer**: Robust HTTP service using [Dio](https://pub.dev/packages/dio) with:
  - **Interceptors**: Global request/response logging and error handling.
  - **Connectivity Guard**: Automatic internet connection check before every request.
  - **Token Refresh**: Automatic handling of 401 Unauthorized errors with refresh token logic.
- **Modular Architecture**: Feature-based folder structure for better scalability.
- **Design Patterns**:
  - **Result Pattern**: Consistent handling of Success and Error states from repositories.
  - **AppState Pattern**: Unified UI states (Initial, Loading, Success, Error).
  - **Repository Pattern**: Abstracted data layer for better testability.
- **Local Storage**: Simple key-value storage using `shared_preferences`.
- **Theming**: Integrated theme management (Light/Dark mode) using Riverpod.

## 📁 Project Structure

```text
lib/
├── main.dart                 # Application entry point
└── src/
    ├── common/               # Shared utilities and global components
    │   ├── constants/        # API and Value constants
    │   ├── dependency_injectors/ # Riverpod Providers for services/repositories
    │   ├── enums/            # Global Enums (e.g., HttpError)
    │   ├── patterns/         # Common logic patterns (Result, AppState)
    │   ├── routes/           # Routing configuration
    │   ├── services/         # Core services (Http, Storage, Connectivity)
    │   ├── state_management/ # Base classes for ViewModels
    │   ├── theme/            # App theme configuration
    │   └── widgets/          # Reusable UI components
    └── features/             # Feature-based modules
        ├── auth/             # Authentication module (Login, Profile)
        ├── home/             # Home module
        └── settings/         # Settings and Theme configuration
```

## 🛠️ Architecture: MVVM

This project follows the **Model-ViewModel-View** pattern:

1.  **Model**: Defines the data structure (e.g., `AuthModel`, `UserProfile`).
2.  **View**: Flutter widgets that observe the ViewModel and display the UI.
3.  **ViewModel**: Handles business logic, interacts with Repositories, and exposes state to the View.
4.  **Repository**: Acts as a bridge between the ViewModel and Data Sources (Remote API or Local Storage).

## 🚦 Getting Started

### Prerequisites
- Flutter SDK: `^3.12.1`
- Dart SDK: `^3.0.0`

### Installation
1.  Clone the repository:
    ```bash
    git clone <repository-url>
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

## 📡 Networking & Error Handling

The app uses a centralized `HttpService` to manage API calls.

- **Connectivity**: Every request is intercepted to check for internet availability.
- **Error Mapping**: HTTP status codes are mapped to the `HttpError` enum for type-safe handling.
- **Result Type**: Repositories return a `Result<Data, Exception>` object, ensuring all outcomes are handled at the UI level.

## 📄 License

This project is for internal use. See `LICENSE` file for more details (if applicable).
