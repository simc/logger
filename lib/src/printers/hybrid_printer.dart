import 'package:logger/src/logger.dart';
import 'package:logger/src/log_printer.dart';

/// A decorator for a [LogPrinter] that allows for the composition of
/// different printers to handle different log messages. Provide it's
/// constructor with a base printer, but include named parameters for
/// any levels that have a different printer:
///
/// ```
/// HybridPrinter(PrettyPrinter(), debug: SimplePrinter());
/// ```
///
/// Will use the pretty printer for all logs except Level.debug
/// logs, which will use SimplePrinter().
class HybridPrinter extends LogPrinter {
  final Map<Level, LogPrinter> _printerMap;

  HybridPrinter(
    LogPrinter realPrinter, {
    LogPrinter? debug,
    LogPrinter? verbose,
    LogPrinter? wtf,
    LogPrinter? info,
    LogPrinter? warning,
    LogPrinter? error,
  }) : _printerMap = {
          Level.debug: debug ?? realPrinter,
          Level.verbose: verbose ?? realPrinter,
          Level.wtf: wtf ?? realPrinter,
          Level.info: info ?? realPrinter,
          Level.warning: warning ?? realPrinter,
          Level.error: error ?? realPrinter,
        };

  @override
  List<String> log(LogEvent event) {
    final log = _printerMap[event.level]?.log(event);
    assert(log != null);
    return log ?? [];
  }
}
