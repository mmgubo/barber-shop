import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/service.dart';
import '../models/barber.dart';
import '../providers/app_provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment',
            style: GoogleFonts.playfairDisplay(
                color: AppTheme.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              _StepIndicator(currentStep: provider.bookingStep),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(context, provider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep(BuildContext context, AppProvider provider) {
    switch (provider.bookingStep) {
      case 0:
        return const _StepSelectService(key: ValueKey(0));
      case 1:
        return const _StepSelectBarber(key: ValueKey(1));
      case 2:
        return const _StepSelectDateTime(key: ValueKey(2));
      case 3:
        return const _StepConfirm(key: ValueKey(3));
      default:
        return const _StepSelectService(key: ValueKey(0));
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _labels = ['Service', 'Barber', 'Date & Time', 'Confirm'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIndex < currentStep
                    ? AppTheme.primary
                    : context.appColors.divider,
              ),
            );
          }
          final step = index ~/ 2;
          final isActive = step == currentStep;
          final isDone = step < currentStep;
          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppTheme.primary
                      : isActive
                          ? AppTheme.primary.withOpacity(0.2)
                          : context.appColors.divider,
                  border: isActive
                      ? Border.all(color: AppTheme.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check,
                          color: Colors.black, size: 16)
                      : Text(
                          '${step + 1}',
                          style: TextStyle(
                            color: isActive
                                ? AppTheme.primary
                                : context.appColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _labels[step],
                style: TextStyle(
                  color: isActive || isDone
                      ? context.appColors.textPrimary
                      : context.appColors.textSecondary,
                  fontSize: 10,
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StepSelectService extends StatelessWidget {
  const _StepSelectService({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text('Choose a Service',
              style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allServices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final service = allServices[index];
              return GestureDetector(
                onTap: () =>
                    context.read<AppProvider>().selectService(service),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.appColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.appColors.divider),
                  ),
                  child: Row(
                    children: [
                      Text(service.emoji,
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.name,
                                style: TextStyle(
                                    color: context.appColors.textPrimary,
                                    fontWeight: FontWeight.w600)),
                            Text(
                              '${service.durationMinutes} min',
                              style: TextStyle(
                                  color: context.appColors.textSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${service.price.toInt()}',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right,
                          color: context.appColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepSelectBarber extends StatelessWidget {
  const _StepSelectBarber({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => provider.goToBookingStep(0),
                child: Icon(Icons.arrow_back,
                    color: context.appColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Choose a Barber',
                  style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        if (provider.selectedService != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: _SelectedServiceChip(service: provider.selectedService!),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Any barber option
              _BarberOption(
                barber: null,
                isSelected: false,
                onTap: () => provider.selectBarber(null),
              ),
              const SizedBox(height: 10),
              ...allBarbers.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BarberOption(
                      barber: b,
                      isSelected: false,
                      onTap: () => provider.selectBarber(b),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectedServiceChip extends StatelessWidget {
  final Service service;
  const _SelectedServiceChip({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(service.emoji, style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(service.name,
              style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text('\$${service.price.toInt()}',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _BarberOption extends StatelessWidget {
  final Barber? barber;
  final bool isSelected;
  final VoidCallback onTap;
  const _BarberOption(
      {this.barber, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? AppTheme.primary : context.appColors.divider),
        ),
        child: barber == null
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: context.appColors.divider,
                    child: Icon(Icons.shuffle, color: context.appColors.textSecondary),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Any Barber',
                            style: TextStyle(
                                color: context.appColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        Text('First available barber',
                            style: TextStyle(
                                color: context.appColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: context.appColors.textSecondary, size: 18),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: barber!.avatarColor,
                    child: Text(barber!.initials,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(barber!.name,
                            style: TextStyle(
                                color: context.appColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        Text(barber!.role,
                            style: TextStyle(
                                color: context.appColors.textSecondary,
                                fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: AppTheme.primary, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${barber!.rating}  •  ${barber!.specialties.take(2).join(', ')}',
                              style: TextStyle(
                                  color: context.appColors.textSecondary, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: context.appColors.textSecondary, size: 18),
                ],
              ),
      ),
    );
  }
}

class _StepSelectDateTime extends StatefulWidget {
  const _StepSelectDateTime({super.key});

  @override
  State<_StepSelectDateTime> createState() => _StepSelectDateTimeState();
}

class _StepSelectDateTimeState extends State<_StepSelectDateTime> {
  DateTime _selectedDay = DateTime.now();

  static const _timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
    '6:00 PM', '6:30 PM',
  ];

  // Simulate unavailable slots (every 3rd slot)
  bool _isAvailable(int index) => index % 3 != 2;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => provider.goToBookingStep(1),
                child: Icon(Icons.arrow_back,
                    color: context.appColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Select Date & Time',
                  style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker row
                Text('Date',
                    style: TextStyle(
                        color: context.appColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 14,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final day = now.add(Duration(days: index));
                      final isSelected = _selectedDay.year == day.year &&
                          _selectedDay.month == day.month &&
                          _selectedDay.day == day.day;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedDay = day);
                          provider.selectDate(day);
                        },
                        child: Container(
                          width: 56,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : context.appColors.card,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : context.appColors.divider,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(day),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : context.appColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('d').format(day),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : context.appColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(day),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black.withOpacity(0.7)
                                      : context.appColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text('Available Times',
                    style: TextStyle(
                        color: context.appColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = _timeSlots[index];
                    final available = _isAvailable(index);
                    final selected = provider.selectedTime == time;
                    return GestureDetector(
                      onTap: available
                          ? () => provider.selectTime(time)
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primary
                              : available
                                  ? context.appColors.card
                                  : context.appColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? AppTheme.primary
                                : context.appColors.divider,
                          ),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Colors.black
                                : available
                                    ? context.appColors.textPrimary
                                    : context.appColors.textSecondary
                                        .withOpacity(0.4),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            decoration: available
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.selectedDate != null &&
                            provider.selectedTime != null
                        ? () => provider.advanceToConfirmation()
                        : null,
                    child: Text('CONTINUE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepConfirm extends StatelessWidget {
  const _StepConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final service = provider.selectedService;
    final barber = provider.selectedBarber;
    final date = provider.selectedDate;
    final time = provider.selectedTime;

    if (service == null || date == null || time == null) {
      return const Center(
          child: Text('Missing booking details',
              style: TextStyle(color: context.appColors.textSecondary)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => provider.goToBookingStep(2),
                child: Icon(Icons.arrow_back,
                    color: context.appColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Confirm Booking',
                  style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              children: [
                Text('\u2702\ufe0f', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  'Your Appointment Summary',
                  style: GoogleFonts.playfairDisplay(
                    color: context.appColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _SummaryRow(
                  icon: Icons.content_cut,
                  label: 'Service',
                  value: service.name,
                ),
                Divider(color: context.appColors.divider, height: 24),
                _SummaryRow(
                  icon: Icons.person,
                  label: 'Barber',
                  value: barber?.name ?? 'Any Available Barber',
                ),
                Divider(color: context.appColors.divider, height: 24),
                _SummaryRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: DateFormat('EEEE, MMMM d, y').format(date),
                ),
                Divider(color: context.appColors.divider, height: 24),
                _SummaryRow(
                  icon: Icons.access_time,
                  label: 'Time',
                  value: time,
                ),
                Divider(color: context.appColors.divider, height: 24),
                _SummaryRow(
                  icon: Icons.timer_outlined,
                  label: 'Duration',
                  value: '${service.durationMinutes} minutes',
                ),
                Divider(color: context.appColors.divider, height: 24),
                Row(
                  children: [
                    Icon(Icons.attach_money,
                        color: AppTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Text('Total',
                        style: TextStyle(
                            color: context.appColors.textSecondary, fontSize: 14)),
                    const Spacer(),
                    Text(
                      '\$${service.price.toInt()}',
                      style: GoogleFonts.playfairDisplay(
                        color: AppTheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Points to earn banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.success.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.toll,
                    color: AppTheme.success, size: 16),
                const SizedBox(width: 8),
                Text(
                  "You'll earn ${provider.pendingPoints} loyalty points",
                  style: TextStyle(
                      color: AppTheme.success,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline,
                    color: AppTheme.primary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please arrive 5 minutes early. Cancellations accepted up to 2 hours before your appointment.',
                    style: TextStyle(
                        color: context.appColors.textSecondary, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final pts = provider.pendingPoints;
                final success = provider.confirmBooking();
                if (success) {
                  _showConfirmationDialog(context, pts);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('CONFIRM APPOINTMENT'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => provider.startFreshBooking(),
              child: Text('START OVER'),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int pointsEarned) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: context.appColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A3A1A),
              ),
              child: Icon(Icons.check,
                  color: AppTheme.success, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'Booked!',
              style: GoogleFonts.playfairDisplay(
                color: context.appColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been confirmed. We look forward to seeing you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: context.appColors.textSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.toll,
                      color: AppTheme.success, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '+$pointsEarned loyalty points earned!',
                    style: TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AppProvider>().setTab(0);
                },
                child: Text('BACK TO HOME'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 14)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
                color: context.appColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
