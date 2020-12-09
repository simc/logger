import 'package:logger/src/logger.dart';

/// An abstract filter of log messages.
///
/// You can implement your own `LogFilter` or use [DevelopmentFilter].
/// Every implementation should consider [Logger.level].
abstract class LogFilter {
  Level? level;
  void init() {}

  /// Is called every time a new log message is sent and decides if
  /// it will be printed or canceled.
  ///
  /// Returns `true` if the message should be logged.
  bool shouldLog(LogEvent event);

  void destroy() {}
}
