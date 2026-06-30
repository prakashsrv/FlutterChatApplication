# Flutter Chat App

A real-time chat thread built in Flutter as a portfolio piece that mirrors a companion Android implementation 1:1. Same Clean Architecture, same layer order, same module-by-module commit discipline — letting the two repositories read as siblings in different languages.

---

## Architecture

The project follows **Clean Architecture** with three concentric layers. Dependencies always point **inward** — the domain layer imports nothing but Dart core.

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation                         │
│   ChatScreen · ChatBloc · ChatState · ChatEvent         │
│   ChatEffect · MessageBubble · TypingIndicator          │
│                      │                                  │
│            depends on domain only ↓                     │
├─────────────────────────────────────────────────────────┤
│                      Domain                             │
│   Message · MessageStatus · ChatRepository (interface)  │
│   ChatMessageStream (interface)                         │
│   SendMessageUseCase · ObserveMessagesUseCase           │
│   RetryMessageUseCase                                   │
│                      │                                  │
│            implemented by data ↓                        │
├─────────────────────────────────────────────────────────┤
│                       Data                              │
│   ChatRepositoryImpl · ChatDao (Drift)                  │
│   MessagesTable · MessageMapper                         │
│   FakeChatStream · FakeNetworkConfig                    │
└─────────────────────────────────────────────────────────┘
```

> The domain layer imports **zero Flutter** — pure Dart only. This keeps domain unit tests fast and fully deterministic, with no platform setup required.

---

## Project Structure

```
lib/
├── core/
│   ├── database/          # Drift AppDatabase
│   └── di/                # Manual get_it wiring
│
├── feature/chat/
│   ├── data/
│   │   ├── local/         # Drift table + DAO
│   │   ├── remote/        # ChatApi stub (future WebSocket)
│   │   ├── stream/        # FakeChatStream + FakeNetworkConfig
│   │   ├── repository/    # ChatRepositoryImpl
│   │   └── mapper/        # entity ↔ domain mappers
│   │
│   ├── domain/
│   │   ├── model/         # Message, MessageStatus (freezed)
│   │   ├── repository/    # ChatRepository interface
│   │   ├── stream/        # ChatMessageStream interface
│   │   └── usecase/       # SendMessage, ObserveMessages, RetryMessage
│   │
│   └── presentation/
│       └── chat/
│           ├── chat_bloc.dart
│           ├── chat_state.dart     # freezed
│           ├── chat_event.dart     # freezed sealed union
│           ├── chat_effect.dart    # freezed sealed union
│           ├── chat_screen.dart
│           └── widgets/
│               ├── message_bubble.dart
│               ├── typing_indicator.dart
│               └── chat_input_bar.dart
│
├── app.dart               # MaterialApp.router + go_router
└── main.dart              # configureDependencies(); runApp()

test/
└── feature/chat/
    ├── domain/usecase/
    │   ├── send_message_usecase_test.dart
    │   ├── observe_messages_usecase_test.dart
    │   └── ordering_and_deduplication_test.dart
    ├── data/stream/
    │   └── fake_chat_stream_test.dart
    └── presentation/chat/
        └── chat_bloc_test.dart
```

---

## Data Flow

### Sending a Message (Optimistic Send)

The key invariant: **the UI never waits for the network**. The message appears immediately as `pending`, then transitions to `sent` or `failed` based on the simulated network response.

```
User presses Send
       │
       ▼
  ChatBloc.SendMessage
       │
       ├─ 1. emit inputText = ''  (clear field immediately)
       ├─ 2. emit ScrollToBottom effect
       │
       ▼
  SendMessageUseCase
       │
       ├─ 3. build Message(id: uuid, status: pending, isOwn: true)
       ├─ 4. repository.insertPendingMessage(msg)     ← DB write #1
       │         │
       │         └─► Drift emits updated list → UI shows "pending" bubble
       │
       ├─ 5. repository.sendMessageToServer(msg)      ← simulated network
       │
       ├─ success ──► 6a. repository.updateMessage(msg.copyWith(
       │                       status: sent, serverId: 'srv-…'))  ← DB write #2
       │                         │
       │                         └─► Drift emits → UI shows ✓✓ indicator
       │
       └─ failure ──► 6b. repository.updateMessage(msg.copyWith(
                              status: failed))         ← DB write #2
                                │
                                └─► Drift emits → UI shows ⚠ retry button
```

### Inbound Messages (Reactive SSOT)

All inbound traffic is funnelled through Drift before reaching the UI. Nothing bypasses the database.

```
FakeChatStream.emit("Hello")
       │
       ▼
  ChatRepositoryImpl._inboundSub (StreamSubscription)
       │
       ▼
  dao.insertOrUpdateInbound(entry)
  ┌────────────────────────────┐
  │  SQLite: INSERT OR REPLACE │  ← unique index on serverId prevents duplicates
  └────────────────────────────┘
       │
       ▼
  Drift .watch() re-emits updated list
       │
       ▼
  ObserveMessagesUseCase stream
       │
       ▼
  ChatBloc._messagesSub → add(MessagesUpdated(messages))
       │
       ▼
  ChatBloc._onMessagesUpdated → emit(state.copyWith(messages: …))
                              → if new message: add ScrollToBottom effect
       │
       ▼
  BlocBuilder rebuilds ListView
       │
       ▼
  ChatScreen._effectSub → ScrollToBottom → animateTo(maxScrollExtent)
```

### Typing Indicator

```
FakeChatStream.setTyping(isTyping: true)
       │
       ▼
  ChatRepositoryImpl passes through (not stored in DB — ephemeral)
       │   (via ChatMessageStream.isTyping broadcast stream)
       ▼
  ChatBloc._typingSub → add(TypingChanged(true))
       │
       ▼
  emit(state.copyWith(isTypingIndicatorVisible: true))
       │
       ▼
  BlocBuilder → ListView appends TypingIndicator widget
```

---

## Unidirectional Data Flow (UDF Triangle)

Mirrors the Android `Action → State + Effect` model faithfully.

```
              ┌──────────────┐
              │   ChatBloc   │
              └──────┬───────┘
                     │ emits
           ┌─────────┴──────────┐
           ▼                    ▼
      ChatState            ChatEffect
   (via BlocBuilder)    (via Stream<ChatEffect>)
           │                    │
    UI rebuilds         One-shot actions:
    (messages,          ScrollToBottom
     typing dot,        ShowError
     input text)
           │
           │  user interaction
           ▼
       ChatEvent
  ─────────────────
  InputChanged
  SendMessage
  RetryMessage
  SimulateNextFailure
  [internal: MessagesUpdated, TypingChanged]
```

**One-shot effects** use a dedicated `broadcast StreamController<ChatEffect>` exposed as `bloc.effects`. This matches Android's `SharedFlow<ChatEffect>` semantics: fired once, never replayed on rebuild. The subscription lives in `ChatScreen.initState` and is cancelled in `dispose`.

---

## Tech Stack

| Concern | Android | Flutter |
|---|---|---|
| Language | Kotlin | Dart |
| Architecture | Clean Arch + MVVM | Clean Arch + BLoC |
| ViewModel | `ChatViewModel` | `ChatBloc` (`flutter_bloc`) |
| State | `StateFlow<ChatUiState>` | `ChatState` (`freezed`) |
| Events/Actions | `ChatAction` (sealed) | `ChatEvent` (freezed sealed) |
| One-shot effects | `SharedFlow<ChatEffect>` | `Stream<ChatEffect>` broadcast |
| Reactive DB | Room + `Flow` queries | Drift + `.watch()` streams |
| DI | Hilt | `get_it` (manual registration) |
| Navigation | NavGraph / Compose Nav | `go_router` |
| Lifecycle restore | `SavedStateHandle` | `RestorationMixin` |
| Fake stream | `FakeChatStream` (Flow) | `FakeChatStream` (broadcast StreamController) |
| Testing | JUnit + MockK + Turbine | `flutter_test` + `mocktail` |

---

## Key Design Decisions

### Drift as the Single Source of Truth
Every message — own or inbound — flows through SQLite before reaching the UI. `ChatRepositoryImpl` subscribes to `FakeChatStream.messages` and immediately writes each inbound message to Drift via `insertOrUpdateInbound`. The UI only ever reads from `dao.watchMessages()`. This means:

- The list is always ordered by `clientTimestamp` (a DB-level `ORDER BY`)
- Re-delivery is idempotent: the unique index on `serverId` silently replaces duplicates
- Rotation and process death are free: Drift re-emits the full list on resubscription

### Optimistic Send
`SendMessageUseCase` writes `status: pending` to the DB *before* attempting the network call. The UI reflects the message immediately. On success or failure a second DB write updates the status. This is the highest-value invariant in the codebase and the direct target of the `SendMessageUseCase` tests.

### FakeChatStream
Uses `StreamController.broadcast()` — identical to Android's `SharedFlow` semantics: multiple independent listeners each receive every emission, and no replay on subscribe. `emitBurst(n)` stress-tests ordering; `setTyping` exercises the ephemeral indicator path.

### No injectable Codegen
`injectable_generator` has an analyzer version conflict with `freezed` and `bloc_test` under Dart 3.13+. The DI graph is wired manually in `injection.dart` — two dozen lines, fully explicit, zero magic.

---

## Building

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate freezed + Drift code (required before first build)
dart run build_runner build --delete-conflicting-outputs

# 3. Run
flutter run

# 4. Run tests
flutter test
```

> **Note:** `build_runner` must succeed before Android Studio stops showing red errors. The generated `*.freezed.dart` and `*.g.dart` files provide `copyWith`, value equality, and the Drift SQL layer.

---

## Tests

Five test files, ~650 lines total, covering the three most important layers:

| File | What it proves |
|---|---|
| `send_message_usecase_test.dart` | Optimistic ordering, unique IDs, success → `sent`, failure → `failed` |
| `observe_messages_usecase_test.dart` | Populated / empty / multi-emit / ascending-order streams |
| `ordering_and_deduplication_test.dart` | Out-of-order sort, own-message timestamp, 20-burst order, 50-burst no-dup, server echo dedup |
| `fake_chat_stream_test.dart` | Single/ordered/burst emissions, typing toggle, multiple listeners |
| `chat_bloc_test.dart` | `InputChanged`, blank-send guard, `RetryMessage`, typing flag, `ScrollToBottom` effect |

All domain tests are pure Dart — no `flutter_test` dependency, no platform setup, no `WidgetsFlutterBinding`.
