import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/appointment.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'booking_screen.dart';
import 'appointments_screen.dart';
import 'gallery_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    ServicesScreen(),
    BookingScreen(),
    AppointmentsScreen(),
    GalleryScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    final upcomingCount = provider.appointments.where((a) {
      final today = DateTime.now();
      final apptDay = DateTime(a.date.year, a.date.month, a.date.day);
      final todayDay = DateTime(today.year, today.month, today.day);
      return a.status == AppointmentStatus.confirmed &&
          apptDay.compareTo(todayDay) >= 0;
    }).length;

    return Scaffold(
      body: IndexedStack(
        index: provider.currentTab,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF2E2E2E), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: provider.currentTab,
          onTap: (index) {
            if (index == 2) {
              provider.startFreshBooking();
            }
            provider.setTab(index);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.content_cut_outlined),
              activeIcon: Icon(Icons.content_cut),
              label: 'Services',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Book',
            ),
            BottomNavigationBarItem(
              icon: _BadgedIcon(
                icon: Icons.bookmark_border,
                count: upcomingCount,
              ),
              activeIcon: _BadgedIcon(
                icon: Icons.bookmark,
                count: upcomingCount,
                active: true,
              ),
              label: 'Bookings',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.photo_library_outlined),
              activeIcon: Icon(Icons.photo_library),
              label: 'Gallery',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool active;

  const _BadgedIcon({
    required this.icon,
    required this.count,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 14),
              child: Text(
                count > 9 ? '9+' : '$count',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
