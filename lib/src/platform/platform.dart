import 'package:logger/logger.dart';

import 'platform_standard.dart'
    if (dart.library.html) 'platform_web.dart'
    if (dart.library.io) 'platform_vm.dart';

typedef ConsolePrinter = void Function(String arg);

/// Runtime platform capabilities
class LogPlatform {
  /// Returns [true] if running in Web platform (Browser).
  static bool get isWeb => isPlatformWebImpl();

  /// Returns [true] if running in VM platform.
  static bool get isVM => isPlatformVMImpl();

  /// Returns [true] if the platform console supports colors.
  static bool get consoleSupportsColors =>
      getPlatformConsoleAcceptsColorsImpl();

  /// Returns console columns size.
  static int get consoleColumns => getPlatformConsoleColumnsImpl();

  /// Returns [true] if the console supports emoji.
  static bool get consoleSupportsEmoji => isPlatformWebImpl();

  static bool _enableSTDERR = false;

  /// If set to [true], allows write of [Level.error] and
  /// [Level.wtf] to `stderr` (if present in the runtime platform).
  ///
  /// Default to [false], to be backward compatible with previous versions.
  /// of this package.
  static bool get enableSTDERR => _enableSTDERR;

  static set enableSTDERR(bool value) {
    _enableSTDERR = value ?? false;
  }

  /// Returns a [ConsolePrinter] that is muted (won't print anything).
  static ConsolePrinter get consoleMutedPrinter => (arg) {};

  /// Returns a [ConsolePrinter] for log events.
  static ConsolePrinter get consoleLogPrinter => getPlatformConsoleLogPrinter();

  /// Returns a [ConsolePrinter] for info events.
  static ConsolePrinter get consoleInfoPrinter =>
      getPlatformConsoleInfoPrinter();

  /// Returns a [ConsolePrinter] for warn events.
  static ConsolePrinter get consoleWarnPrinter =>
      getPlatformConsoleWarnPrinter();

  /// Returns a [ConsolePrinter] for error events.
  static ConsolePrinter get consoleErrorPrinter =>
      getPlatformConsoleErrorPrinter();

  /// Returns the [ConsolePrinter] for the [level].
  static ConsolePrinter getConsolePrinter(Level level) {
    switch (level) {
      case Level.verbose:
      case Level.debug:
        return consoleLogPrinter;
      case Level.info:
        return consoleInfoPrinter;
      case Level.warning:
        return consoleWarnPrinter;
      case Level.error:
      case Level.wtf:
        return consoleErrorPrinter;
      case Level.nothing:
        return consoleMutedPrinter;
      default:
        return consoleLogPrinter;
    }
  }

  /// In some browsers, depending of the [ConsolePrinter] for some [level],
  /// the 1st line printed to the console is not vertically
  /// aligned (head indented) with the other lines.
  static bool isConsolePrinterHeadIndented(Level level) =>
      isPlatformConsolePrinterHeadIndented(level);

  /// Join lines, to avoid multiple calls to printer.
  ///
  /// In Web platform (browser), each call to printer, in case of `warnings` or
  /// `erros`, will associate a stack trace tree (visible and expandable
  /// in Browser console).
  ///
  /// In VM platform, multiple calls to printer is less efficient, since will
  /// generate multiple IO calls.
  static String joinLines(List<String> lines, Level level) {
    if (lines == null) return '';
    final linesLength = lines.length;
    if (linesLength == 0) return '';

    // Tries to avoid new [String] allocations:
    if (linesLength == 1) {
      return lines[0];
    }
    // Ensure that head line is vertical aligned with other lines
    // in the current console platform (if not, add a blank head line):
    else if (LogPlatform.isConsolePrinterHeadIndented(level)) {
      final buffer = StringBuffer();
      for (final line in lines) {
        buffer.write('\n');
        buffer.write(line);
      }
      return buffer.toString();
    } else {
      return lines.join('\n');
    }
  }

  static final int DEFAULT_METHOD_COUNT = isWeb ? 2 : 3;

  static final int DEFAULT_ERROR_METHOD_COUNT = isWeb ? 8 : 12;

  static final int DEFAULT_LINE_LENGTH = consoleColumns;

  static final bool DEFAULT_USE_COLORS = consoleSupportsColors;

  static final bool DEFAULT_USE_EMOJI = consoleSupportsEmoji;
}
