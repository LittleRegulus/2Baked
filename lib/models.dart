enum TimerPhase { idle, heating, cooling, ready }

class TimerPreset {
  const TimerPreset({
    required this.id,
    required this.name,
    required this.note,
    required this.heatSeconds,
    required this.coolSeconds,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final String note;
  final int heatSeconds;
  final int coolSeconds;
  final bool isCustom;

  int get totalSeconds => heatSeconds + coolSeconds;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'note': note,
    'heatSeconds': heatSeconds,
    'coolSeconds': coolSeconds,
    'isCustom': isCustom,
  };

  factory TimerPreset.fromJson(Map<String, Object?> json) => TimerPreset(
    id: json['id'] as String,
    name: json['name'] as String,
    note: json['note'] as String? ?? 'Your custom rhythm',
    heatSeconds: json['heatSeconds'] as int,
    coolSeconds: json['coolSeconds'] as int,
    isCustom: json['isCustom'] as bool? ?? true,
  );
}

class SessionEntry {
  const SessionEntry({
    required this.timestamp,
    required this.presetName,
    required this.heatSeconds,
    required this.coolSeconds,
    required this.gear,
  });

  final DateTime timestamp;
  final String presetName;
  final int heatSeconds;
  final int coolSeconds;
  final String gear;

  Map<String, Object?> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'presetName': presetName,
    'heatSeconds': heatSeconds,
    'coolSeconds': coolSeconds,
    'gear': gear,
  };

  factory SessionEntry.fromJson(Map<String, Object?> json) => SessionEntry(
    timestamp: DateTime.parse(json['timestamp'] as String),
    presetName: json['presetName'] as String,
    heatSeconds: json['heatSeconds'] as int,
    coolSeconds: json['coolSeconds'] as int,
    gear: json['gear'] as String? ?? 'Quartz banger',
  );
}

class DabFact {
  const DabFact({
    required this.title,
    required this.body,
    required this.category,
    this.isSafety = false,
  });

  final String title;
  final String body;
  final String category;
  final bool isSafety;
}
