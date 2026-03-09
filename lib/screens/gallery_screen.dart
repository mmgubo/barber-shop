import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _selected = 'All';

  static const _categories = ['All', 'Fades', 'Classic', 'Beard', 'Color'];

  static const _items = [
    _GalleryItem(
        label: 'Low Fade',
        sub: 'Marcus',
        category: 'Fades',
        g1: Color(0xFF1A237E),
        g2: Color(0xFF283593)),
    _GalleryItem(
        label: 'High Skin Fade',
        sub: 'Alex',
        category: 'Fades',
        g1: Color(0xFF1B5E20),
        g2: Color(0xFF2E7D32)),
    _GalleryItem(
        label: 'Mid Fade',
        sub: 'Jordan',
        category: 'Fades',
        g1: Color(0xFF4A148C),
        g2: Color(0xFF6A1B9A)),
    _GalleryItem(
        label: 'Pompadour',
        sub: 'Marcus',
        category: 'Classic',
        g1: Color(0xFF880E4F),
        g2: Color(0xFFAD1457)),
    _GalleryItem(
        label: 'Side Part',
        sub: 'Sam',
        category: 'Classic',
        g1: Color(0xFF3E2723),
        g2: Color(0xFF5D4037)),
    _GalleryItem(
        label: 'Crew Cut',
        sub: 'Jordan',
        category: 'Classic',
        g1: Color(0xFF212121),
        g2: Color(0xFF424242)),
    _GalleryItem(
        label: 'Full Beard',
        sub: 'Marcus',
        category: 'Beard',
        g1: Color(0xFF1A237E),
        g2: Color(0xFF0D47A1)),
    _GalleryItem(
        label: 'Short Beard',
        sub: 'Alex',
        category: 'Beard',
        g1: Color(0xFF004D40),
        g2: Color(0xFF00695C)),
    _GalleryItem(
        label: 'Goatee',
        sub: 'Jordan',
        category: 'Beard',
        g1: Color(0xFFBF360C),
        g2: Color(0xFFD84315)),
    _GalleryItem(
        label: 'Highlights',
        sub: 'Jordan',
        category: 'Color',
        g1: Color(0xFF7B1FA2),
        g2: Color(0xFFE040FB)),
    _GalleryItem(
        label: 'Full Color',
        sub: 'Jordan',
        category: 'Color',
        g1: Color(0xFFF57F17),
        g2: Color(0xFFFBC02D)),
    _GalleryItem(
        label: 'Ombre',
        sub: 'Jordan',
        category: 'Color',
        g1: Color(0xFF006064),
        g2: Color(0xFF00BCD4)),
  ];

  List<_GalleryItem> get _filtered => _selected == 'All'
      ? _items
      : _items.where((i) => i.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery',
            style: GoogleFonts.playfairDisplay(
                color: AppTheme.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final sel = _selected == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: sel,
                  onSelected: (_) => setState(() => _selected = cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) =>
                  _GalleryCard(item: _filtered[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryItem {
  final String label;
  final String sub;
  final String category;
  final Color g1;
  final Color g2;
  const _GalleryItem({
    required this.label,
    required this.sub,
    required this.category,
    required this.g1,
    required this.g2,
  });
}

class _GalleryCard extends StatelessWidget {
  final _GalleryItem item;
  const _GalleryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item.g1, item.g2],
        ),
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Scissors icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.content_cut,
                  color: Colors.white.withOpacity(0.2),
                  size: 56,
                ),
              ],
            ),
          ),
          // Bottom label
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.white54, size: 11),
                      const SizedBox(width: 3),
                      Text(
                        item.sub,
                        style: TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Category badge
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
