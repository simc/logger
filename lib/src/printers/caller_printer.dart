import 'dart:convert';

import 'package:logger/logger.dart';

class CallerPrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  final bool printTime;
  final bool colors;

  /// The index which to begin the stack trace at
  ///
  /// This can be useful if, for instance, Logger is wrapped in another class and
  /// you wish to remove these wrapped calls from stack trace
  final int stackTraceBeginIndex;

  // No of methods to show in StackTrace when no error or exception is thrown
  final int methodCount;

  /// No of methods to show in StackTrace when error or exception is thrown
  final int errorMethodCount;

  CallerPrinter({
    this.printTime = false,
    this.colors = true,
    // StackTrace args
    this.stackTraceBeginIndex = 0,
    this.methodCount = 0,
    this.errorMethodCount = 10,
  });
  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '\nERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${DateTime.now().toIso8601String()}' : '';

    var stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = _formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = _formatStackTrace(event.stackTrace, errorMethodCount);
    }
    stackTraceStr = stackTraceStr == null
        ? ''
        : '\n' + stackTraceStr + '\n========================================';

    return [
      '${_labelFor(event.level)} $timeStr$messageStr$errorStr$stackTraceStr'
    ];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level]!;
    var color = levelColors[level]!;

    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  //! Stack Trace formatting
  /// Matches a stacktrace line as generated on Android/iOS devices.
  /// For example:
  /// #1      Logger.log (package:logger/src/logger.dart:115:29)
  static final _deviceStackTraceRegex =
      RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  /// Matches a stacktrace line as generated by Flutter web.
  /// For example:
  /// packages/logger/src/printers/pretty_printer.dart 91:37
  static final _webStackTraceRegex =
      RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  /// Matches a stacktrace line as generated by browser Dart.
  /// For example:
  /// dart:sdk_internal
  /// package:logger/src/logger.dart
  static final _browserStackTraceRegex =
      RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  String? _formatStackTrace(StackTrace? stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');
    if (stackTraceBeginIndex > 0 && stackTraceBeginIndex < lines.length - 1) {
      lines = lines.sublist(stackTraceBeginIndex);
    }
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line) ||
          _discardBrowserStacktraceLine(line) ||
          line.isEmpty) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      if (++count == methodCount) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('packages/logger') ||
        match.group(1)!.startsWith('dart-sdk/lib');
  }

  bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('package:logger') ||
        match.group(1)!.startsWith('dart:');
  }
}
