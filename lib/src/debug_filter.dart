part of logger;

/// Default implementation of [LogFilter].
///
/// Shows all logs with `level >= Logger.level` while in debug mode. In release
/// mode all logs are omitted.
class DebugFilter extends LogFilter {
  @override
  bool shouldLog(Level level, message, [error, StackTrace stackTrace]) {
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
