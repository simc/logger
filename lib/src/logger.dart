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

class LogEvent {
  final Level level;
  final dynamic message;
  final dynamic error;
  final StackTrace stackTrace;

  LogEvent(this.level, this.message, this.error, this.stackTrace);
}

class OutputEvent {
  final Level level;
  final List<String> lines;

  OutputEvent(this.level, this.lines);
}

typedef LogCallback = void Function(LogEvent event);
typedef OutputCallback = void Function(OutputEvent event);

/// Use instances of logger to send log messages to the [LogPrinter].
class Logger {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.
  static Level level = Level.verbose;

  static final Set<LogCallback> _logCallbacks = Set();
  static final Set<OutputCallback> _outputCallbacks = Set();

  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  List<String> _outputBuffer = [];
  bool _active = true;

  /// Create a new instance of Logger.
  ///
  /// You can provide a custom [printer], [filter] and [output]. Otherwise the
  /// defaults: [PrettyPrinter], [DebugFilter] and [ConsoleOutput] will be
  /// used.
  Logger({LogFilter filter, LogPrinter printer, LogOutput output})
      : _filter = filter ?? DebugFilter(),
        _printer = printer ?? PrettyPrinter(),
        _output = output ?? ConsoleOutput() {
    _filter.init();
    _printer._buffer = _outputBuffer;
    _printer.init();
    _output.init();
  }

  /// Log a message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.verbose, message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.wtf, message, error, stackTrace);
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]) {
    if (!_active) {
      throw ArgumentError("Logger has already been closed.");
    } else if (error != null && error is StackTrace) {
      throw ArgumentError("Error parameter cannot take a StackTrace!");
    } else if (level == Level.nothing) {
      throw ArgumentError("Log events cannot have Level.nothing");
    }
    var logEvent = LogEvent(level, message, error, stackTrace);
    if (_filter.shouldLog(logEvent)) {
      for (var callback in _logCallbacks) {
        callback(logEvent);
      }
      _printer.log(logEvent);

      if (_outputBuffer.isNotEmpty) {
        var outputEvent = OutputEvent(level, _outputBuffer);
        for (var callback in _outputCallbacks) {
          callback(outputEvent);
        }
        _output.output(outputEvent);
        _outputBuffer = [];
        _printer._buffer = _outputBuffer;
      }
    }
  }

  /// Closes the logger and releases all resources.
  void close() {
    _active = false;
    _outputBuffer = null;
    _filter.destroy();
    _printer.destroy();
    _printer._buffer = null;
    _output.destroy();
  }

  /// Register a [LogCallback] which is called for each new [LogEvent].
  static void addLogListener(LogCallback callback) {
    _logCallbacks.add(callback);
  }

  /// Removes a [LogCallback] which was previously registered.
  ///
  /// Returns wheter the callback was successfully removed.
  static bool removeLogListener(LogCallback callback) {
    return _logCallbacks.remove(callback);
  }

  /// Register an [OutputCallback] which is called for each new [OutputEvent].
  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  /// Removes a [OutputCallback] which was previously registered.
  ///
  /// Returns wheter the callback was successfully removed.
  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }
}
