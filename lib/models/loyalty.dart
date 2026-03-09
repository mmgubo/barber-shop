import 'package:flutter/material.dart';

enum LoyaltyTier { bronze, silver, gold, platinum }

extension LoyaltyTierInfo on LoyaltyTier {
  String get label => switch (this) {
        LoyaltyTier.bronze => 'Bronze',
        LoyaltyTier.silver => 'Silver',
        LoyaltyTier.gold => 'Gold',
        LoyaltyTier.platinum => 'Platinum',
      };

  int get minPoints => switch (this) {
        LoyaltyTier.bronze => 0,
        LoyaltyTier.silver => 500,
        LoyaltyTier.gold => 1500,
        LoyaltyTier.platinum => 3000,
      };

  LoyaltyTier? get next => switch (this) {
        LoyaltyTier.bronze => LoyaltyTier.silver,
        LoyaltyTier.silver => LoyaltyTier.gold,
        LoyaltyTier.gold => LoyaltyTier.platinum,
        LoyaltyTier.platinum => null,
      };

  List<Color> get gradient => switch (this) {
        LoyaltyTier.bronze => const [Color(0xFF3D1F00), Color(0xFF6B3A1F)],
        LoyaltyTier.silver => const [Color(0xFF1A1A2E), Color(0xFF30305A)],
        LoyaltyTier.gold => const [Color(0xFF2A1900), Color(0xFF4A3300)],
        LoyaltyTier.platinum => const [Color(0xFF150A2A), Color(0xFF2E1A4A)],
      };

  Color get color => switch (this) {
        LoyaltyTier.bronze => const Color(0xFFCD7F32),
        LoyaltyTier.silver => const Color(0xFFC0C0C0),
        LoyaltyTier.gold => const Color(0xFFD4AF37),
        LoyaltyTier.platinum => const Color(0xFFD5BCFF),
      };

  String get tierIcon => switch (this) {
        LoyaltyTier.bronze => 'B',
        LoyaltyTier.silver => 'S',
        LoyaltyTier.gold => 'G',
        LoyaltyTier.platinum => 'P',
      };

  int get starCount => switch (this) {
        LoyaltyTier.bronze => 1,
        LoyaltyTier.silver => 2,
        LoyaltyTier.gold => 3,
        LoyaltyTier.platinum => 4,
      };
}

LoyaltyTier tierFromPoints(int points) {
  if (points >= 3000) return LoyaltyTier.platinum;
  if (points >= 1500) return LoyaltyTier.gold;
  if (points >= 500) return LoyaltyTier.silver;
  return LoyaltyTier.bronze;
}

class LoyaltyTransaction {
  final String id;
  final String description;
  final int points; // positive = earn, negative = redeem
  final DateTime date;
  final String emoji;

  const LoyaltyTransaction({
    required this.id,
    required this.description,
    required this.points,
    required this.date,
    required this.emoji,
  });

  bool get isEarn => points > 0;
}

class Reward {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String emoji;
  final String value;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.emoji,
    required this.value,
  });
}

const List<Reward> allRewards = [
  Reward(
    id: 'r1',
    title: '\$5 Off',
    description: 'Discount on any service',
    pointsCost: 500,
    emoji: '\ud83c\udff7',
    value: '\$5',
  ),
  Reward(
    id: 'r2',
    title: 'Free Beard Trim',
    description: 'Complimentary beard shaping',
    pointsCost: 1000,
    emoji: '\ud83e\uddd4',
    value: '\$20',
  ),
  Reward(
    id: 'r3',
    title: '\$15 Off',
    description: 'Discount on any service',
    pointsCost: 1500,
    emoji: '\ud83d\udcb8',
    value: '\$15',
  ),
  Reward(
    id: 'r4',
    title: 'Free Classic Cut',
    description: 'Complimentary classic haircut',
    pointsCost: 2000,
    emoji: '\u2702',
    value: '\$30',
  ),
  Reward(
    id: 'r5',
    title: 'Free Fade Cut',
    description: 'Complimentary fade haircut',
    pointsCost: 2500,
    emoji: '\u26a1',
    value: '\$35',
  ),
  Reward(
    id: 'r6',
    title: 'Free Hot Shave',
    description: 'Complimentary hot towel shave',
    pointsCost: 3000,
    emoji: '\ud83e\uddf4',
    value: '\$40',
  ),
  Reward(
    id: 'r7',
    title: 'Free Color',
    description: 'Full hair coloring treatment',
    pointsCost: 5000,
    emoji: '\ud83c\udfa8',
    value: '\$65',
  ),
];
