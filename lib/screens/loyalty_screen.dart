import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/loyalty.dart';
import '../providers/app_provider.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rewards',
          style: GoogleFonts.playfairDisplay(
              color: AppTheme.primary,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final tier = provider.loyaltyTier;
          final points = provider.loyaltyPoints;
          final nextTier = tier.next;
          final progress = nextTier != null
              ? ((points - tier.minPoints) /
                      (nextTier.minPoints - tier.minPoints))
                  .clamp(0.0, 1.0)
              : 1.0;
          final toNext =
              nextTier != null ? nextTier.minPoints - points : 0;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TierCard(
                      tier: tier,
                      points: points,
                      progress: progress,
                      toNext: toNext,
                      nextTier: nextTier,
                    ),
                    _StatsRow(provider: provider),
                    _TierProgressRow(tier: tier),
                  ],
                ),
              ),
              _RewardsSection(points: points, provider: provider),
              _HistorySection(history: provider.loyaltyHistory),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ── Tier card ───────────────────────────────────────────────────

class _TierCard extends StatelessWidget {
  final LoyaltyTier tier;
  final int points;
  final double progress;
  final int toNext;
  final LoyaltyTier? nextTier;

  const _TierCard({
    required this.tier,
    required this.points,
    required this.progress,
    required this.toNext,
    required this.nextTier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tier.gradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: tier.color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: tier.color.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tier.color.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tier.color.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: tier badge + label
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tier.color.withOpacity(0.2),
                      border: Border.all(color: tier.color, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        tier.tierIcon,
                        style: TextStyle(
                          color: tier.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tier.label} Member',
                        style: TextStyle(
                          color: tier.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: List.generate(4, (i) {
                          return Icon(
                            i < tier.starCount
                                ? Icons.star
                                : Icons.star_border,
                            color: i < tier.starCount
                                ? tier.color
                                : tier.color.withOpacity(0.3),
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'THE SHARP EDGE',
                    style: TextStyle(
                      color: tier.color.withOpacity(0.5),
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Points
              Text(
                '$points',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                'POINTS',
                style: TextStyle(
                  color: tier.color,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tier.color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                        color: tier.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                nextTier != null
                    ? '$toNext pts to ${nextTier!.label}'
                    : 'Maximum tier achieved!',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stats row ───────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AppProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Row(
          children: [
            _StatCell(
              value: '${provider.totalPointsEarned}',
              label: 'Total Earned',
            ),
            Container(width: 1, height: 36, color: context.appColors.divider),
            _StatCell(
              value: '${provider.totalPointsRedeemed}',
              label: 'Redeemed',
            ),
            Container(width: 1, height: 36, color: context.appColors.divider),
            _StatCell(
              value: '${provider.completedVisits}',
              label: 'Visits',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
                color: AppTheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: context.appColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Tier progress row ───────────────────────────────────────────

class _TierProgressRow extends StatelessWidget {
  final LoyaltyTier tier;
  const _TierProgressRow({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: LoyaltyTier.values.map((t) {
          final isActive = t == tier;
          final isPast = t.index < tier.index;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isPast || isActive
                              ? t.color
                              : context.appColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.label,
                        style: TextStyle(
                          color: isActive
                              ? t.color
                              : isPast
                                  ? context.appColors.textSecondary
                                  : context.appColors.divider,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        t.minPoints == 0 ? '0' : '${t.minPoints}+',
                        style: TextStyle(
                          color: isActive
                              ? t.color.withOpacity(0.7)
                              : context.appColors.divider,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (t != LoyaltyTier.platinum)
                  const SizedBox(width: 4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Rewards section ─────────────────────────────────────────────

class _RewardsSection extends StatelessWidget {
  final int points;
  final AppProvider provider;
  const _RewardsSection({required this.points, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Text(
                'Rewards',
                style: GoogleFonts.playfairDisplay(
                  color: context.appColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$points pts available',
                  style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: allRewards.length,
          itemBuilder: (context, i) =>
              _RewardCard(reward: allRewards[i], points: points, provider: provider),
        ),
      ]),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final Reward reward;
  final int points;
  final AppProvider provider;
  const _RewardCard(
      {required this.reward, required this.points, required this.provider});

  bool get canAfford => points >= reward.pointsCost;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: canAfford
              ? AppTheme.primary.withOpacity(0.4)
              : context.appColors.divider,
          width: canAfford ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(reward.emoji, style: TextStyle(fontSize: 24)),
              const Spacer(),
              if (!canAfford)
                Icon(Icons.lock_outline,
                    color: context.appColors.textSecondary, size: 14)
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Available',
                      style: TextStyle(
                          color: AppTheme.success,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const Spacer(),
          Text(
            reward.title,
            style: TextStyle(
              color: canAfford
                  ? context.appColors.textPrimary
                  : context.appColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            reward.description,
            style: TextStyle(
                color: context.appColors.textSecondary, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canAfford
                  ? () => _confirmRedeem(context)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
                disabledBackgroundColor:
                    context.appColors.divider.withOpacity(0.5),
              ),
              child: Text(
                canAfford
                    ? 'Redeem · ${reward.pointsCost} pts'
                    : '${reward.pointsCost} pts',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRedeem(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(reward.emoji,
                style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              reward.title,
              style: GoogleFonts.playfairDisplay(
                  color: context.appColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              reward.description,
              style: TextStyle(
                  color: context.appColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Value: ${reward.value}',
              style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.toll,
                      color: AppTheme.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${reward.pointsCost} points will be deducted',
                    style: TextStyle(
                        color: context.appColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: context.appColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final success = provider.redeemReward(reward);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${reward.title} redeemed! Show this at the counter.'),
                    backgroundColor: context.appColors.surface,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text('Confirm Redemption'),
          ),
        ],
      ),
    );
  }
}

// ── History section ─────────────────────────────────────────────

class _HistorySection extends StatelessWidget {
  final List<LoyaltyTransaction> history;
  const _HistorySection({required this.history});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Points History',
            style: GoogleFonts.playfairDisplay(
              color: context.appColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (history.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('No transactions yet.',
                style: TextStyle(color: context.appColors.textSecondary)),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Column(
                children: history.asMap().entries.map((entry) {
                  final i = entry.key;
                  final t = entry.value;
                  final isLast = i == history.length - 1;
                  return Column(
                    children: [
                      _HistoryRow(transaction: t),
                      if (!isLast)
                        Divider(
                            color: context.appColors.divider,
                            height: 1,
                            indent: 56,
                            endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ]),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final LoyaltyTransaction transaction;
  const _HistoryRow({required this.transaction});

  String get _relativeDate {
    final diff = DateTime.now().difference(transaction.date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 30) return '${(diff / 7).floor()}w ago';
    if (diff < 365) return '${(diff / 30).floor()}mo ago';
    return '${(diff / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    final isEarn = transaction.isEarn;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEarn
                  ? AppTheme.success.withOpacity(0.12)
                  : Colors.redAccent.withOpacity(0.12),
            ),
            child: Center(
              child: Text(transaction.emoji,
                  style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  _relativeDate,
                  style: TextStyle(
                      color: context.appColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            isEarn
                ? '+${transaction.points} pts'
                : '${transaction.points} pts',
            style: TextStyle(
              color: isEarn ? AppTheme.success : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
