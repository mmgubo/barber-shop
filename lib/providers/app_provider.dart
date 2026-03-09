import 'package:flutter/foundation.dart';
import '../models/service.dart';
import '../models/barber.dart';
import '../models/appointment.dart';
import '../models/loyalty.dart';

class AppProvider extends ChangeNotifier {
  int _currentTab = 0;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  final List<Appointment> _appointments = _buildSampleAppointments();
  int _loyaltyPoints = 700;
  final List<LoyaltyTransaction> _loyaltyHistory = _buildSampleHistory();

  // Booking wizard state
  Service? _selectedService;
  Barber? _selectedBarber;
  DateTime? _selectedDate;
  String? _selectedTime;
  int _bookingStep = 0;

  // ── Getters ────────────────────────────────────────────────────

  int get currentTab => _currentTab;
  List<Appointment> get appointments => List.unmodifiable(_appointments);
  Service? get selectedService => _selectedService;
  Barber? get selectedBarber => _selectedBarber;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  int get bookingStep => _bookingStep;

  int get loyaltyPoints => _loyaltyPoints;
  LoyaltyTier get loyaltyTier => tierFromPoints(_loyaltyPoints);
  List<LoyaltyTransaction> get loyaltyHistory =>
      List.unmodifiable(_loyaltyHistory);

  int get totalPointsEarned => _loyaltyHistory
      .where((t) => t.isEarn)
      .fold(0, (sum, t) => sum + t.points);

  int get totalPointsRedeemed => _loyaltyHistory
      .where((t) => !t.isEarn)
      .fold(0, (sum, t) => sum + t.points.abs());

  int get completedVisits =>
      _appointments.where((a) => a.status != AppointmentStatus.cancelled).length;

  // ── Navigation ─────────────────────────────────────────────────

  void setTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }

  // ── Booking flow ───────────────────────────────────────────────

  void startBookingWithService(Service service) {
    _selectedService = service;
    _selectedBarber = null;
    _selectedDate = null;
    _selectedTime = null;
    _bookingStep = 1;
    _currentTab = 2;
    notifyListeners();
  }

  void startFreshBooking() {
    _selectedService = null;
    _selectedBarber = null;
    _selectedDate = null;
    _selectedTime = null;
    _bookingStep = 0;
    notifyListeners();
  }

  void selectService(Service service) {
    _selectedService = service;
    _bookingStep = 1;
    notifyListeners();
  }

  void selectBarber(Barber? barber) {
    _selectedBarber = barber;
    _bookingStep = 2;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void goToBookingStep(int step) {
    _bookingStep = step;
    notifyListeners();
  }

  void advanceToConfirmation() {
    _bookingStep = 3;
    notifyListeners();
  }

  /// Returns the points that would be earned for the pending booking.
  int get pendingPoints =>
      _selectedService != null ? (_selectedService!.price * 10).toInt() : 0;

  bool confirmBooking() {
    if (_selectedService != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      final service = _selectedService!;
      _appointments.add(Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        service: service,
        barber: _selectedBarber,
        date: _selectedDate!,
        time: _selectedTime!,
      ));
      _awardPoints(
        (service.price * 10).toInt(),
        service.name,
        service.emoji,
        DateTime.now(),
      );
      _selectedService = null;
      _selectedBarber = null;
      _selectedDate = null;
      _selectedTime = null;
      _bookingStep = 0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void cancelAppointment(String id) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = Appointment(
        id: _appointments[index].id,
        service: _appointments[index].service,
        barber: _appointments[index].barber,
        date: _appointments[index].date,
        time: _appointments[index].time,
        status: AppointmentStatus.cancelled,
      );
      notifyListeners();
    }
  }

  // ── Loyalty ────────────────────────────────────────────────────

  /// Returns true if redemption succeeded, false if insufficient points.
  bool redeemReward(Reward reward) {
    if (_loyaltyPoints < reward.pointsCost) return false;
    _loyaltyPoints -= reward.pointsCost;
    _loyaltyHistory.insert(
      0,
      LoyaltyTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: 'Redeemed: ${reward.title}',
        points: -reward.pointsCost,
        date: DateTime.now(),
        emoji: reward.emoji,
      ),
    );
    notifyListeners();
    return true;
  }

  void _awardPoints(
      int points, String description, String emoji, DateTime date) {
    _loyaltyPoints += points;
    _loyaltyHistory.insert(
      0,
      LoyaltyTransaction(
        id: '${date.millisecondsSinceEpoch}',
        description: description,
        points: points,
        date: date,
        emoji: emoji,
      ),
    );
  }

  // ── Sample data ────────────────────────────────────────────────

  static List<Appointment> _buildSampleAppointments() {
    final now = DateTime.now();
    return [
      Appointment(
        id: 'sample_1',
        service: allServices[0],
        barber: allBarbers[0],
        date: now.add(const Duration(days: 2)),
        time: '10:30 AM',
      ),
      Appointment(
        id: 'sample_2',
        service: allServices[4],
        barber: allBarbers[2],
        date: now.add(const Duration(days: 5)),
        time: '2:00 PM',
      ),
      Appointment(
        id: 'sample_3',
        service: allServices[5],
        barber: allBarbers[1],
        date: now.add(const Duration(days: 11)),
        time: '11:00 AM',
      ),
      Appointment(
        id: 'sample_4',
        service: allServices[1],
        barber: allBarbers[0],
        date: now.subtract(const Duration(days: 8)),
        time: '9:30 AM',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: 'sample_5',
        service: allServices[3],
        barber: allBarbers[2],
        date: now.subtract(const Duration(days: 21)),
        time: '4:00 PM',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: 'sample_6',
        service: allServices[6],
        barber: allBarbers[1],
        date: now.subtract(const Duration(days: 45)),
        time: '1:00 PM',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: 'sample_7',
        service: allServices[7],
        barber: allBarbers[3],
        date: now.subtract(const Duration(days: 3)),
        time: '3:30 PM',
        status: AppointmentStatus.cancelled,
      ),
      Appointment(
        id: 'sample_8',
        service: allServices[0],
        barber: null,
        date: now.add(const Duration(days: 1)),
        time: '5:00 PM',
        status: AppointmentStatus.cancelled,
      ),
    ];
  }

  /// Sample history matches the completed sample appointments.
  /// Net: +650 (color) +200 (beard) +350 (fade) -500 (redeemed) = 700 pts → Silver
  static List<LoyaltyTransaction> _buildSampleHistory() {
    final now = DateTime.now();
    return [
      LoyaltyTransaction(
        id: 'h4',
        description: 'Fade Haircut',
        points: 350,
        date: now.subtract(const Duration(days: 8)),
        emoji: '\u26a1',
      ),
      LoyaltyTransaction(
        id: 'h3',
        description: 'Redeemed: \$5 Off',
        points: -500,
        date: now.subtract(const Duration(days: 15)),
        emoji: '\ud83c\udff7',
      ),
      LoyaltyTransaction(
        id: 'h2',
        description: 'Beard Trim',
        points: 200,
        date: now.subtract(const Duration(days: 21)),
        emoji: '\ud83e\uddd4',
      ),
      LoyaltyTransaction(
        id: 'h1',
        description: 'Hair Coloring',
        points: 650,
        date: now.subtract(const Duration(days: 45)),
        emoji: '\ud83c\udfa8',
      ),
    ];
  }
}
