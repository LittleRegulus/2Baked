import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'discover_page.dart';
import 'profile_page.dart';
import 'timer_page.dart';

class TwoBakedApp extends StatefulWidget {
  const TwoBakedApp({super.key, required this.controller});

  final AppController controller;

  @override
  State<TwoBakedApp> createState() => _TwoBakedAppState();
}

class _TwoBakedAppState extends State<TwoBakedApp> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2Baked — Dab Timer',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AppShell(controller: widget.controller),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    TimerPage(controller: widget.controller),
    DiscoverPage(controller: widget.controller),
    ProfilePage(controller: widget.controller),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0C131C),
                  AppColors.background,
                  Color(0xFF0A0E14),
                ],
              ),
            ),
            child: SafeArea(
              bottom: desktop,
              child: desktop
                  ? Row(
                      children: [
                        _DesktopSidebar(
                          selectedIndex: _selectedIndex,
                          onSelected: (value) =>
                              setState(() => _selectedIndex = value),
                        ),
                        const VerticalDivider(width: 1, thickness: 1),
                        Expanded(
                          child: IndexedStack(
                            index: _selectedIndex,
                            children: _pages,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const _MobileHeader(),
                        Expanded(
                          child: IndexedStack(
                            index: _selectedIndex,
                            children: _pages,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (value) =>
                      setState(() => _selectedIndex = value),
                  backgroundColor: const Color(0xFF0D141D),
                  indicatorColor: AppColors.ember.withValues(alpha: 0.18),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.timer_outlined),
                      selectedIcon: Icon(
                        Icons.timer_rounded,
                        color: AppColors.ember,
                      ),
                      label: 'Timer',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.auto_awesome_outlined),
                      selectedIcon: Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.ice,
                      ),
                      label: 'Learn',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.lime,
                      ),
                      label: 'My stash',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xCC0B1119),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          BrandMark(size: 50),
          SizedBox(width: 8),
          BrandWordmark(fontSize: 18),
          Spacer(),
          StatusPill(
            icon: Icons.offline_bolt_outlined,
            label: 'PWA',
            color: AppColors.lime,
          ),
        ],
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 242,
      color: const Color(0xB80B1119),
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                BrandMark(size: 58),
                SizedBox(width: 8),
                BrandWordmark(fontSize: 20),
              ],
            ),
          ),
          const SizedBox(height: 38),
          _SidebarItem(
            icon: Icons.timer_outlined,
            selectedIcon: Icons.timer_rounded,
            label: 'Dab timer',
            selected: selectedIndex == 0,
            color: AppColors.ember,
            onTap: () => onSelected(0),
          ),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.auto_awesome_outlined,
            selectedIcon: Icons.auto_awesome_rounded,
            label: 'Facts & tips',
            selected: selectedIndex == 1,
            color: AppColors.ice,
            onTap: () => onSelected(1),
          ),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'My stash',
            selected: selectedIndex == 2,
            color: AppColors.lime,
            onTap: () => onSelected(2),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.cream,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'KEEP IT SAFE',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'For adults where legal. Never drive impaired.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Center(
            child: Text(
              'PRIVATE • LOCAL • YOURS',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 9, letterSpacing: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.11)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: 0.25)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: selected ? color : AppColors.muted,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.text : AppColors.muted,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
