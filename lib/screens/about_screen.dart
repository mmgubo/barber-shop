import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _hours = [
    ('Monday', '9:00 AM - 8:00 PM'),
    ('Tuesday', '9:00 AM - 8:00 PM'),
    ('Wednesday', '9:00 AM - 8:00 PM'),
    ('Thursday', '9:00 AM - 9:00 PM'),
    ('Friday', '9:00 AM - 9:00 PM'),
    ('Saturday', '8:00 AM - 9:00 PM'),
    ('Sunday', '10:00 AM - 6:00 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us',
            style: GoogleFonts.playfairDisplay(
                color: AppTheme.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Appearance toggle ──────────────────────────────
            _AppearanceCard(),
            const SizedBox(height: 24),

            // ── Shop Header ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1200), Color(0xFF0A0A0A)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  Text('\u2702\ufe0f',
                      style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'THE SHARP EDGE',
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Premium Barbershop',
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          color: AppTheme.primary, size: 16),
                      const Icon(Icons.star,
                          color: AppTheme.primary, size: 16),
                      const Icon(Icons.star,
                          color: AppTheme.primary, size: 16),
                      const Icon(Icons.star,
                          color: AppTheme.primary, size: 16),
                      const Icon(Icons.star,
                          color: AppTheme.primary, size: 16),
                      const SizedBox(width: 6),
                      const Text('4.9 · 842 reviews',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Our Story ──────────────────────────────────────
            _SectionTitle(title: 'Our Story'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Text(
                'The Sharp Edge was founded in 2012 with a simple mission: '
                'to bring back the craft of classic barbering with a modern touch. '
                'Our team of highly skilled barbers combines traditional techniques '
                'with contemporary styles to give every client the perfect cut.\n\n'
                'We believe a great haircut is more than just a trim — it\'s an '
                'experience. From the moment you walk in, you\'ll enjoy a relaxed '
                'atmosphere, expert consultation, and premium grooming services.',
                style: TextStyle(
                    color: context.appColors.textSecondary,
                    fontSize: 14,
                    height: 1.6),
              ),
            ),

            const SizedBox(height: 24),

            // ── Business Hours ─────────────────────────────────
            _SectionTitle(title: 'Business Hours'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Column(
                children: _hours.asMap().entries.map((entry) {
                  final i = entry.key;
                  final day = entry.value.$1;
                  final hours = entry.value.$2;
                  final isToday = i == todayIndex;
                  final isLast = i == _hours.length - 1;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isToday
                              ? AppTheme.primary.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: isLast
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12))
                              : i == 0
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))
                                  : null,
                        ),
                        child: Row(
                          children: [
                            if (isToday)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.primary,
                                ),
                              )
                            else
                              const SizedBox(width: 14),
                            Text(
                              day,
                              style: TextStyle(
                                color: isToday
                                    ? AppTheme.primary
                                    : context.appColors.textPrimary,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Today',
                                    style: TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              hours,
                              style: TextStyle(
                                color: isToday
                                    ? AppTheme.primary
                                    : context.appColors.textSecondary,
                                fontSize: 13,
                                fontWeight: isToday
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Divider(
                            color: context.appColors.divider,
                            height: 1,
                            indent: 16,
                            endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Contact Info ───────────────────────────────────
            _SectionTitle(title: 'Contact Us'),
            const SizedBox(height: 12),
            _ContactCard(
              icon: Icons.location_on,
              title: 'Address',
              value: '142 West 46th Street\nNew York, NY 10036',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ContactCard(
              icon: Icons.phone,
              title: 'Phone',
              value: '(212) 555-0147',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ContactCard(
              icon: Icons.email_outlined,
              title: 'Email',
              value: 'hello@thesharpedge.com',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // ── Map placeholder ────────────────────────────────
            _SectionTitle(title: 'Find Us'),
            const SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.appColors.divider),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A2A1A), Color(0xFF0F1A0F)],
                ),
              ),
              child: Stack(
                children: [
                  ...List.generate(5, (i) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: i * 36.0,
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    );
                  }),
                  ...List.generate(8, (i) {
                    return Positioned(
                      top: 0,
                      bottom: 0,
                      left: i * 46.0,
                      child: Container(
                        width: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    );
                  }),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.location_on,
                              color: Colors.black, size: 24),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.appColors.card.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppTheme.primary.withOpacity(0.4)),
                          ),
                          child: const Text(
                            'The Sharp Edge',
                            style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Social media ───────────────────────────────────
            _SectionTitle(title: 'Follow Us'),
            const SizedBox(height: 12),
            Row(
              children: [
                _SocialButton(
                    icon: Icons.camera_alt_outlined, label: 'Instagram'),
                const SizedBox(width: 10),
                _SocialButton(
                    icon: Icons.facebook_outlined, label: 'Facebook'),
                const SizedBox(width: 10),
                _SocialButton(
                    icon: Icons.alternate_email, label: 'Twitter'),
              ],
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'The Sharp Edge \u00a9 2012\u20132026',
                style: TextStyle(
                    color: context.appColors.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Appearance toggle card ──────────────────────────────────────

class _AppearanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance',
                        style: TextStyle(
                            color: context.appColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      Text(
                        isDark ? 'Dark mode' : 'Light mode',
                        style: TextStyle(
                            color: context.appColors.textSecondary,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isDark,
                  onChanged: (_) => provider.toggleTheme(),
                  activeColor: AppTheme.primary,
                  activeTrackColor: AppTheme.primary.withOpacity(0.3),
                  inactiveThumbColor: context.appColors.textSecondary,
                  inactiveTrackColor:
                      context.appColors.divider,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.appColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _ThemeOption(
                  icon: Icons.dark_mode,
                  label: 'Dark',
                  selected: isDark,
                  onTap: () {
                    if (!isDark) provider.toggleTheme();
                  },
                ),
                const SizedBox(width: 10),
                _ThemeOption(
                  icon: Icons.light_mode,
                  label: 'Light',
                  selected: !isDark,
                  onTap: () {
                    if (isDark) provider.toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withOpacity(0.12)
                : context.appColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? AppTheme.primary.withOpacity(0.5)
                  : context.appColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppTheme.primary
                    : context.appColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppTheme.primary
                      : context.appColors.textSecondary,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        color: context.appColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: context.appColors.textSecondary,
                        fontSize: 11)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: context.appColors.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.appColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: context.appColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
