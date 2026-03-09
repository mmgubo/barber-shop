import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/service.dart';
import '../models/barber.dart';
import '../models/loyalty.dart';
import '../providers/app_provider.dart';
import 'loyalty_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(),
            _StatsBar(),
            _LoyaltyCard(),
            _FeaturedServicesSection(),
            _BarbersSection(),
            _TestimonialsSection(),
            _PromoBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1200)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.08), width: 1.5),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.12), width: 1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PREMIUM BARBERSHOP',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => provider.setTab(3),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: Icon(Icons.notifications_none,
                            color: context.appColors.textSecondary, size: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Barber pole icon
                Text('\u2988', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(
                  'THE\nSHARP\nEDGE',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Where style meets precision',
                  style: TextStyle(
                    color: context.appColors.textSecondary,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.startFreshBooking();
                        provider.setTab(2);
                      },
                      icon: Icon(Icons.calendar_today, size: 16),
                      label: Text('BOOK NOW'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => provider.setTab(1),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                      ),
                      child: Text('SERVICES'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '12+', label: 'Years'),
          _Divider(),
          _StatItem(value: '5K+', label: 'Clients'),
          _Divider(),
          _StatItem(value: '4.9', label: 'Rating'),
          _Divider(),
          _StatItem(value: '4', label: 'Barbers'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: context.appColors.divider);
  }
}

class _FeaturedServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featured = allServices.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Services',
                style: GoogleFonts.playfairDisplay(
                  color: context.appColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.read<AppProvider>().setTab(1),
                child: Text('See All',
                    style: TextStyle(color: AppTheme.primary)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _ServiceCard(service: featured[index]),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppProvider>().startBookingWithService(service);
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.emoji, style: TextStyle(fontSize: 28)),
            const Spacer(),
            Text(
              service.name,
              style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${service.price.toInt()}',
              style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarbersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            'Meet Our Barbers',
            style: GoogleFonts.playfairDisplay(
              color: context.appColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: allBarbers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _BarberCard(barber: allBarbers[index]),
          ),
        ),
      ],
    );
  }
}

class _BarberCard extends StatelessWidget {
  final Barber barber;
  const _BarberCard({required this.barber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: barber.avatarColor,
            child: Text(
              barber.initials,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            barber.name,
            style: TextStyle(
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            barber.role,
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: AppTheme.primary, size: 14),
              const SizedBox(width: 3),
              Text(
                barber.rating.toString(),
                style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                ' (${barber.reviewCount})',
                style: TextStyle(
                    color: context.appColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestimonialsSection extends StatelessWidget {
  static const _reviews = [
    (
      name: 'James W.',
      text: 'Best fade in the city. Marcus really knows his craft.',
      stars: 5
    ),
    (
      name: 'David K.',
      text: 'Hot towel shave was incredible. Felt like royalty.',
      stars: 5
    ),
    (
      name: 'Carlos M.',
      text: 'Great atmosphere, professional barbers. My go-to shop.',
      stars: 5
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            'What Clients Say',
            style: GoogleFonts.playfairDisplay(
              color: context.appColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _reviews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final r = _reviews[index];
              return Container(
                width: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.appColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        r.stars,
                        (_) => Icon(Icons.star,
                            color: AppTheme.primary, size: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r.text,
                      style: TextStyle(
                          color: context.appColors.textSecondary,
                          fontSize: 13,
                          height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '— ${r.name}',
                      style: TextStyle(
                          color: context.appColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final tier = provider.loyaltyTier;
    final points = provider.loyaltyPoints;
    final nextTier = tier.next;
    final progress = nextTier != null
        ? ((points - tier.minPoints) /
                (nextTier.minPoints - tier.minPoints))
            .clamp(0.0, 1.0)
        : 1.0;
    final toNext = nextTier != null ? nextTier.minPoints - points : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoyaltyScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: tier.gradient,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: tier.color.withOpacity(0.35), width: 1.5),
          ),
          child: Row(
            children: [
              // Tier badge
              Container(
                width: 48,
                height: 48,
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
                        fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
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
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            Colors.white.withOpacity(0.08),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tier.color),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nextTier != null
                          ? '$toNext pts to ${nextTier.label}'
                          : 'Maximum tier achieved!',
                      style: TextStyle(
                          color: tier.color.withOpacity(0.6),
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  color: tier.color.withOpacity(0.6), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A1F00), Color(0xFF1A1200)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.primary.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NEW CLIENT OFFER',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '20% OFF\nFirst Visit',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppProvider>().startFreshBooking();
                      context.read<AppProvider>().setTab(2);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('CLAIM OFFER',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            Text('\u2702\ufe0f', style: TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }
}
