import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum CoreLogLevel { debug, info, warning, error }

class CoreLogEntry {
  CoreLogEntry({
    required this.timestamp,
    required this.level,
    required this.scope,
    required this.platform,
    required this.message,
    this.stackTrace,
  });

  final DateTime timestamp;
  final CoreLogLevel level;
  final String scope;
  final String platform;
  final String message;
  final String? stackTrace;

  String get levelName {
    switch (level) {
      case CoreLogLevel.debug:
        return 'DEBUG';
      case CoreLogLevel.info:
        return 'INFO';
      case CoreLogLevel.warning:
        return 'WARN';
      case CoreLogLevel.error:
        return 'ERROR';
    }
  }
}

class CoreLogService {
  static CoreLogService? _instance;
  static CoreLogService get instance {
    _instance ??= CoreLogService._();
    return _instance!;
  }

  CoreLogService._();

  static const int maxLogs = 1000;

  final List<CoreLogEntry> _logs = <CoreLogEntry>[];
  bool _enabled = true;

  List<CoreLogEntry> get logs => List.unmodifiable(_logs);

  bool get enabled => _enabled;
  set enabled(bool value) => _enabled = value;

  static void d(
    String message, {
    String scope = 'CORE',
    String platform = 'CORE',
  }) {
    instance._log(CoreLogLevel.debug, message, scope, platform);
  }

  static void i(
    String message, {
    String scope = 'CORE',
    String platform = 'CORE',
  }) {
    instance._log(CoreLogLevel.info, message, scope, platform);
  }

  static void w(
    String message, {
    String scope = 'CORE',
    String platform = 'CORE',
  }) {
    instance._log(CoreLogLevel.warning, message, scope, platform);
  }

  static void e(
    String message, {
    String scope = 'CORE',
    String platform = 'CORE',
    String? stackTrace,
  }) {
    instance._log(CoreLogLevel.error, message, scope, platform, stackTrace);
  }

  void _log(
    CoreLogLevel level,
    String message,
    String scope,
    String platform, [
    String? stackTrace,
  ]) {
    if (!_enabled) return;

    final entry = CoreLogEntry(
      timestamp: DateTime.now(),
      level: level,
      scope: scope,
      platform: platform,
      message: message,
      stackTrace: stackTrace,
    );

    _logs.add(entry);
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }

    final formatted = _formatEntry(entry);
    if (kDebugMode) {
      debugPrint(formatted);
      if (stackTrace != null && stackTrace.isNotEmpty) {
        debugPrint(stackTrace);
      }
    }
    developer.log(formatted);
  }

  String _formatEntry(CoreLogEntry entry) {
    final time = _formatTime(entry.timestamp);
    return '$time [${entry.levelName}] [${entry.scope}] [${entry.platform}] ${entry.message}';
  }

  String _formatTime(DateTime time) {
    final year = time.year.toString().padLeft(4, '0');
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final millisecond = time.millisecond.toString().padLeft(3, '0');
    return '$year-$month-$day $hour:$minute:$second.$millisecond';
  }
}
