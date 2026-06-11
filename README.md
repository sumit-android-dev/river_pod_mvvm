# 🚀 Riverpod MVVM - Advanced Flutter Architecture

A professional-grade Flutter boilerplate demonstrating a scalable **MVVM (Model-View-ViewModel)** architecture integrated with **Riverpod**. This project is designed for high-performance, maintainability, and clear separation of concerns.

---

## 🏛️ Architecture & Design Patterns

### 1. **MVVM (Model-View-ViewModel)**
- **View**: Declarative UI built with Flutter widgets. Uses `ConsumerWidget` or `StateBuilderWidget` to react to state changes.
- **ViewModel**: Manages the UI state and business logic. It communicates with repositories and emits states using the `AppState` pattern.
- **Repository**: Abstract layer that orchestrates data from multiple sources (Remote API or Local Cache).

### 2. **State Management Logic**
- **`AppState<S, E>` (Sealed Class)**: A robust way to handle UI states.
  - `InitialState`: The default state before any action.
  - `LoadingState`: Shown during asynchronous tasks.
  - `SuccessState<S>`: Holds the successfully fetched data.
  - `ErrorState<E>`: Encapsulates exceptions for the UI to display.
- **`StateManagement<T>`**: A base class extending `ChangeNotifier` that provides a structured way to `emitState` and notify listeners only when the state actually changes.

### 3. **The Result Pattern**
Repositories return a `Result<Value, Exception>` object. This ensures that the ViewModel always handles both success and failure scenarios explicitly, preventing unhandled exceptions in the UI.

---

## 📡 Networking & Services

### **HttpService (Powered by Dio)**
A centralized networking layer with advanced capabilities:
- **Connectivity Guard**: Automatically checks for internet connection via `ConnectionService` before every request. Rejects with a "No internet connection" error immediately if offline.
- **Auth Interceptor**: Automatically attaches Bearer tokens to requests.
- **Token Refresh logic**: Handles `401 Unauthorized` errors by automatically attempting to refresh the session and retrying the original request.
- **Error Mapping**: HTTP status codes are mapped to a type-safe `HttpError` enum for easier logic handling.

### **StorageService**
Abstraction over `shared_preferences` providing a clean API for persistent key-value storage (Auth tokens, settings, etc.).

---

## 📁 Project Directory Structure

```text
lib/
├── main.dart                 # App entry point & ProviderScope setup
└── src/
    ├── core/                 # Foundation layer
    │   ├── theme/            # App colors, typography, and asset helpers
    │   ├── constants/        # API endpoints and static values
    │   └── ext/              # Reusable Dart extensions
    ├── common/               # Shared across features
    │   ├── enums/            # Typed enums (e.g., HttpError)
    │   ├── widgets/          # Reusable UI components (Buttons, Loaders)
    │   └── state_management/ # Core ViewModel base classes
    ├── services/             # Infrastructure (Http, Storage, Connectivity)
    ├── patterns/             # Architectural patterns (AppState, Result)
    ├── di/                   # Riverpod Dependency Injection center
    ├── routes/               # Global navigation & GoRouter config
    └── features/             # Business modules (Modular approach)
        └── auth/             # Example: Auth feature
            ├── models/       # Data entities
            ├── views/        # UI layer
            ├── view_models/  # Logic & State emission
            ├── repositories/ # Data handling
            └── request/      # API DTOs (Data Transfer Objects)
```

---

## 🛠️ Implementation Details

### **How to add a new Feature?**
1. Create a new folder under `features/`.
2. Define your **Model** and **Repository**.
3. Create a **ViewModel** extending `StateManagement`.
4. Define a **Provider** in `lib/src/di/dependency_injector.dart`.
5. Build your **View** and observe the state using `ref.watch`.

### **Error Handling Workflow**
1. **Service** catches `DioException` and returns a failed `HttpResult`.
2. **Repository** maps this to an `ErrorResult` with a specific Exception.
3. **ViewModel** receives the result and calls `emitState(ErrorState(error))`.
4. **View** listens via `ref.listen` and shows a SnackBar or Error Widget.

---

## 🚦 Getting Started

1.  **Environment**: Flutter SDK `^3.44.1`.
2.  **Setup**: Run `flutter pub get`.
3.  **Run**: Execute `flutter run`.

---

## 📑 Key Features at a Glance
- ✅ **Type-Safe Navigation**: Integrated GoRouter.
- ✅ **Clean DI**: No manual instantiation; everything is managed by Riverpod.
- ✅ **Reactive UI**: State-driven rendering.
- ✅ **Scalability**: Feature-first folder structure.
- ✅ **Performance**: Minimized widget rebuilds using specific state emission.
