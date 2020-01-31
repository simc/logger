import 'dart:convert';
import 'dart:io' as io;

import 'package:io/ansi.dart';

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_printer.dart';

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class SimplePrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  static final levelColors = {
    Level.verbose: darkGray,
    Level.debug: defaultForeground,
    Level.info: blue,
    Level.warning: yellow,
    Level.error: magenta,
    Level.wtf: red,
  };

  bool printTime;

  /// You can override the auto detected color support with this property. This
  /// is useful when Dart incorrectly reports a terminal not supporting colors.
  /// This happens, for example, when running the Dart program under Tmux or
  /// screen. See https://github.com/dart-lang/sdk/issues/31606.
  bool useColor;

  SimplePrinter({this.printTime = false})
      : useColor = io.stdout.supportsAnsiEscapes;

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${DateTime.now().toIso8601String()}' : '';
    return ['${_labelFor(event.level)} $timeStr $messageStr$errorStr'];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level];
    var color = levelColors[level];

    return overrideAnsiOutput(useColor, () => color.wrap(prefix));
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
