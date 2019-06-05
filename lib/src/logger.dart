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

/// An abstract filter of log messages.
///
/// You can implement your own `LogFilter` or use [DebugFilter].
/// Every implementation should consider [Logger.level].
abstract class LogFilter {
  /// Is called every time a new log message is sent and decides if
  /// it will be printed or canceled.
  ///
  /// Returns `true` if the message should be logged.
  bool shouldLog(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]);
}

/// An abstract handler of log messages.
///
/// A log printer creates the output, which is then sent to [LogOutput].
/// Every implementation has to use the [LogPrinter.println] method to send
/// the output.
///
/// You can implement a `LogPrinter` from scratch or extend [PrettyPrinter].
abstract class LogPrinter {
  LogOutput _output;
  LogOutput get output => _output;
  List<String> _buffer = [];

  /// Is called every time a new log message is sent and handles printing or
  /// storing the message.
  void log(Level level, dynamic message, dynamic error, StackTrace stackTrace);

  void println(String line) {
    _buffer.add(line);
  }

  void clearBuffer() {
    _buffer.clear();
  }

  void flush(Level level) {
    if (_buffer.isNotEmpty) {
      _output.output(level, _buffer);
      clearBuffer();
    }
  }
}

/// Log output receives the log lines from [LogPrinter] and sends it to the
/// desired destination.
///
/// This can be an output stream, a file or a network target. [LogOutput] may
/// cache multiple log messages.
abstract class LogOutput {
  void output(Level level, List<String> lines);
}

/// Use instances of logger to send log messages to the [LogPrinter].
class Logger {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.
  static Level level = Level.verbose;

  final LogFilter _filter;
  final LogPrinter _printer;

  /// Create a new instance of Logger.
  ///
  /// You can provide a custom [printer] and [filter]. Otherwise the defaults:
  /// [PrettyPrinter] and [DebugFilter] will be used.
  Logger({LogFilter filter, LogPrinter printer, LogOutput output})
      : _printer = printer ?? PrettyPrinter(),
        _filter = filter ?? DebugFilter() {
    _printer._output = output ?? ConsoleOutput();
  }

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
    assert(error == null || !(error is StackTrace),
        "Error parameter cannot take a StackTrace!");
    if (_filter.shouldLog(level, message, error, stackTrace)) {
      _printer.log(level, message, error, stackTrace);
      _printer.flush(level);
    }
  }
}
