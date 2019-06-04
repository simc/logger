part of logger;

/// [Level]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
  nothing,
}

/// `LogFilter` is called every time a new log message is sent and decides if
/// it will be printed or canceled.
///
/// The default implementation is [Logger._defaultFilter].
/// Every implementation should consider [Logger.level].
typedef LogFilter = bool Function(
  Level level,
  dynamic message, [
  dynamic error,
  StackTrace stackTrace,
]);

/// An abstract handler of log messages.
///
/// You can implement a `LogPrinter` from scratch or extend [PrettyPrinter].
abstract class LogPrinter {
  /// Is called by the Logger for each log message.
  void log(Level level, dynamic message, dynamic error, StackTrace stackTrace);
}

class Logger {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.
  static Level level = Level.verbose;

  final LogPrinter _printer;
  final LogFilter _filter;

  /// Create a new Logger.
  ///
  /// You can provide a custom [printer] and [filter]. Otherwise the default
  /// [PrettyPrinter] and [_defaultFilter] will be used.
  Logger({LogPrinter printer, LogFilter filter})
      : _printer = printer ?? PrettyPrinter(),
        _filter = filter ?? _defaultFilter;

  /// Log message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.verbose, message, error, stackTrace);
  }

  /// Log message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Log message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Log message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Log message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Log message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.wtf, message, error, stackTrace);
  }

  /// Log message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]) {
    if (_filter(level, message, error, stackTrace)) {
      _printer.log(level, message, error, stackTrace);
    }
  }

  /// Default implementation of [LogFilter]. All log
  static bool _defaultFilter(
    Level level,
    dynamic message, [
    dynamic error,
    StackTrace stackTrace,
  ]) {
    var shouldLog = false;
    assert(() {
      if (level.index >= Logger.level.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}
