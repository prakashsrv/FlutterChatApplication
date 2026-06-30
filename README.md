# Flutter Chat App

A real-time chat thread built in Flutter as a portfolio piece that mirrors a companion Android implementation 1:1. Same Clean Architecture, same layer order, same module-by-module commit discipline — letting the two repositories read as siblings in different languages.

---

## Architecture

The project follows **Clean Architecture** with three concentric layers. Dependencies always point **inward** — the domain layer imports nothing but Dart core.

```
┌──────────────────────────────────────────────────────────────────┐
│                         Presentation                             │
│  ChatScreen · ChatBloc · ChatState · ChatEvent · ChatEffect      │
│  SyncStatusBanner · MessageBubble · TypingIndicator              │
│                            │                                     │
│                 depends on domain only ↓                         │
├──────────────────────────────────────────────────────────────────┤
│                           Domain                                 │
│  Message · MessageStatus · SyncStatus                            │
│  ChatRepository (interface) · ChatMessageStream (interface)      │
│  SendMessageUseCase · ObserveMessagesUseCase · RetryMessageUseCase│
│                            │                                     │
│                 implemented by data ↓                            │
├──────────────────────────────────────────────────────────────────┤
│                            Data                                  │
│  ChatRepositoryImpl · ChatDao (Drift) · MessagesTable            │
│  MessageMapper · FakeChatStream · FakeNetworkConfig              │
│  BackgroundSyncManager                                           │
├──────────────────────────────────────────────────────────────────┤
│                            Core                                  │
│  AppDatabase · AppLifecycleObserver · get_it DI                  │
└──────────────────────────────────────────────────────────────────┘
```

> The domain layer imports **zero Flutter** — pure Dart only. This keeps domain unit tests fast and deterministic, with no platform setup required.

---

## Project Structure

```
lib/
├── core/
│   ├── database/               # Drift AppDatabase
│   ├── di/                     # Manual get_it wiring
│   └── lifecycle/              # AppLifecycleObserver
│
├── feature/chat/
│   ├── data/
│   │   ├── local/              # Drift table (MessagesTable) + ChatDao
│   │   ├── remote/             # ChatApi stub (future WebSocket seam)
│   │   ├── stream/             # FakeChatStream + FakeNetworkConfig
│   │   ├── sync/               # BackgroundSyncManager
│   │   ├── repository/         # ChatRepositoryImpl
│   │   └── mapper/             # entity ↔ domain mappers
│   │
│   ├── domain/
│   │   ├── model/              # Message (freezed), MessageStatus
│   │   ├── repository/         # ChatRepository interface
│   │   ├── stream/             # ChatMessageStream interface
│   │   ├── sync/               # SyncStatus enum
│   │   └── usecase/            # SendMessage, ObserveMessages, RetryMessage
│   │
│   └── presentation/
│       └── chat/
│           ├── chat_bloc.dart
│           ├── chat_state.dart       # freezed
│           ├── chat_event.dart       # freezed sealed union
│           ├── chat_effect.dart      # freezed sealed union
│           ├── chat_screen.dart
│           └── widgets/
│               ├── message_bubble.dart
│               ├── typing_indicator.dart
│               ├── chat_input_bar.dart
│               └── sync_status_banner.dart
│
├── app.dart                    # MaterialApp.router + go_router
└── main.dart                   # configureDependencies(); runApp()

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
       ├─ 1. emit inputText = ''            (clear field immediately)
       ├─ 2. emit ScrollToBottom effect
       │
       ▼
SendMessageUseCase
       │
       ├─ 3. build Message(id: uuid, status: pending, isOwn: true)
       ├─ 4. repository.insertPendingMessage(msg)        ← DB write #1
       │         │
       │         └─► Drift .watch() emits → UI shows "pending" bubble
       │
       ├─ 5. repository.sendMessageToServer(msg)         ← simulated network
       │
       ├─ success ──► 6a. repository.updateMessage(msg.copyWith(
       │                       status: sent, serverId: 'srv-…'))   ← DB write #2
       │                         │
       │                         └─► Drift emits → UI shows ✓✓ indicator
       │
       └─ failure ──► 6b. repository.updateMessage(msg.copyWith(
                              status: failed))                     ← DB write #2
                                │
                                └─► Drift emits → UI shows ⚠ retry button
```

### Inbound Messages (Reactive SSOT)

All inbound traffic is funnelled through Drift before reaching the UI. Nothing bypasses the database — this is what guarantees stable ordering and deduplication.

```
FakeChatStream.emit("Hello")
       │
       ▼
ChatRepositoryImpl._inboundSub (StreamSubscription)
       │
       ▼
dao.insertOrUpdateInbound(entry)
┌─────────────────────────────┐
│  SQLite: INSERT OR REPLACE  │  ← unique index on serverId prevents duplicates
└─────────────────────────────┘
       │
       ▼
Drift .watch() re-emits updated list (ordered by clientTimestamp ASC)
       │
       ▼
ObserveMessagesUseCase stream
       │
       ▼
ChatBloc._messagesSub → add(MessagesUpdated(messages))
       │
       ▼
_onMessagesUpdated → emit(state.copyWith(messages: …))
                   → if list grew: add ScrollToBottom effect
       │
       ▼
BlocBuilder rebuilds ListView
       │
       ▼
ChatScreen._effectSub → ScrollToBottom → animateTo(maxScrollExtent)
```

### Background Sync

When the user leaves the app, inbound messages are **buffered** rather than dropped. On return to foreground they are flushed to the database in arrival order, producing a seamless catch-up with no missing or duplicate messages.

```
                    ┌───────────────────────────────────────────┐
                    │         AppLifecycleObserver               │
                    │   (single WidgetsBindingObserver, DI-wired)│
                    └──────────────────┬────────────────────────┘
                                       │ Stream<AppLifecycleState>
                                       ▼
                          BackgroundSyncManager
                         ┌──────────────────────┐
                         │  observes lifecycle   │
                         │  controls FakeStream  │
                         │  broadcasts SyncStatus│
                         └──────────────────────┘
                                       │
                    ┌──────────────────┴─────────────────────┐
                    │                                         │
             paused / hidden                             resumed
            /detached state                               state
                    │                                         │
                    ▼                                         ▼
       FakeChatStream.pause()                 FakeChatStream.resume()
       sets _isPaused = true                  (flushes _buffer, 8 ms/msg)
                    │                                         │
       Messages arriving while                    SyncStatus.syncing emitted
       paused go into _buffer[]                   (banner: spinner visible)
                    │                                         │
       SyncStatus.background emitted              Each buffered message
       (banner: wifi-off icon)                    → Drift insert
                    │                             → watch() emits
                    │                             → UI updates in order
                    │                                         │
                    │                             SyncStatus.connected
                    │                             (banner fades away)
                    ▼                                         ▼
         ChatBloc.SyncStatusChanged ─────────────────────────┘
                    │
                    ▼
         emit(state.copyWith(syncStatus: …))
                    │
                    ▼
         SyncStatusBanner widget (BlocBuilder, buildWhen: syncStatus changed)
           connected  →  SizedBox.shrink (invisible)
           background →  orange row: wifi-off icon + "Paused…" label
           syncing    →  blue row:   spinner    + "Syncing missed messages…"
```

**Why 8 ms between flush messages?**
Drift processes each insert asynchronously. Draining the buffer with a small inter-message delay lets Drift write and re-emit after each message, so the UI scrolls incrementally rather than jumping straight to the end of a large catch-up batch.

**Why a 600 ms grace period after the flush?**
If the buffer contained only one or two messages the flush completes in milliseconds — too fast for the user to read the "Syncing…" banner. The grace period keeps the banner visible long enough to feel intentional.

### Typing Indicator

```
FakeChatStream.setTyping(isTyping: true)
       │
       ▼
ChatMessageStream.isTyping broadcast stream
(not stored in DB — ephemeral, display-only)
       │
       ▼
ChatBloc._typingSub → add(TypingChanged(true))
       │
       ▼
emit(state.copyWith(isTypingIndicatorVisible: true))
       │
       ▼
BlocBuilder → ListView appends animated TypingIndicator widget
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
    ─ messages            ScrollToBottom
    ─ typing dot          ShowError
    ─ input text
    ─ syncStatus          (never replayed on rebuild)
           │
           │  user interaction / internal subscriptions
           ▼
       ChatEvent  (sealed union, freezed)
  ──────────────────────────────────────
  InputChanged          ← text field
  SendMessage           ← send button
  RetryMessage          ← failed bubble tap
  SimulateNextFailure   ← debug menu
  ── internal ──────────────────────────
  MessagesUpdated       ← DB watch stream
  TypingChanged         ← isTyping stream
  SyncStatusChanged     ← BackgroundSyncManager
```

**One-shot effects** use a dedicated `broadcast StreamController<ChatEffect>` exposed as `bloc.effects`. This matches Android's `SharedFlow<ChatEffect>` semantics: fired once, never replayed. Subscription lives in `ChatScreen.initState`, cancelled in `dispose`.

---

## Background Sync: Component Responsibilities

| Component | Responsibility |
|---|---|
| `AppLifecycleObserver` | Wraps `WidgetsBindingObserver` once; broadcasts `AppLifecycleState` as a stream so any component subscribes without mixing in the observer |
| `BackgroundSyncManager` | Translates lifecycle states into stream pause/resume calls; owns the `SyncStatus` broadcast stream |
| `FakeChatStream` | Stream source; when paused, buffers messages in `_buffer[]` rather than dropping them; `resume()` drains the buffer in order |
| `SyncStatus` (domain enum) | `connected` · `background` · `syncing` — pure Dart, no Flutter import |
| `ChatState.syncStatus` | Carries the current sync state through the normal UDF path to the UI |
| `SyncStatusBanner` | Reads only `syncStatus` from state (`buildWhen` guards against unnecessary rebuilds); renders nothing when `connected` |

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
| Lifecycle (rotation) | `SavedStateHandle` | Free — Flutter keeps Bloc alive across rotation |
| Lifecycle (background) | `LifecycleObserver` | `WidgetsBindingObserver` → `AppLifecycleObserver` |
| Draft restore | `SavedStateHandle` | `RestorationMixin` + `RestorableTextEditingController` |
| Fake stream | `FakeChatStream` (Flow) | `FakeChatStream` (broadcast `StreamController`) |
| Testing | JUnit + MockK + Turbine | `flutter_test` + `mocktail` |

---

## Key Design Decisions

### Drift as the Single Source of Truth
Every message — own or inbound — flows through SQLite before reaching the UI. `ChatRepositoryImpl` subscribes to `FakeChatStream.messages` and immediately writes each inbound message to Drift via `insertOrUpdateInbound`. The UI reads only from `dao.watchMessages()`. This gives:

- Stable ordering — DB-level `ORDER BY clientTimestamp ASC`, not in-memory sort
- Idempotent inbound delivery — unique index on `serverId` silently replaces duplicates
- Free rotation resilience — Drift re-emits the full list on resubscription
- Correct background sync — buffered messages are inserted in order on resume, and the DB stream handles deduplication if any were already delivered

### Optimistic Send
`SendMessageUseCase` writes `status: pending` to the DB *before* the network call. The UI reflects the message immediately. A second DB write updates the status to `sent` (with `serverId`) or `failed`. This is the highest-value invariant in the codebase and the primary target of the `SendMessageUseCase` tests.

### Background Buffering vs. Cancellation
When the app is backgrounded, the `StreamSubscription` in `ChatRepositoryImpl` stays open — only `FakeChatStream` starts buffering. This mirrors what a real WebSocket would do: the socket stays alive in the OS for a short window, queuing frames. The `resume()` flush then replays those frames through the same Drift insert path, so deduplication and ordering are identical to the live path.

### FakeChatStream as a Broadcast Controller
Uses `StreamController.broadcast()` — identical to Android's `SharedFlow` semantics: multiple independent listeners each receive every emission, no replay on subscribe. `pause()`/`resume()` act on the controller's delivery gate, not the subscription, so the `ChatRepositoryImpl` subscription never needs to be recreated.

### No injectable Codegen
`injectable_generator` has an analyzer version conflict with `freezed` and `bloc_test` under Dart 3.13+. The DI graph is wired manually in `injection.dart` — fully explicit, zero generated boilerplate, and trivial to read.

---

## Building

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate freezed data classes + Drift SQL layer
#    (required before first build — removes red errors in Android Studio)
dart run build_runner build --delete-conflicting-outputs

# 3. Run on a connected device or simulator
flutter run

# 4. Run all tests
flutter test
```

> Android Studio will show red errors until `build_runner` succeeds and generates the `*.freezed.dart` and `*.g.dart` files. These files provide `copyWith`, value equality for all freezed classes, and the entire Drift DAO/table layer.

---

## Tests

Five test files covering the three most important layers:

| File | What it proves |
|---|---|
| `send_message_usecase_test.dart` | Optimistic ordering (insert before send), unique client IDs, success → `sent` + `serverId`, failure → `failed` |
| `observe_messages_usecase_test.dart` | Populated / empty / multi-emit / ascending-order streams |
| `ordering_and_deduplication_test.dart` | Out-of-order timestamp sort, own-message ordering, 20-burst sequence, server-echo dedup (map stays size 1), 50-burst no duplicates |
| `fake_chat_stream_test.dart` | Single emit, ordered sequence, 20-message burst, typing indicator toggle, multiple listeners each receive every event |
| `chat_bloc_test.dart` | `InputChanged`, blank-send guard, `RetryMessage` delegation, typing flag, `ScrollToBottom` effect on send and on new message arrival |

All domain and stream tests are pure Dart — no `flutter_test`, no `WidgetsFlutterBinding`, no platform setup.
