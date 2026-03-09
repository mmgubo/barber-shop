import 'service.dart';
import 'barber.dart';

class Appointment {
  final String id;
  final Service service;
  final Barber? barber;
  final DateTime date;
  final String time;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.service,
    this.barber,
    required this.date,
    required this.time,
    this.status = AppointmentStatus.confirmed,
  });

  String get barberName => barber?.name ?? 'Any Barber';
}

enum AppointmentStatus { confirmed, completed, cancelled }
