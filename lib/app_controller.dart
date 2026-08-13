import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'content.dart';
import 'models.dart';

class AppController extends ChangeNotifier {
  AppController({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  static const _profileNameKey = 'profile_name';
  static const _gearKey = 'selected_gear';
  static const _voiceKey = 'voice_enabled';
  static const _vibeKey = 'prompt_vibe';
  static const _favoriteKey = 'favorite_presets';
  static const _customPresetsKey = 'custom_presets';
  static const _historyKey = 'session_history';
  static const _keepAwakeKey = 'keep_screen_awake';

  final FlutterTts _tts;
  final Random _random = Random();
  SharedPreferences? _preferences;
  Timer? _ticker;
  DateTime? _phaseEndsAt;
  int _pausedMilliseconds = 0;
  int _phaseRemainingMilliseconds = 0;
  int _speechSession = 0;
  List<int> _factQueue = [];
  bool _disposed = false;

  String profileName = 'Friend';
  String selectedGear = gearOptions.first;
  bool voiceEnabled = true;
  bool keepScreenAwake = true;
  bool wakeLockActive = false;
  bool isPaused = false;
  String promptVibe = 'Hype';
  TimerPhase phase = TimerPhase.idle;
  TimerPreset activePreset = defaultPresets[1];
  final List<TimerPreset> customPresets = [];
  final Set<String> favoritePresetIds = {'daily_driver'};
  final List<SessionEntry> history = [];
  String readyMessage = hypePrompts.first;

  List<TimerPreset> get allPresets => [...defaultPresets, ...customPresets];

  int get phaseTotalSeconds => switch (phase) {
    TimerPhase.heating => activePreset.heatSeconds,
    TimerPhase.cooling => activePreset.coolSeconds,
    TimerPhase.idle || TimerPhase.ready => 0,
  };

  int get phaseRemainingSeconds {
    if (phase == TimerPhase.ready) return 0;
    if (phase == TimerPhase.idle) return activePreset.heatSeconds;
    return (_phaseRemainingMilliseconds / 1000).ceil().clamp(
      0,
      phaseTotalSeconds,
    );
  }

  int get totalRemainingSeconds => switch (phase) {
    TimerPhase.heating => phaseRemainingSeconds + activePreset.coolSeconds,
    TimerPhase.cooling => phaseRemainingSeconds,
    TimerPhase.idle => activePreset.totalSeconds,
    TimerPhase.ready => 0,
  };

  double get phaseProgress {
    if (phase == TimerPhase.ready) return 1;
    if (phase == TimerPhase.idle || phaseTotalSeconds == 0) return 0;
    final total = phaseTotalSeconds * 1000;
    return (1 - (_phaseRemainingMilliseconds / total)).clamp(0.0, 1.0);
  }

  int get todayCount {
    final now = DateTime.now();
    return history
        .where(
          (entry) =>
              entry.timestamp.year == now.year &&
              entry.timestamp.month == now.month &&
              entry.timestamp.day == now.day,
        )
        .length;
  }

  TimerPreset? get favoritePreset {
    for (final preset in allPresets) {
      if (favoritePresetIds.contains(preset.id)) return preset;
    }
    return null;
  }

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    profileName = _preferences?.getString(_profileNameKey) ?? 'Friend';
    selectedGear = _preferences?.getString(_gearKey) ?? gearOptions.first;
    voiceEnabled = _preferences?.getBool(_voiceKey) ?? true;
    keepScreenAwake = _preferences?.getBool(_keepAwakeKey) ?? true;
    promptVibe = _preferences?.getString(_vibeKey) ?? 'Hype';

    favoritePresetIds
      ..clear()
      ..addAll(
        _preferences?.getStringList(_favoriteKey) ?? const ['daily_driver'],
      );

    _readCustomPresets();
    _readHistory();

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.46);
    await _tts.setPitch(0.95);
    await _tts.setVolume(1);
    await _tts.awaitSpeakCompletion(true);
  }

  void _readCustomPresets() {
    final raw = _preferences?.getString(_customPresetsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      customPresets.addAll(
        decoded.map(
          (item) => TimerPreset.fromJson(
            Map<String, Object?>.from(item as Map<dynamic, dynamic>),
          ),
        ),
      );
    } on FormatException {
      // A bad local entry should never prevent the app from opening.
    }
  }

  void _readHistory() {
    final raw = _preferences?.getString(_historyKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      history.addAll(
        decoded.map(
          (item) => SessionEntry.fromJson(
            Map<String, Object?>.from(item as Map<dynamic, dynamic>),
          ),
        ),
      );
    } on FormatException {
      // Ignore malformed local history and continue with a clean timeline.
    }
  }

  void selectPreset(TimerPreset preset) {
    if (phase != TimerPhase.idle) return;
    activePreset = preset;
    notifyListeners();
  }

  void addCustomPreset({
    required String name,
    required int heatSeconds,
    required int coolSeconds,
  }) {
    final preset = TimerPreset(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'My preset' : name.trim(),
      note: 'Your custom rhythm',
      heatSeconds: heatSeconds,
      coolSeconds: coolSeconds,
      isCustom: true,
    );
    customPresets.add(preset);
    activePreset = preset;
    _savePresets();
    notifyListeners();
  }

  void deleteCustomPreset(TimerPreset preset) {
    if (!preset.isCustom || phase != TimerPhase.idle) return;
    customPresets.removeWhere((item) => item.id == preset.id);
    favoritePresetIds.remove(preset.id);
    if (activePreset.id == preset.id) activePreset = defaultPresets[1];
    _savePresets();
    _saveFavorites();
    notifyListeners();
  }

  void toggleFavorite(TimerPreset preset) {
    if (!favoritePresetIds.add(preset.id)) {
      favoritePresetIds.remove(preset.id);
    }
    _saveFavorites();
    notifyListeners();
  }

  void startTimer() {
    _ticker?.cancel();
    _speechSession++;
    isPaused = false;
    phase = TimerPhase.heating;
    _phaseRemainingMilliseconds = activePreset.heatSeconds * 1000;
    _phaseEndsAt = DateTime.now().add(
      Duration(seconds: activePreset.heatSeconds),
    );
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
    notifyListeners();
    unawaited(_beginNarration(_speechSession));
    unawaited(_syncWakeLock());
  }

  void pauseTimer() {
    if (phase != TimerPhase.heating && phase != TimerPhase.cooling) return;
    isPaused = true;
    _pausedMilliseconds = _phaseRemainingMilliseconds;
    _ticker?.cancel();
    _speechSession++;
    unawaited(_stopSpeech());
    notifyListeners();
  }

  void resumeTimer() {
    if (!isPaused) return;
    isPaused = false;
    _phaseRemainingMilliseconds = _pausedMilliseconds;
    _phaseEndsAt = DateTime.now().add(
      Duration(milliseconds: _pausedMilliseconds),
    );
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
    _speechSession++;
    notifyListeners();
    unawaited(_resumeNarration(_speechSession));
  }

  void cancelTimer() {
    _ticker?.cancel();
    _speechSession++;
    unawaited(_stopSpeech());
    isPaused = false;
    phase = TimerPhase.idle;
    _phaseEndsAt = null;
    _phaseRemainingMilliseconds = 0;
    notifyListeners();
    unawaited(_syncWakeLock());
  }

  void refreshClock() {
    unawaited(_syncWakeLock());
    if (!isPaused &&
        (phase == TimerPhase.heating || phase == TimerPhase.cooling)) {
      _tick();
    }
  }

  void _tick() {
    if (_phaseEndsAt == null || isPaused) return;
    final now = DateTime.now();
    _phaseRemainingMilliseconds = _phaseEndsAt!.difference(now).inMilliseconds;
    if (_phaseRemainingMilliseconds <= 0) {
      _advancePhase(now);
      return;
    }
    notifyListeners();
  }

  void _advancePhase(DateTime now) {
    if (phase == TimerPhase.heating) {
      final coolingEnd = _phaseEndsAt!.add(
        Duration(seconds: activePreset.coolSeconds),
      );
      phase = TimerPhase.cooling;
      _phaseEndsAt = coolingEnd;
      _phaseRemainingMilliseconds = coolingEnd.difference(now).inMilliseconds;
      if (_phaseRemainingMilliseconds <= 0) {
        _advancePhase(now);
        return;
      }
      if (voiceEnabled) unawaited(_speak(_pickCooldownMessage()));
      notifyListeners();
      unawaited(_syncWakeLock());
      return;
    }

    if (phase == TimerPhase.cooling) {
      _ticker?.cancel();
      _speechSession++;
      phase = TimerPhase.ready;
      isPaused = false;
      _phaseRemainingMilliseconds = 0;
      readyMessage = _pickReadyMessage();
      notifyListeners();
      unawaited(_syncWakeLock());
      if (voiceEnabled) unawaited(_announceReady(readyMessage));
    }
  }

  Future<void> _beginNarration(int session) async {
    await _stopSpeech();
    if (!voiceEnabled || session != _speechSession) return;
    await _speak(
      '${_pickStartMessage()} Heating for ${activePreset.heatSeconds} seconds, then cooling for ${activePreset.coolSeconds}.',
    );
    await _narrateFacts(session);
  }

  Future<void> _resumeNarration(int session) async {
    if (!voiceEnabled || session != _speechSession) return;
    await _speak('Timer resumed.');
    await _narrateFacts(session);
  }

  Future<void> _narrateFacts(int session) async {
    var spoken = 0;
    while (session == _speechSession &&
        voiceEnabled &&
        !isPaused &&
        (phase == TimerPhase.heating || phase == TimerPhase.cooling) &&
        totalRemainingSeconds > 13 &&
        spoken < 4) {
      final fact = nextFact();
      final intro = spoken.isOdd ? 'Also, did you know? ' : 'Quick fact. ';
      await _speak('$intro${fact.body}');
      spoken++;
      if (session != _speechSession || totalRemainingSeconds <= 13) return;
      await Future<void>.delayed(const Duration(seconds: 7));
    }
  }

  Future<void> _announceReady(String message) async {
    await _stopSpeech();
    if (!voiceEnabled) return;
    await _speak('2 Baked says. $message');
  }

  Future<void> _speak(String text) async {
    if (!voiceEnabled) return;
    try {
      await _tts.speak(text);
    } catch (_) {
      // Speech support differs by browser; the visual timer remains primary.
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Speech plugins are not registered in pure Dart/widget-test contexts.
    }
  }

  DabFact nextFact() {
    if (_factQueue.isEmpty) {
      _factQueue = List<int>.generate(facts.length, (index) => index)
        ..shuffle(_random);
    }
    return facts[_factQueue.removeLast()];
  }

  String _pickReadyMessage() {
    final prompts = promptVibe == 'Hype' ? hypePrompts : chillPrompts;
    return prompts[_random.nextInt(prompts.length)];
  }

  String _pickStartMessage() {
    final prompts = promptVibe == 'Hype' ? hypeStartPrompts : chillStartPrompts;
    return prompts[_random.nextInt(prompts.length)];
  }

  String _pickCooldownMessage() {
    final prompts = promptVibe == 'Hype'
        ? hypeCooldownPrompts
        : chillCooldownPrompts;
    return prompts[_random.nextInt(prompts.length)];
  }

  void finishReady({required bool logSession}) {
    if (phase != TimerPhase.ready) return;
    if (logSession) {
      history.insert(
        0,
        SessionEntry(
          timestamp: DateTime.now(),
          presetName: activePreset.name,
          heatSeconds: activePreset.heatSeconds,
          coolSeconds: activePreset.coolSeconds,
          gear: selectedGear,
        ),
      );
      if (history.length > 100) history.removeRange(100, history.length);
      _saveHistory();
    }
    phase = TimerPhase.idle;
    _phaseEndsAt = null;
    notifyListeners();
    unawaited(_syncWakeLock());
  }

  void setVoiceEnabled(bool enabled) {
    voiceEnabled = enabled;
    _preferences?.setBool(_voiceKey, enabled);
    if (!enabled) {
      _speechSession++;
      unawaited(_stopSpeech());
    }
    notifyListeners();
  }

  void setKeepScreenAwake(bool enabled) {
    keepScreenAwake = enabled;
    _preferences?.setBool(_keepAwakeKey, enabled);
    notifyListeners();
    unawaited(_syncWakeLock());
  }

  Future<void> _syncWakeLock() async {
    final sessionActive = phase != TimerPhase.idle;
    final shouldStayAwake = keepScreenAwake && sessionActive;
    try {
      await WakelockPlus.toggle(enable: shouldStayAwake);
      wakeLockActive = await WakelockPlus.enabled;
    } catch (_) {
      wakeLockActive = false;
    }
    if (!_disposed) notifyListeners();
  }

  void setPromptVibe(String value) {
    promptVibe = value;
    _preferences?.setString(_vibeKey, value);
    notifyListeners();
  }

  void setProfileName(String value) {
    final cleaned = value.trim();
    profileName = cleaned.isEmpty ? 'Friend' : cleaned;
    _preferences?.setString(_profileNameKey, profileName);
    notifyListeners();
  }

  void setGear(String value) {
    selectedGear = value;
    _preferences?.setString(_gearKey, value);
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    _saveHistory();
    notifyListeners();
  }

  void _savePresets() {
    _preferences?.setString(
      _customPresetsKey,
      jsonEncode(customPresets.map((preset) => preset.toJson()).toList()),
    );
  }

  void _saveFavorites() {
    _preferences?.setStringList(_favoriteKey, favoritePresetIds.toList());
  }

  void _saveHistory() {
    _preferences?.setString(
      _historyKey,
      jsonEncode(history.map((entry) => entry.toJson()).toList()),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    unawaited(_stopSpeech());
    unawaited(WakelockPlus.disable().catchError((_) {}));
    super.dispose();
  }
}
