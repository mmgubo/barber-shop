import 'package:flutter/material.dart';

class Barber {
  final String id;
  final String name;
  final String role;
  final double rating;
  final int reviewCount;
  final List<String> specialties;
  final Color avatarColor;
  final String initials;

  const Barber({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewCount,
    required this.specialties,
    required this.avatarColor,
    required this.initials,
  });
}

final List<Barber> allBarbers = [
  const Barber(
    id: '1',
    name: 'Marcus Cole',
    role: 'Master Barber',
    rating: 4.9,
    reviewCount: 312,
    specialties: ['Fades', 'Classic Cuts', 'Beard Design'],
    avatarColor: Color(0xFF1565C0),
    initials: 'MC',
  ),
  const Barber(
    id: '2',
    name: 'Jordan Reed',
    role: 'Senior Stylist',
    rating: 4.8,
    reviewCount: 247,
    specialties: ['Coloring', 'Textured Cuts', 'Treatments'],
    avatarColor: Color(0xFF2E7D32),
    initials: 'JR',
  ),
  const Barber(
    id: '3',
    name: 'Alex Rivera',
    role: 'Barber & Stylist',
    rating: 4.7,
    reviewCount: 189,
    specialties: ['Hot Shaves', 'Pompadours', 'Skin Fades'],
    avatarColor: Color(0xFF6A1B9A),
    initials: 'AR',
  ),
  const Barber(
    id: '4',
    name: 'Sam Torres',
    role: 'Junior Barber',
    rating: 4.6,
    reviewCount: 94,
    specialties: ['Kids Cuts', 'Classic Styles'],
    avatarColor: Color(0xFFC62828),
    initials: 'ST',
  ),
];
