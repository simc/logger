part of logger;

/// Default implementation of [LogPrinter]
///
/// Outut looks like this:
///
/// ┌──────────────────────────
/// │ Error info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Method stack history
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Log message
/// └──────────────────────────
/// ```
class PrettyPrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = "─";
  static const singleDivider = "┄";

  static final colors = {
    Level.verbose: AnsiPen()..gray(level: 0.5),
    Level.debug: AnsiPen(),
    Level.info: AnsiPen()..blue(bold: true),
    Level.warning: AnsiPen()..xterm(208),
    Level.error: AnsiPen()..xterm(196),
    Level.wtf: AnsiPen()..xterm(199),
  };

  static final emojis = {
    Level.verbose: '',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
  static const String indent = '  ';

  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool printEmojis;

  String topBorder = '';
  String middleBorder = '';
  String bottomBorder = '';

  PrettyPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.printEmojis = true,
  }) {
    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (int i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    topBorder = "$topLeftCorner$doubleDividerLine";
    middleBorder = "$middleCorner$singleDividerLine";
    bottomBorder = "$bottomLeftCorner$doubleDividerLine";
  }

  @override
  void log(Level level, dynamic message, dynamic error, StackTrace stackTrace) {
    var messageStr = stringifyMessage(message);
    var stackTraceStr = collectStackTrace(stackTrace);
    var errorStr = error?.toString();

    var output = formatOutput(level, messageStr, errorStr, stackTraceStr);
    for (var line in output) {
      printLine(level, line);
    }
  }

  String collectStackTrace(StackTrace stackTrace) {
    if (stackTrace == null) {
      if (methodCount > 0) {
        return formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      return formatStackTrace(stackTrace, errorMethodCount);
    }

    return null;
  }

  String formatStackTrace(StackTrace stackTrace, int methodCount) {
    var lines = stackTrace.toString().split("\n");

    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      var match = stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2).startsWith('package:logger')) {
          continue;
        }
        var newLine = ("#$count   ${match.group(1)} (${match.group(2)})");
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else if (line.startsWith('<')) {
        formatted.add(line);
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(indent);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  List<String> formatOutput(
      Level level, String message, String error, String stacktrace) {
    var pen = colors[level];
    List<String> output = [pen(topBorder)];

    if (error != null) {
      AnsiPen errorPen;
      if (level == Level.wtf) {
        errorPen = AnsiPen()..xterm(199, bg: true);
      } else {
        errorPen = AnsiPen()..xterm(196, bg: true);
      }
      for (var line in error.split('\n')) {
        output.add(
          pen('$verticalLine ') +
              resetForeground() +
              errorPen(line) +
              resetBackground(),
        );
      }
      output.add(pen(middleBorder));
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        output.add('$pen$verticalLine $line');
      }
      output.add(pen(middleBorder));
    }

    var emoji = printEmojis ? emojis[level] : '';
    for (var line in message.split('\n')) {
      output.add(pen('$verticalLine $emoji$line'));
      emoji = '';
    }
    output.add(pen(bottomBorder));

    return output;
  }

  void printLine(Level level, String line) {
    print(line);
  }
}
