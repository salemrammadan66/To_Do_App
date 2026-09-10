# ToDo-s

A Flutter to-do list app with authentication, offline-first task management,
background sync, deadline reminders, and a calendar view.

## Features

- **Auth** — register/login against a REST backend, with a persisted session
  (auto-login on app start) and a profile page to view/update name, email,
  and password.
- **Tasks** — create, edit, complete, and delete to-dos with a title,
  priority, and deadline.
- **Offline-first** — every action (add/edit/toggle/delete) is saved locally
  first and returns instantly; a background sync pushes changes to the
  server, automatically retrying when connectivity comes back. A small
  cloud-off icon marks tasks that haven't synced yet.
- **Reminders** — local notifications fire at a task's deadline, even if the
  app is closed or the device has been restarted.
- **Calendar view** — see all tasks on a monthly calendar, with a marker on
  any day that has a deadline.
- **Pull-to-refresh** on the home screen to force a manual sync.

## Tech stack

- **State management:** Provider
- **Local storage:** Hive
- **Networking:** `http`, wrapped in a small custom `ApiClient`
- **Notifications:** flutter_local_notifications + timezone/flutter_timezone
- **Calendar:** table_calendar

## Architecture

```
lib/
  core/
    constants/     # API base URL and endpoints
    errors/        # Failure/Result types used across the app
    network/       # ApiClient (HTTP), NetworkChecker (connectivity)
    notifications/ # NotificationService (deadline reminders)
    theme/         # AppColors
  features/
    Auth/          # login, register, profile, session handling
    tasks/         # task CRUD, sync, calendar, reminders
  main.dart
```

Each feature follows a simple layered structure:

```
model/       -> data classes
repository/  -> local (Hive) + remote (API) data sources
service/     -> auth-specific HTTP calls
viewmodel/   -> ChangeNotifier-based state (Provider)
view/        -> screens and widgets
```

Errors from the network layer are translated into a small `Failure`
hierarchy (`NetworkFailure`, `ServerFailure`, `CacheFailure`,
`UnknownFailure`) instead of raw, inconsistent exceptions.

## Getting started

```bash
flutter pub get
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

The output is at `build/app/outputs/flutter-apk/app-release.apk`.

## Known limitations

- The backend only stores a task's `title` and `completed` status — it has
  no concept of priority or deadline. Those fields are local-only:
  - Tasks fetched from the server (e.g. after reinstalling the app) come
    back with priority defaulted to **Low** and no deadline.
  - This can't be fixed from the app alone; it would require adding
    `priority`/`deadline` fields to the backend's data model.
- Notifications use **inexact** scheduling on Android, so they don't
  require the special "Alarms & reminders" permission but may occasionally
  fire a few minutes later than the exact deadline.
- On some Android OEM skins (Xiaomi, Huawei, Oppo, aggressive battery
  optimizers), the app may need to be manually excluded from battery
  optimization for scheduled notifications to reliably arrive.

## Configuration

- API base URL: `lib/core/constants/api_constants.dart`
- App colors: `lib/core/theme/app_colors.dart`
- App icon source: `assets/icon/icon.png` (regenerate with
  `dart run flutter_launcher_icons` after replacing it)
