import 'dart:convert';

import 'package:logger/src/ansi_color.dart';
import 'package:logger/src/log_printer.dart';
import 'package:logger/src/logger.dart';
import 'package:logger/src/platform/platform.dart';

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class SimplePrinter extends LogPrinterWithName {
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

  @override
  final String name;
  final bool printTime;
  final bool printLevel;
  final bool colors;

  SimplePrinter({String name, this.printTime = false, this.printLevel = true, bool colors}) :
      name = (name ?? '').trim(),
      colors = colors ?? LogPlatform.DEFAULT_USE_COLORS
  ;

  /// Copies this instance.
  ///
  /// [withName] If present will overwrite [name].
  @override
  SimplePrinter copy({String withName}) {
    if (withName == null || withName.isEmpty) {
      withName = name;
    }
    var cp = SimplePrinter(
        name: withName,
        colors: colors,
        printLevel: printLevel,
        printTime: printTime);
    return cp;
  }

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var levelStr = printLevel ? _labelFor(event.level) + (printTime ? ' ' : '') : '' ;
    var timeStr = printTime ? '[${ DateTime.now().toIso8601String() }]' : '';
    var nameStr = name.isNotEmpty ? ' [$name]' : '' ;
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    return ['$levelStr$timeStr$nameStr  $messageStr$errorStr'];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level];
    var color = levelColors[level];
    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
