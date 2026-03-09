# The Sharp Edge — Barber Shop App

A cross-platform Flutter app for a premium barber shop business. Features online booking, loyalty rewards, appointment management, and a dark/light theme toggle.

## Screens

| Screen | Description |
|--------|-------------|
| **Home** | Hero banner, featured services, barber profiles, testimonials, promo banner |
| **Services** | Searchable, filterable list of all services with pricing |
| **Book** | 4-step booking wizard — service → barber → date/time → confirmation |
| **My Bookings** | Upcoming, past, and cancelled appointments with cancel/reschedule actions |
| **Gallery** | Filterable photo grid of haircut styles (Fades, Classic, Beard, Color) |
| **About** | Business hours, contact info, map, social links, and theme toggle |

## Features

- **Booking wizard** — select service, choose a barber (or any available), pick a date from a 14-day scroll, select a time slot, then confirm
- **Loyalty rewards** — earn 10 pts per $1 spent; Bronze / Silver / Gold / Platinum tiers; redeem points for free services and discounts
- **My Appointments** — tabbed view of upcoming, past, and cancelled bookings; cancel with confirmation dialog; rebook/reschedule in one tap
- **Dark / Light theme** — toggle in the About screen; smooth animated transition across the whole app
- **Sample data** — pre-loaded appointments and loyalty history so every screen is populated on first launch

## Tech Stack

- **Flutter** 3.x (Dart 3)
- **Provider** — state management (theme mode, booking wizard, loyalty points, appointments)
- **Google Fonts** — Playfair Display (headings) + Lato (body)
- **Intl** — date formatting
- **ThemeExtension** — custom `AppColors` for clean dark/light color switching

## Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart        # AppTheme, AppColors ThemeExtension, context.appColors
├── models/
│   ├── service.dart           # Service model + sample data
│   ├── barber.dart            # Barber model + sample data
│   ├── appointment.dart       # Appointment model + status enum
│   └── loyalty.dart           # LoyaltyTier, LoyaltyTransaction, Reward models
├── providers/
│   └── app_provider.dart      # Central state: navigation, booking, loyalty, theme
└── screens/
    ├── main_screen.dart        # Bottom nav wrapper with badge counter
    ├── home_screen.dart
    ├── services_screen.dart
    ├── booking_screen.dart
    ├── appointments_screen.dart
    ├── loyalty_screen.dart
    ├── gallery_screen.dart
    └── about_screen.dart
```

## Getting Started

**Prerequisites:** Flutter SDK 3.x, Dart 3.x

```bash
git clone https://github.com/mmgubo/barber-shop.git
cd barber-shop
flutter pub get
flutter run
```

Runs on Android, iOS, Web, and Desktop out of the box.

## Dependencies

```yaml
provider: ^6.1.2
google_fonts: ^6.2.1
intl: ^0.19.0
```
