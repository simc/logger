import 'package:logger_fork/src/logger_fork.dart';
import 'package:logger_fork/src/log_filter.dart';

/// Prints all logs with `level >= Logger.level` even in production.
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level!.index;
  }
}
