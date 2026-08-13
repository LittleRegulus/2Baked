import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'content.dart';
import 'models.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _category = 'All';
  late DabFact _featured;

  @override
  void initState() {
    super.initState();
    _featured = widget.controller.nextFact();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _category == 'All'
        ? facts
        : facts.where((fact) => fact.category == _category).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 42),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LEARN WHILE YOU WAIT',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.ice,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'The good stuff.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 7),
              Text(
                '${facts.length} quick facts and practical reminders—shuffled into your spoken sessions too.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 25),
              _FeaturedFact(
                fact: _featured,
                onShuffle: () =>
                    setState(() => _featured = widget.controller.nextFact()),
              ),
              const SizedBox(height: 26),
              const SectionHeading(
                title: 'Browse the stash',
                subtitle: 'Useful context without the bro-science.',
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in const [
                      'All',
                      'Safety',
                      'Technique',
                      'Science',
                      'Culture',
                    ]) ...[
                      ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 940
                      ? 3
                      : constraints.maxWidth >= 620
                      ? 2
                      : 1;
                  const gap = 13.0;
                  final width =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final fact in filtered)
                        SizedBox(
                          width: width,
                          child: _FactCard(fact: fact),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 26),
              const _EvidenceNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedFact extends StatelessWidget {
  const _FeaturedFact({required this.fact, required this.onShuffle});

  final DabFact fact;
  final VoidCallback onShuffle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            AppColors.ice.withValues(alpha: 0.18),
            AppColors.surface,
            AppColors.ember.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.ice.withValues(alpha: 0.28)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 570;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusPill(
                icon: fact.isSafety
                    ? Icons.health_and_safety_outlined
                    : Icons.auto_awesome_rounded,
                label: fact.category.toUpperCase(),
                color: fact.isSafety ? AppColors.cream : AppColors.ice,
              ),
              const SizedBox(height: 18),
              Text(
                fact.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 9),
              Text(
                fact.body,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFD7E0E8)),
              ),
            ],
          );
          final button = OutlinedButton.icon(
            onPressed: onShuffle,
            icon: const Icon(Icons.shuffle_rounded, color: AppColors.ice),
            label: const Text('SURPRISE ME'),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [copy, const SizedBox(height: 20), button],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 30),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact});

  final DabFact fact;

  @override
  Widget build(BuildContext context) {
    final color = switch (fact.category) {
      'Safety' => AppColors.cream,
      'Technique' => AppColors.emberSoft,
      'Science' => AppColors.ice,
      _ => AppColors.lime,
    };
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  fact.isSafety
                      ? Icons.shield_outlined
                      : Icons.lightbulb_outline_rounded,
                  color: color,
                  size: 18,
                ),
              ),
              const Spacer(),
              Text(
                fact.category.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(fact.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(fact.body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _EvidenceNote extends StatelessWidget {
  const _EvidenceNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.backgroundSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: AppColors.ice),
              const SizedBox(width: 10),
              Text(
                'Built from evidence, not hype',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Safety copy was reviewed against public guidance from:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final source in sourceNotes)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 5, color: AppColors.ice),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      source,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 7),
          Text(
            '2Baked is a timing and record-keeping tool, not medical advice. Avoid cannabis if underage, pregnant, breastfeeding, or advised against it by a clinician.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
