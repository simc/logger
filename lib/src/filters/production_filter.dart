import 'package:logger/src/log_filter.dart';
import 'package:logger/src/logger.dart';

/// Prints all logs with `level >= Logger.level` even in production.
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level!.index;
  }
}
