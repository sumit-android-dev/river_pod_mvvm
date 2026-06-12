# 🌊 Riverpod MVVM - Enterprise Flutter Boilerplate

[![Flutter](https://img.shields.io/badge/Flutter-v3.12.1-blue.svg?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Riverpod](https://img.shields.io/badge/Riverpod-v3.3.1-60B5FF.svg?logo=riverpod&logoColor=white)](https://riverpod.dev/)
[![Dio](https://img.shields.io/badge/Networking-Dio-orange.svg)](https://pub.dev/packages/dio)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM%20+%20Clean-green.svg)](https://github.com/lucas-goldner/Flutter-Clean-Architecture)

A high-performance, scalable, and maintainable Flutter boilerplate designed for enterprise-grade applications. This project leverages **Riverpod** for state management and dependency injection, following a strictly decoupled **MVVM** architecture with functional error handling.

---

## 🏗️ Architecture Philosophy

This project is built on the principles of **Clean Architecture** and **SOLID**, ensuring that the business logic is independent of the UI and external frameworks.

### **The Layers**
*   **Presentation (MVVM):** Reactive UI components using `ConsumerWidget`. ViewModels manage state transitions using a formal `AppState` machine.
*   **Domain:** Logic contracts and data structures.
*   **Data:** Repositories that orchestrate data flow between local storage and remote APIs.
*   **Infrastructure:** Low-level services for networking, persistence, and hardware interactions.

---

## 📂 Project Structure

```text
lib/
├── main.dart                 # Application entry point
├── di/                       # Dependency Injection (Riverpod Providers)
├── routes/                   # Type-safe navigation (GoRouter)
├── core/                     # Essential application foundation
│   ├── env/                  # Secure Environment Config (Envied)
│   ├── theme/                # Design System (Res, Colors, Typography)
│   ├── constants/            # Global API Endpoints & Static Keys
│   └── utils/                # Extensions & Helper functions
├── common/                   # Shared UI & Logic
│   ├── widgets/              # Standardized Components (Buttons, Indicators)
│   └── state_management/     # Base classes for ViewModels
├── services/                 # Infrastructure Services
│   ├── network/              # Dio implementation, Interceptors, Connectivity
│   └── local_db/             # Secure & Persistent storage
├── patterns/                 # Architectural Contracts
│   ├── app_state_pattern.dart # Sealed classes for UI State
│   └── result_pattern.dart    # Functional Success/Failure handling
└── features/                 # Domain-driven feature modules
    ├── auth/                 # Authentication flow
    ├── home/                 # Main business logic & Dashboard
    └── settings/             # User configuration
```

---

## 🚀 Key Features & Implementation

### 🛡️ **Functional State Management**
Instead of using booleans for loading/error states, we use **Sealed Classes**. This eliminates invalid UI states and makes the code more predictable.
```dart
// Example of pattern matching in the View
final state = ref.watch(loginViewModelProvider);

return switch (state) {
  InitialState() => const LoginInitialWidget(),
  LoadingState() => const CircularProgressIndicator(),
  SuccessState(data: user) => HomeView(user: user),
  ErrorState(error: e) => ErrorDialog(message: e.toString()),
};
```

### 🔗 **The Result Pattern**
We treat errors as first-class citizens. Repositories return a `Result<S, E>`, forcing the developer to handle both success and failure cases explicitly via the `fold` method.

### 🌐 **Advanced Networking**
*   **Interceptors:** Automatic header injection and logging.
*   **Auto-Refresh:** Seamlessly handles token expiration and request retries.
*   **Connectivity Guard:** Prevent API calls when the device is offline to save resources and improve UX.

### 🔐 **Secure Environment**
All sensitive keys are managed via `.env` files and obfuscated using `Envied` code generation, preventing API key leakage in decompiled code.

---

## 🛠️ Setup & Installation

### 1. Requirements
*   Flutter SDK: `^3.44.1`
*   Dart SDK: `^3.12.1`

### 2. Environment Setup
Create a `.env` file in the project root:
```env
BASE_URL=https://api.example.com
```

### 3. Initialize
```bash
# Install dependencies
flutter pub get

# Generate environment and state files
dart run build_runner build --delete-conflicting-outputs

# Launch the app
flutter run
```

---

## 🧪 Best Practices
*   **Immutability:** Always use `final` and `const` where possible.
*   **Decoupling:** Never instantiate a Repository inside a View; always use Riverpod DI.
*   **Testing:** Keep business logic inside ViewModels to make it easily unit-testable.

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for details.
