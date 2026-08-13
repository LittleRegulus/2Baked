import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'models.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  TimerPhase _previousPhase = TimerPhase.idle;
  bool _readyDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _previousPhase = widget.controller.phase;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant TimerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.controller.refreshClock();
    }
  }

  void _onControllerChanged() {
    final phase = widget.controller.phase;
    if (phase == TimerPhase.ready &&
        _previousPhase != TimerPhase.ready &&
        !_readyDialogOpen) {
      _readyDialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showReadyDialog());
    }
    _previousPhase = phase;
  }

  Future<void> _showReadyDialog() async {
    if (!mounted) return;
    final shouldLog = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ReadyDialog(
        message: widget.controller.readyMessage,
        preset: widget.controller.activePreset,
      ),
    );
    _readyDialogOpen = false;
    if (mounted && widget.controller.phase == TimerPhase.ready) {
      widget.controller.finishReady(logSession: shouldLog ?? false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              wide ? 38 : 18,
              28,
              wide ? 38 : 18,
              36,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageHeader(controller: widget.controller),
                    const SizedBox(height: 26),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _TimerPanel(controller: widget.controller),
                          ),
                          const SizedBox(width: 22),
                          SizedBox(
                            width: 370,
                            child: _PresetsPanel(controller: widget.controller),
                          ),
                        ],
                      )
                    else ...[
                      _TimerPanel(controller: widget.controller),
                      const SizedBox(height: 20),
                      _PresetsPanel(controller: widget.controller),
                    ],
                    const SizedBox(height: 22),
                    _SafetyStrip(controller: widget.controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 610;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey, ${controller.profileName}.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ice,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Dial in your dab.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        );
        final status = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusPill(
              icon: Icons.hardware_rounded,
              label: controller.selectedGear,
              color: AppColors.cream,
            ),
            StatusPill(
              icon: controller.voiceEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              label: controller.voiceEnabled ? 'Voice on' : 'Voice off',
              color: controller.voiceEnabled ? AppColors.ice : AppColors.muted,
            ),
            if (controller.keepScreenAwake)
              StatusPill(
                icon: Icons.screen_lock_portrait_rounded,
                label: controller.phase == TimerPhase.idle
                    ? 'Stay awake ready'
                    : controller.wakeLockActive
                    ? 'Screen awake'
                    : 'Awake requested',
                color: AppColors.lime,
              ),
          ],
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 14), status],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: title),
            const SizedBox(width: 16),
            status,
          ],
        );
      },
    );
  }
}

class _TimerPanel extends StatelessWidget {
  const _TimerPanel({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final active = controller.phase != TimerPhase.idle;
    final color = switch (controller.phase) {
      TimerPhase.heating => AppColors.ember,
      TimerPhase.cooling => AppColors.ice,
      TimerPhase.ready => AppColors.lime,
      TimerPhase.idle => AppColors.border,
    };
    return AppCard(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      borderColor: color.withValues(alpha: active ? 0.52 : 1),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.activePreset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.activePreset.heatSeconds}s heat  •  ${controller.activePreset.coolSeconds}s cool',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: controller.voiceEnabled
                    ? 'Mute voice'
                    : 'Enable voice',
                onPressed: () =>
                    controller.setVoiceEnabled(!controller.voiceEnabled),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.backgroundSoft,
                  side: const BorderSide(color: AppColors.border),
                ),
                icon: Icon(
                  controller.voiceEnabled
                      ? Icons.graphic_eq_rounded
                      : Icons.volume_off_rounded,
                  color: controller.voiceEnabled
                      ? AppColors.ice
                      : AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: TimerDial(
              phase: controller.phase,
              progress: controller.phaseProgress,
              seconds: controller.phaseRemainingSeconds,
              isPaused: controller.isPaused,
            ),
          ),
          const SizedBox(height: 12),
          _PhaseRoute(controller: controller),
          const SizedBox(height: 22),
          _TimerActions(controller: controller),
        ],
      ),
    );
  }
}

class _PhaseRoute extends StatelessWidget {
  const _PhaseRoute({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final heatActive = controller.phase == TimerPhase.heating;
    final coolActive = controller.phase == TimerPhase.cooling;
    return Row(
      children: [
        Expanded(
          child: _PhaseChip(
            icon: Icons.local_fire_department_rounded,
            label: 'HEAT',
            seconds: controller.activePreset.heatSeconds,
            active: heatActive,
            done: coolActive || controller.phase == TimerPhase.ready,
            color: AppColors.ember,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.muted.withValues(alpha: 0.6),
            size: 18,
          ),
        ),
        Expanded(
          child: _PhaseChip(
            icon: Icons.ac_unit_rounded,
            label: 'COOL',
            seconds: controller.activePreset.coolSeconds,
            active: coolActive,
            done: controller.phase == TimerPhase.ready,
            color: AppColors.ice,
          ),
        ),
      ],
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({
    required this.icon,
    required this.label,
    required this.seconds,
    required this.active,
    required this.done,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int seconds;
  final bool active;
  final bool done;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: active
            ? color.withValues(alpha: 0.12)
            : AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? color.withValues(alpha: 0.5) : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            done ? Icons.check_rounded : icon,
            color: active || done ? color : AppColors.muted,
            size: 17,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              '$label  ${seconds}s',
              maxLines: 1,
              style: TextStyle(
                color: active || done ? AppColors.text : AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerActions extends StatelessWidget {
  const _TimerActions({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.phase == TimerPhase.idle) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: controller.startTimer,
          icon: const Icon(Icons.local_fire_department_rounded),
          label: const Text('START SESSION'),
        ),
      );
    }
    if (controller.phase == TimerPhase.ready) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: controller.isPaused
                ? controller.resumeTimer
                : controller.pauseTimer,
            icon: Icon(
              controller.isPaused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
            ),
            label: Text(controller.isPaused ? 'RESUME' : 'PAUSE'),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: controller.cancelTimer,
          icon: const Icon(Icons.close_rounded),
          label: const Text('RESET'),
        ),
      ],
    );
  }
}

class _PresetsPanel extends StatelessWidget {
  const _PresetsPanel({required this.controller});

  final AppController controller;

  Future<void> _openCustomPreset(BuildContext context) async {
    final nameController = TextEditingController(text: 'My sweet spot');
    var heat = 40.0;
    var cool = 45.0;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create a preset'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  maxLength: 24,
                  decoration: const InputDecoration(labelText: 'Preset name'),
                ),
                const SizedBox(height: 14),
                _SliderLabel(label: 'Heat time', value: heat.round()),
                Slider(
                  value: heat,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  activeColor: AppColors.ember,
                  onChanged: (value) => setDialogState(() => heat = value),
                ),
                _SliderLabel(label: 'Cooldown', value: cool.round()),
                Slider(
                  value: cool,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  activeColor: AppColors.ice,
                  onChanged: (value) => setDialogState(() => cool = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save preset'),
            ),
          ],
        ),
      ),
    );
    if (created == true) {
      controller.addCustomPreset(
        name: nameController.text,
        heatSeconds: heat.round(),
        coolSeconds: cool.round(),
      );
    }
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: 'Quick presets',
            subtitle: 'Pick a rhythm, then make it yours.',
            trailing: IconButton(
              tooltip: 'Create custom preset',
              onPressed: controller.phase == TimerPhase.idle
                  ? () => _openCustomPreset(context)
                  : null,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.backgroundSoft,
                side: const BorderSide(color: AppColors.border),
              ),
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 18),
          for (final preset in controller.allPresets) ...[
            _PresetTile(controller: controller, preset: preset),
            if (preset != controller.allPresets.last)
              const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          Text(
            'Times are personal baselines—not temperature or dosing advice.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SliderLabel extends StatelessWidget {
  const _SliderLabel({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          '${value}s',
          style: const TextStyle(
            color: AppColors.ice,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({required this.controller, required this.preset});

  final AppController controller;
  final TimerPreset preset;

  @override
  Widget build(BuildContext context) {
    final selected = controller.activePreset.id == preset.id;
    final favorite = controller.favoritePresetIds.contains(preset.id);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.phase == TimerPhase.idle
            ? () => controller.selectPreset(preset)
            : null,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(14, 13, 8, 13),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.ember.withValues(alpha: 0.09)
                : AppColors.backgroundSoft,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? AppColors.ember.withValues(alpha: 0.55)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 39,
                height: 39,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.ember.withValues(alpha: 0.14)
                      : AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  preset.id == 'cold_start'
                      ? Icons.ac_unit_rounded
                      : Icons.local_fire_department_rounded,
                  color: selected ? AppColors.ember : AppColors.muted,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${preset.heatSeconds}s / ${preset.coolSeconds}s  •  ${preset.note}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (preset.isCustom)
                IconButton(
                  tooltip: 'Delete preset',
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.phase == TimerPhase.idle
                      ? () => controller.deleteCustomPreset(preset)
                      : null,
                  icon: const Icon(Icons.delete_outline_rounded, size: 19),
                ),
              IconButton(
                tooltip: favorite ? 'Remove favorite' : 'Favorite preset',
                visualDensity: VisualDensity.compact,
                onPressed: () => controller.toggleFavorite(preset),
                icon: Icon(
                  favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: favorite ? AppColors.cream : AppColors.muted,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafetyStrip extends StatelessWidget {
  const _SafetyStrip({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cream.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            color: AppColors.cream,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hot quartz can look cold. Keep the setup stable, ventilate the space, pace yourself, and never drive impaired.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cream,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadyDialog extends StatelessWidget {
  const _ReadyDialog({required this.message, required this.preset});

  final String message;
  final TimerPreset preset;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandMark(size: 104),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandWordmark(fontSize: 16),
                  Text(
                    ' SAYS...',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.7,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 9),
              Text(
                '${preset.name} • ${preset.heatSeconds}s heat / ${preset.coolSeconds}s cool',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.background,
                  ),
                  icon: const Icon(Icons.add_chart_rounded),
                  label: const Text('LOG THIS DAB'),
                ),
              ),
              const SizedBox(height: 9),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Done without logging'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
