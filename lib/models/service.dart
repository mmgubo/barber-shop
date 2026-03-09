class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String emoji;
  final String category;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.emoji,
    required this.category,
  });
}

final List<Service> allServices = [
  const Service(
    id: '1',
    name: 'Classic Haircut',
    description: 'Precision cut tailored to your personal style',
    price: 30,
    durationMinutes: 30,
    emoji: '\u2702',
    category: 'Cuts',
  ),
  const Service(
    id: '2',
    name: 'Fade Haircut',
    description: 'High, mid, or low fade with crisp blending',
    price: 35,
    durationMinutes: 35,
    emoji: '\u26a1',
    category: 'Cuts',
  ),
  const Service(
    id: '3',
    name: 'Kids Haircut',
    description: 'Friendly cut for children under 12',
    price: 20,
    durationMinutes: 25,
    emoji: '\u2728',
    category: 'Cuts',
  ),
  const Service(
    id: '4',
    name: 'Beard Trim',
    description: 'Shape and define your beard to perfection',
    price: 20,
    durationMinutes: 20,
    emoji: '\ud83e\uddd4',
    category: 'Shave',
  ),
  const Service(
    id: '5',
    name: 'Hot Towel Shave',
    description: 'Traditional straight razor shave with hot towel',
    price: 40,
    durationMinutes: 45,
    emoji: '\ud83e\uddf4',
    category: 'Shave',
  ),
  const Service(
    id: '6',
    name: 'Hair + Beard Combo',
    description: 'Complete grooming package — cut and beard trim',
    price: 50,
    durationMinutes: 55,
    emoji: '\ud83d\udc88',
    category: 'Cuts',
  ),
  const Service(
    id: '7',
    name: 'Hair Coloring',
    description: 'Professional full color or highlights treatment',
    price: 65,
    durationMinutes: 90,
    emoji: '\ud83c\udfa8',
    category: 'Color',
  ),
  const Service(
    id: '8',
    name: 'Scalp Treatment',
    description: 'Deep moisturizing scalp massage and conditioning',
    price: 30,
    durationMinutes: 30,
    emoji: '\ud83d\udcab',
    category: 'Treatment',
  ),
  const Service(
    id: '9',
    name: 'Eyebrow Trim',
    description: 'Clean up and shape your eyebrows',
    price: 15,
    durationMinutes: 15,
    emoji: '\ud83d\udc41',
    category: 'Treatment',
  ),
  const Service(
    id: '10',
    name: 'Keratin Treatment',
    description: 'Smoothing and strengthening hair treatment',
    price: 80,
    durationMinutes: 120,
    emoji: '\ud83c\udf1f',
    category: 'Treatment',
  ),
];
