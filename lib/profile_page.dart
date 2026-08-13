import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'content.dart';
import 'models.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.controller});

  final AppController controller;

  Future<void> _editName(BuildContext context) async {
    final textController = TextEditingController(text: controller.profileName);
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('What should we call you?'),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLength: 22,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Display name'),
          onSubmitted: (_) => Navigator.pop(dialogContext, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (save == true) controller.setProfileName(textController.text);
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 28, 18, 42),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileHeader(
                  controller: controller,
                  onEdit: () => _editName(context),
                ),
                const SizedBox(height: 22),
                _StatsGrid(controller: controller),
                const SizedBox(height: 26),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 820;
                    final gear = _GearPanel(controller: controller);
                    final settings = _SettingsPanel(controller: controller);
                    if (!wide) {
                      return Column(
                        children: [gear, const SizedBox(height: 18), settings],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: gear),
                        const SizedBox(width: 18),
                        Expanded(flex: 4, child: settings),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 26),
                _HistoryPanel(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.controller, required this.onEdit});

  final AppController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.ember.withValues(alpha: 0.8),
                  AppColors.ice.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Text(
              controller.profileName.characters.first.toUpperCase(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.profileName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  '${controller.selectedGear} • ${controller.history.length} logged sessions',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit display name',
            onPressed: onEdit,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundSoft,
              side: const BorderSide(color: AppColors.border),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 780 ? 4 : 2;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final favorite = controller.favoritePreset;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: width,
              child: _StatCard(
                icon: Icons.today_rounded,
                value: '${controller.todayCount}',
                label: 'Today',
                color: AppColors.lime,
              ),
            ),
            SizedBox(
              width: width,
              child: _StatCard(
                icon: Icons.auto_graph_rounded,
                value: '${controller.history.length}',
                label: 'All time',
                color: AppColors.ember,
              ),
            ),
            SizedBox(
              width: width,
              child: _StatCard(
                icon: Icons.star_rounded,
                value: favorite?.name ?? '—',
                label: 'Favorite',
                color: AppColors.cream,
                compactValue: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _StatCard(
                icon: Icons.tune_rounded,
                value: '${controller.customPresets.length}',
                label: 'Custom timers',
                color: AppColors.ice,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.compactValue = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 13),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: compactValue ? 17 : 25,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _GearPanel extends StatelessWidget {
  const _GearPanel({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Your setup',
            subtitle: 'Saved with every logged session.',
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 500;
              const gap = 9.0;
              final width = twoColumns
                  ? (constraints.maxWidth - gap) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final gear in gearOptions)
                    SizedBox(
                      width: width,
                      child: _GearChoice(
                        label: gear,
                        selected: controller.selectedGear == gear,
                        onTap: () => controller.setGear(gear),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GearChoice extends StatelessWidget {
  const _GearChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.ice.withValues(alpha: 0.11)
                : AppColors.backgroundSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.ice.withValues(alpha: 0.5)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? AppColors.ice : AppColors.muted,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Session vibe',
            subtitle: 'Tune the voice and ready callouts.',
          ),
          const SizedBox(height: 18),
          Material(
            color: AppColors.backgroundSoft,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: SwitchListTile(
              value: controller.voiceEnabled,
              onChanged: controller.setVoiceEnabled,
              activeThumbColor: AppColors.ice,
              title: const Text('Spoken guide'),
              subtitle: const Text('Timer calls and shuffled facts'),
              secondary: Icon(
                controller.voiceEnabled
                    ? Icons.graphic_eq_rounded
                    : Icons.volume_off_rounded,
                color: controller.voiceEnabled
                    ? AppColors.ice
                    : AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Material(
            color: AppColors.backgroundSoft,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: SwitchListTile(
              value: controller.keepScreenAwake,
              onChanged: controller.setKeepScreenAwake,
              activeThumbColor: AppColors.lime,
              title: const Text('Keep screen awake'),
              subtitle: const Text('Prevent dimming during active timers'),
              secondary: Icon(
                Icons.screen_lock_portrait_rounded,
                color: controller.keepScreenAwake
                    ? AppColors.lime
                    : AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'READY CALLOUT',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Chill',
                  label: Text('Chill'),
                  icon: Icon(Icons.spa_outlined),
                ),
                ButtonSegment(
                  value: 'Hype',
                  label: Text('Hype'),
                  icon: Icon(Icons.bolt_rounded),
                ),
              ],
              selected: {controller.promptVibe},
              onSelectionChanged: (selection) =>
                  controller.setPromptVibe(selection.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.comfortable,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lime.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lime.withValues(alpha: 0.16)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.lime,
                  size: 18,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Your profile and session history stay in this browser on this device.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({required this.controller});

  final AppController controller;

  Future<void> _confirmClear(BuildContext context) async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear session history?'),
        content: const Text(
          'This removes all locally stored session entries. Your presets and profile stay put.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.ember),
            child: const Text('Clear history'),
          ),
        ],
      ),
    );
    if (clear == true) controller.clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: 'Recent sessions',
            subtitle: controller.history.isEmpty
                ? 'Nothing logged yet.'
                : 'Your latest locally saved sessions.',
            trailing: controller.history.isEmpty
                ? null
                : TextButton.icon(
                    onPressed: () => _confirmClear(context),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Clear'),
                  ),
          ),
          const SizedBox(height: 17),
          if (controller.history.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.backgroundSoft,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    color: AppColors.muted,
                    size: 32,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Finish a timer and tap “Log this dab.”',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          else
            for (
              var index = 0;
              index < controller.history.take(12).length;
              index++
            ) ...[
              _HistoryRow(entry: controller.history[index]),
              if (index < controller.history.take(12).length - 1)
                const Divider(height: 1),
            ],
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final SessionEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.ember.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.ember,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.presetName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  '${entry.gear} • ${entry.heatSeconds}s / ${entry.coolSeconds}s',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatTimestamp(entry.timestamp),
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

String _formatTimestamp(DateTime value) {
  final now = DateTime.now();
  final sameDay =
      value.year == now.year &&
      value.month == now.month &&
      value.day == now.day;
  final hour = value.hour == 0
      ? 12
      : value.hour > 12
      ? value.hour - 12
      : value.hour;
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  if (sameDay) return 'Today\n$hour:$minute $suffix';
  return '${value.month}/${value.day}/${value.year.toString().substring(2)}\n$hour:$minute $suffix';
}
