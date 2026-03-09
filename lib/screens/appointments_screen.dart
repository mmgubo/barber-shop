import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/appointment.dart';
import '../models/loyalty.dart';
import '../providers/app_provider.dart';
import 'loyalty_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Appointments',
          style: GoogleFonts.playfairDisplay(
              color: AppTheme.primary,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: context.appColors.textSecondary,
          indicatorColor: AppTheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: context.appColors.divider,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final upcoming = provider.appointments.where((a) {
            final apptDay =
                DateTime(a.date.year, a.date.month, a.date.day);
            return a.status == AppointmentStatus.confirmed &&
                apptDay.compareTo(today) >= 0;
          }).toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          final past = provider.appointments.where((a) {
            final apptDay =
                DateTime(a.date.year, a.date.month, a.date.day);
            return a.status != AppointmentStatus.cancelled &&
                apptDay.compareTo(today) < 0;
          }).toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final cancelled = provider.appointments
              .where((a) => a.status == AppointmentStatus.cancelled)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return Column(
            children: [
              _LoyaltyMiniCard(provider: provider),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _AppointmentList(
                      appointments: upcoming,
                      emptyIcon: Icons.event_available,
                      emptyTitle: 'No upcoming appointments',
                      emptySubtitle: 'Book a session and it will appear here.',
                      showCancel: true,
                      showRebook: false,
                    ),
                    _AppointmentList(
                      appointments: past,
                      emptyIcon: Icons.history,
                      emptyTitle: 'No past appointments',
                      emptySubtitle: 'Your completed visits will show here.',
                      showCancel: false,
                      showRebook: true,
                    ),
                    _AppointmentList(
                      appointments: cancelled,
                      emptyIcon: Icons.cancel_outlined,
                      emptyTitle: 'No cancelled appointments',
                      emptySubtitle: "You haven't cancelled any bookings.",
                      showCancel: false,
                      showRebook: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<AppProvider>().startFreshBooking();
          context.read<AppProvider>().setTab(2);
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.black,
        icon: Icon(Icons.add),
        label: Text('New Booking',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final bool showCancel;
  final bool showRebook;

  const _AppointmentList({
    required this.appointments,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.showCancel,
    required this.showRebook,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _EmptyState(
          icon: emptyIcon, title: emptyTitle, subtitle: emptySubtitle);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _AppointmentCard(
        appointment: appointments[index],
        showCancel: showCancel,
        showRebook: showRebook,
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool showCancel;
  final bool showRebook;

  const _AppointmentCard({
    required this.appointment,
    required this.showCancel,
    required this.showRebook,
  });

  Color get _statusColor {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return AppTheme.primary;
      case AppointmentStatus.completed:
        return AppTheme.success;
      case AppointmentStatus.cancelled:
        return Colors.redAccent;
    }
  }

  String get _statusLabel {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final a = appointment;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: appointment.status == AppointmentStatus.confirmed
              ? AppTheme.primary.withOpacity(0.25)
              : context.appColors.divider,
        ),
      ),
      child: Column(
        children: [
          // Header strip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Text(
                  DateFormat('EEE, MMM d · y').format(a.date),
                  style: TextStyle(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                        color: _statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(a.service.emoji,
                            style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.service.name,
                            style: TextStyle(
                              color: context.appColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 12,
                                  color: context.appColors.textSecondary),
                              const SizedBox(width: 3),
                              Text(
                                a.time,
                                style: TextStyle(
                                    color: context.appColors.textSecondary,
                                    fontSize: 13),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.timelapse,
                                  size: 12,
                                  color: context.appColors.textSecondary),
                              const SizedBox(width: 3),
                              Text(
                                '${a.service.durationMinutes} min',
                                style: TextStyle(
                                    color: context.appColors.textSecondary,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${a.service.price.toInt()}',
                      style: GoogleFonts.playfairDisplay(
                        color: AppTheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.appColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildInfoChip(
                          Icons.person_outline, a.barberName),
                      const SizedBox(width: 16),
                      _buildInfoChip(
                          Icons.sell_outlined, a.service.category),
                    ],
                  ),
                ),
                if (showCancel || showRebook) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (showRebook)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => provider
                                .startBookingWithService(a.service),
                            icon: Icon(Icons.replay, size: 15),
                            label: Text('Book Again'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      if (showCancel) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _confirmCancel(context, provider, a),
                            icon: Icon(Icons.close, size: 15),
                            label: Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(
                                  color: Colors.redAccent),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => provider
                                .startBookingWithService(a.service),
                            icon: Icon(Icons.edit_calendar,
                                size: 15),
                            label: Text('Reschedule'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.appColors.textSecondary),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  void _confirmCancel(
      BuildContext context, AppProvider provider, Appointment a) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Appointment?',
            style: TextStyle(
                color: context.appColors.textPrimary, fontWeight: FontWeight.bold)),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 14, height: 1.5),
            children: [
              const TextSpan(text: 'Are you sure you want to cancel your '),
              TextSpan(
                text: a.service.name,
                style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' on '),
              TextSpan(
                text: DateFormat('MMM d').format(a.date),
                style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' at '),
              TextSpan(
                text: a.time,
                style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: '?\n\nThis cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep It',
                style: TextStyle(color: context.appColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.cancelAppointment(a.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment cancelled'),
                  backgroundColor: context.appColors.surface,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Book Again',
                    textColor: AppTheme.primary,
                    onPressed: () =>
                        provider.startBookingWithService(a.service),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyMiniCard extends StatelessWidget {
  final AppProvider provider;
  const _LoyaltyMiniCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final tier = provider.loyaltyTier;
    final points = provider.loyaltyPoints;
    final nextTier = tier.next;
    final progress = nextTier != null
        ? ((points - tier.minPoints) /
                (nextTier.minPoints - tier.minPoints))
            .clamp(0.0, 1.0)
        : 1.0;
    final toNext = nextTier != null ? nextTier.minPoints - points : 0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoyaltyScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: tier.gradient,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tier.color.withOpacity(0.35), width: 1.5),
        ),
        child: Row(
          children: [
            // Tier badge
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tier.color.withOpacity(0.15),
                border: Border.all(color: tier.color, width: 1.5),
              ),
              child: Center(
                child: Text(
                  tier.tierIcon,
                  style: TextStyle(
                      color: tier.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Middle content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${tier.label} Member',
                        style: TextStyle(
                            color: tier.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '$points pts',
                        style: TextStyle(
                            color: tier.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(tier.color),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextTier != null
                        ? '$toNext pts to ${nextTier.label}'
                        : 'Maximum tier achieved!',
                    style: TextStyle(
                        color: tier.color.withOpacity(0.6), fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: tier.color.withOpacity(0.6), size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.08),
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.2), width: 1.5),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                color: context.appColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                  color: context.appColors.textSecondary, fontSize: 14, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
