import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavBarItem(
              icon: Icons.add_rounded,
              label: 'Create',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
              isCenter: true,
            ),
            _NavBarItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isCenter;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withOpacity(0.6);
    final centerColor = selected ? colorScheme.onPrimary : colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 22 : 16,
          vertical: isCenter ? 0 : 6,
        ),
        decoration: isCenter
            ? BoxDecoration(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isCenter ? 34 : 26,
              color: isCenter ? centerColor : color,
              shadows: isCenter && selected
                  ? [
                      Shadow(
                        color: colorScheme.primary.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            if (!isCenter) const SizedBox(height: 4),
            if (!isCenter)
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  letterSpacing: selected ? 0.5 : 0,
                ),
                child: Text(label),
              ),
          ],
        ),
      ),
    );
  }
}
