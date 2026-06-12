# 🚀 Riverpod MVVM - Professional Flutter Architecture

A production-ready Flutter boilerplate demonstrating a scalable **MVVM (Model-View-ViewModel)** architecture powered by **Riverpod**. This project is engineered for high performance, maintainability, and a clear separation of concerns, making it ideal for enterprise-level applications.

---

## 🏛️ Architecture & Core Principles

### 1. **MVVM (Model-View-ViewModel)**
- **View**: Declarative UI built with Flutter widgets. Uses `ConsumerWidget` or `ConsumerStatefulWidget` to react to state changes.
- **ViewModel**: Manages UI state and business logic. It orchestrates data flow from repositories and exposes state via the `AppState` pattern.
- **Repository**: An abstraction layer that fetches data from multiple sources (Remote API via Dio or Local Storage).

### 2. **State Management Flow**
- **`AppState<S, E>` (Sealed Class)**: A type-safe way to handle UI states.
  - `InitialState`: Default state before any interaction.
  - `LoadingState`: Active during asynchronous operations.
  - `SuccessState<S>`: Holds the resulting data on success.
  - `ErrorState<E>`: Encapsulates exceptions for granular error handling.
- **`StateManagement<T>`**: A robust base class extending `ChangeNotifier` that provides `emitState()`, ensuring UI updates only occur when meaningful state changes happen.

### 3. **The Result Pattern**
Repositories return a `Result<Value, Exception>` object. This forces explicit handling of both success and failure paths in the ViewModel, eliminating unexpected runtime crashes and improving code reliability.

---

## 📡 Core Services & Infrastructure

### **Network Layer (Dio)**
A centralized `HttpService` built on **Dio** featuring:
- **Connectivity Guard**: Real-time checks via `connectivity_plus` to prevent requests when offline.
- **Auth Interceptor**: Transparently attaches Bearer tokens to outgoing requests.
- **Automatic Token Refresh**: Seamlessly handles `401 Unauthorized` errors by refreshing sessions and retrying failed requests.
- **Structured Error Mapping**: Converts raw HTTP errors into a type-safe `HttpError` enum.

### **Environment Configuration (Envied)**
Uses `@Envied` for secure environment variable management. Sensitive data like `BASE_URL` is obfuscated and managed outside the source code via `.env` files.

### **Persistence Layer**
- **StorageService**: Wrapper for `shared_preferences` for non-sensitive data (user preferences, settings).
- **SecureStorage**: Uses `flutter_secure_storage` for sensitive credentials (Auth tokens).

---

## 📁 Project Directory Structure

```text
lib/
├── main.dart                 # App entry point & ProviderScope setup
├── core/                     # Foundation layer
│   ├── env/                  # Environment configurations (Envied)
│   ├── theme/                # Custom design system (Colors, Typography, Res)
│   ├── constants/            # Global constants & API endpoints
│   ├── utils/                # Pure Dart utility functions
│   └── ext/                  # Reusable Dart extensions
├── common/                   # Shared across features
│   ├── enums/                # Global enums
│   ├── widgets/              # Standardized UI components (Refresh Indicators, Buttons)
│   └── state_management/     # Base ViewModel implementations
├── services/                 # Infrastructure (Http, Storage, Connectivity)
├── patterns/                 # Architectural contracts (AppState, Result)
├── di/                       # Dependency Injection (Riverpod providers)
├── routes/                   # Navigation logic (GoRouter config)
└── features/                 # Modular business domains
    ├── auth/                 # Authentication module
    ├── home/                 # Main dashboard / Landing
    └── settings/             # User preferences & Configuration
```

---

## 🛠️ Development Workflow

### **Adding a New Feature**
1. Create a module under `lib/features/`.
2. Define the **Model** and **Repository** interfaces.
3. Create a **ViewModel** by extending `StateManagement`.
4. Register the ViewModel and Repository in `lib/di/`.
5. Implement the **View** and bind it to the ViewModel using `ref.watch`.

### **Environment Setup**
1. Create a `.env` file in the root directory.
2. Define your variables:
   ```env
   BASE_URL=https://api.example.com
   ```
3. Run the generator:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🚀 Getting Started

1.  **Environment**: Flutter SDK `^3.12.1`
2.  **Installation**:
    ```bash
    flutter pub get
    ```
3.  **Code Generation**:
    ```bash
    dart run build_runner build
    ```
4.  **Run Project**:
    ```bash
    flutter run
    ```

---

## 📑 Key Features
- ✅ **Clean Architecture**: Strong separation of concerns.
- ✅ **Type-Safe Navigation**: Powered by `GoRouter`.
- ✅ **Reactive Styling**: Custom `Onest` font family integration.
- ✅ **Robust Error Handling**: Integrated `Result` and `AppState` patterns.
- ✅ **Performance Optimized**: Fine-grained rebuilds with Riverpod.
