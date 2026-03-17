<img width="330" height="755" alt="image" src="https://github.com/user-attachments/assets/b0c7b435-5dfb-4a58-964f-549a4b8b8bc0" /># 🤖 BharatNxt — Smart Assistant App

A Flutter application that simulates a smart AI assistant experience with paginated suggestions, a real-time chat interface, and chat history — built with Clean Architecture, BLoC state management, and GoRouter navigation.

---

## 📱 Screenshots

<img width="330" height="755" alt="image" src="https://github.com/user-attachments/assets/52869825-6510-4a00-a0c4-60ec984e36b5" />

<img width="329" height="748" alt="image" src="https://github.com/user-attachments/assets/728a9ced-50da-4f92-8aab-66f36a0b2ced" />

<img width="334" height="752" alt="image" src="https://github.com/user-attachments/assets/7d958c32-2699-47ea-ae8f-38c8a7ad2779" />





| Explore | Chat | History |
|---|---|---|
| Paginated suggestions grid | Message bubbles + typing indicator | Conversation history cards |

---

## 🚀 Getting Started|

Verify your environment:
```bash
flutter doctor
```

---

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/your-username/bharatnxt_app.git
cd bharatnxt_app
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Run the app**
```bash
# Debug mode
flutter run

# Specific device
flutter run -d chrome        # Web
flutter run -d emulator-5554 # Android emulator
flutter run -d iPhone        # iOS simulator
```



## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6    # BLoC state management
  equatable:    ^2.0.5    # Value equality for entities/states
  go_router:    ^14.6.3   # Declarative routing + deep linking
  http:         ^1.2.2    # HTTP client for REST API calls
```

---

## 🏛️ Architecture

The app follows **Clean Architecture** principles, strictly separating the codebase into three independent layers. Dependencies only point **inward** — the domain layer has zero knowledge of Flutter, HTTP, or any external package.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│   BLoC · Screens · Widgets · Router     │
└────────────────┬────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────┐
│             Domain Layer                │
│     Entities · Repository Contracts     │
└────────────────┬────────────────────────┘
                 │ implemented by
┌────────────────▼────────────────────────┐
│          Infrastructure Layer           │
│   Models · DataSources · Repo Impls     │
└─────────────────────────────────────────┘
```

---

### 📂 Folder Structure

```
lib/
├── main.dart                          # App entry point, DI wiring
│
├── core/
│   ├── router/
│   │   └── app_router.dart            # GoRouter + ShellRoute
│   └── app_theme/
│       └── app_theme.dart             # Light & dark ThemeData
│
├── domain/                            # Pure Dart — no Flutter/HTTP imports
│   ├── entities/
│   │   ├── sugeestion_entities.dart   # SuggestionEntity
│   │   ├── pagination_entites.dart    # PaginationEntity
│   │   ├── suggestion_page_entites.dart  # SuggestionsPageEntity
│   │   ├── chat_message_entities.dart # ChatMessageEntity + MessageSender
│   │   └── chat_reply_entities.dart   # ChatReplyEntity
│   └── repository/
│       ├── suggestion_repository.dart # abstract SuggestionsRepository
│       └── chat_repository.dart       # abstract ChatRepository
│
├── infrastructure/                    # Data layer — HTTP, JSON, mocks
│   ├── model/
│   │   ├── suggestion_model.dart
│   │   ├── pagination_model.dart
│   │   ├── sugesstions_response_model.dart
│   │   ├── chat_message_model.dart
│   │   ├── chat_request_model.dart
│   │   ├── chat_reply_model.dart
│   │   └── chat_history_response_model.dart
│   ├── data_source/
│   │   ├── suggestions_remote_data_source.dart  # abstract + Impl + Mock
│   │   └── chat_remote_data_source.dart         # abstract + Impl + Mock
│   └── repository/
│       ├── sugeestion_repository.dart  # SuggestionsRepositoryImpl
│       └── chat_repository.dart        # ChatRepositoryImpl
│
├── application/                        # BLoC layer
│   ├── suggestion/
│   │   └── suggestion_bloc.dart        # Events · States · SuggestionsBloc
│   ├── chat_bloc/
│   │   └── chat_bloc.dart             # Events · States · ChatBloc
│   └── history/
│       └── history_bloc.dart          # Events · States · HistoryBloc
│
└── presentation/
    ├── screens/
    │   ├── home_screen.dart            # Suggestions grid + pagination
    │   ├── chat_screen.dart            # Chat UI + typing indicator
    │   └── history_screen.dart         # Past conversation cards
    └── widgets/
        ├── suggestion_card.dart        # Tappable suggestion tile
        ├── pagination_bar.dart         # Prev / page numbers / next
        ├── shimmer_card.dart           # Animated loading skeleton
        ├── message_bubble.dart         # User & assistant chat bubbles
        ├── typing_indicator.dart       # Animated 3-dot bounce
        └── chat_input.dart             # Text field + send button

test/
└── widget_test.dart
```









## 👤 Author

**Swastik** — Flutter Developer  
GitHub: [@SwAsTik-KuL](https://github.com/SwAsTik-KuL)
