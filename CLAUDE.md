# CLAUDE.md — The Sharp Edge Barber Shop App

Flutter project for a premium barber shop business. Cross-platform (Android, iOS, Web, Desktop).

## Running the app

```bash
flutter pub get
flutter run
```

## Project structure

```
lib/
├── main.dart                        # Entry point, ChangeNotifierProvider, MaterialApp
├── theme/
│   └── app_theme.dart               # Theming (see Theme section below)
├── models/
│   ├── service.dart                 # Service class + allServices list (10 services)
│   ├── barber.dart                  # Barber class + allBarbers list (4 barbers)
│   ├── appointment.dart             # Appointment class + AppointmentStatus enum
│   └── loyalty.dart                 # LoyaltyTier enum, LoyaltyTransaction, Reward, allRewards
├── providers/
│   └── app_provider.dart            # Single provider for all app state
└── screens/
    ├── main_screen.dart             # Scaffold with BottomNavigationBar (6 tabs)
    ├── home_screen.dart             # Hero, stats, loyalty card, services, barbers, testimonials
    ├── services_screen.dart         # Search + category filter + service list
    ├── booking_screen.dart          # 4-step booking wizard
    ├── appointments_screen.dart     # Upcoming/Past/Cancelled tabs + loyalty mini-card
    ├── loyalty_screen.dart          # Full loyalty screen (tier card, rewards grid, history)
    ├── gallery_screen.dart          # Filterable photo grid
    └── about_screen.dart            # Hours, contact, map, theme toggle
```

## State management

Single `AppProvider extends ChangeNotifier` in `lib/providers/app_provider.dart` manages:

- **Navigation** — `currentTab` (int), `setTab(int)`
- **Booking wizard** — `bookingStep` (0–3), `selectedService`, `selectedBarber`, `selectedDate`, `selectedTime`
- **Booking actions** — `startFreshBooking()`, `startBookingWithService(service)`, `selectService/Barber/Date/Time()`, `advanceToConfirmation()`, `confirmBooking()` → awards loyalty points automatically
- **Appointments** — `appointments` list, `cancelAppointment(id)`
- **Loyalty** — `loyaltyPoints`, `loyaltyTier`, `loyaltyHistory`, `redeemReward(reward)`, `pendingPoints`
- **Theme** — `themeMode` (ThemeMode), `isDarkMode`, `toggleTheme()`

## Navigation (tab indices)

```
0 = Home
1 = Services
2 = Book          ← startFreshBooking() is called when tapping this tab
3 = My Bookings
4 = Gallery
5 = About
```

`startBookingWithService(service)` sets `_currentTab = 2` and `_bookingStep = 1` directly, jumping straight to the barber selection step.

## Theme system

**Never use hardcoded dark/light color values in widgets.** The app has a full dark/light theme toggle.

### Static accent colors (same in both themes — safe to use anywhere)
```dart
AppTheme.primary    // Color(0xFFD4AF37) — gold
AppTheme.primaryDark // Color(0xFFB8860B)
AppTheme.success    // Color(0xFF4CAF50)
```

### Dynamic colors (change between dark and light — always use context.appColors)
```dart
context.appColors.background   // scaffold background
context.appColors.surface      // bottom nav, app bar bg
context.appColors.card         // card/container backgrounds
context.appColors.textPrimary  // primary text
context.appColors.textSecondary // secondary/hint text
context.appColors.divider      // dividers and borders
```

`context.appColors` is a `BuildContext` extension defined in `app_theme.dart` that reads the `AppColors` ThemeExtension from the current ThemeData. It is available in any `build(BuildContext context)` method.

**Do not use `const`** on any widget that contains a `context.appColors.*` value — it is a runtime value and will cause a compile error.

### Adding a new theme-aware widget
```dart
Container(
  color: context.appColors.card,          // dynamic
  child: Text('Hello',
    style: TextStyle(
      color: context.appColors.textPrimary, // dynamic — no const
      fontSize: 14,                          // non-color properties can still be const
    ),
  ),
)
```

## Loyalty system

- **Earning** — `confirmBooking()` automatically calls `_awardPoints(service.price * 10, ...)`. 10 pts per $1.
- **Tiers** — Bronze (0–499), Silver (500–1499), Gold (1500–2999), Platinum (3000+). Defined in `LoyaltyTierInfo` extension on `LoyaltyTier` enum.
- **Redeeming** — `provider.redeemReward(reward)` deducts points and logs to history. Returns `false` if insufficient points.
- **`allRewards`** — defined as a `const List<Reward>` in `loyalty.dart`. Add new rewards there.

## Booking wizard steps

| Step | `bookingStep` | Widget |
|------|---------------|--------|
| Select service | 0 | `_StepSelectService` |
| Select barber | 1 | `_StepSelectBarber` |
| Select date & time | 2 | `_StepSelectDateTime` |
| Confirm | 3 | `_StepConfirm` |

`startBookingWithService(service)` skips step 0 by setting `bookingStep = 1`.

## Sample data

Pre-loaded in `AppProvider` static methods so every screen is populated on launch:

- `_buildSampleAppointments()` — 3 upcoming, 3 past (completed), 2 cancelled
- `_buildSampleHistory()` — 4 loyalty transactions totalling 700 pts (Silver tier)

`_loyaltyPoints` is initialised to `700` to match the sample history.

## Models

### Service (`lib/models/service.dart`)
```dart
Service({ id, name, description, price, durationMinutes, emoji, category })
// categories: 'Cuts' | 'Shave' | 'Color' | 'Treatment'
```

### Barber (`lib/models/barber.dart`)
```dart
Barber({ id, name, role, rating, reviewCount, specialties, avatarColor, initials })
```

### Appointment (`lib/models/appointment.dart`)
```dart
Appointment({ id, service, barber?, date, time, status })
// status: AppointmentStatus.confirmed | completed | cancelled
// barber == null means "any available barber"
```

### Reward (`lib/models/loyalty.dart`)
```dart
Reward({ id, title, description, pointsCost, emoji, value })
```

## Notification service

`lib/services/notification_service.dart` — static service, no instantiation needed.

```dart
await NotificationService.init();                  // called once in main()
await NotificationService.requestPermission();     // returns bool
await NotificationService.scheduleReminders(appt); // schedules 24h + 1h reminders
await NotificationService.cancelReminders(id);     // cancels both for an appointment
await NotificationService.cancelAll();             // cancels everything
```

- Reminders are scheduled at **T-24h** and **T-1h** before the appointment time. Past-due times are silently skipped.
- Notification IDs are derived from `appointmentId.hashCode` to stay stable across calls.
- Web is a no-op (`kIsWeb` guard at the top of every method).
- `AppProvider` has `notificationsEnabled`, `enableNotifications()` (async, requests permission + schedules all upcoming), and `disableNotifications()` (cancels all).
- `confirmBooking()` and `cancelAppointment()` in `AppProvider` automatically schedule/cancel when `notificationsEnabled` is true.

### Required platform setup (not in repo)

**Android** — add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```
Also add the receivers inside `<application>`:
```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
  </intent-filter>
</receiver>
```

**iOS** — no extra config needed; permissions are requested at runtime via `requestPermission()`.

## Dependencies

```yaml
provider: ^6.1.2                    # state management
google_fonts: ^6.2.1                # Playfair Display (headings), Lato (body)
intl: ^0.19.0                       # date formatting
flutter_local_notifications: ^17.2.3 # push notification scheduling
timezone: ^0.9.4                    # timezone-aware scheduling
flutter_timezone: ^1.0.4            # detects device local timezone
```

## Design conventions

- **Headings** — `GoogleFonts.playfairDisplay(...)`
- **Body** — Lato (set as default via `textTheme` in ThemeData)
- **Gold accent** — `AppTheme.primary` for borders, icons, highlights, progress bars
- **Cards** — `BorderRadius.circular(12)`, border `context.appColors.divider`, color `context.appColors.card`
- **Buttons** — `ElevatedButton` (gold fill, black text) for primary actions; `OutlinedButton` (gold border) for secondary
- **Spacing** — `SizedBox(height: 12)` between items, `SizedBox(height: 24)` between sections
- **Padding** — `EdgeInsets.all(16)` for screen padding, `EdgeInsets.all(20)` for about/loyalty screens
