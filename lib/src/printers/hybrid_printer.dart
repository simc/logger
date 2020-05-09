import 'package:logger/logger.dart';
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
  final LogPrinter _realPrinter;
  var _printerMap;

  HybridPrinter(this._realPrinter,
      {debug, verbose, wtf, info, warning, error}) {
    _printerMap = {
      Level.debug: debug ?? _realPrinter,
      Level.verbose: verbose ?? _realPrinter,
      Level.wtf: wtf ?? _realPrinter,
      Level.info: info ?? _realPrinter,
      Level.warning: warning ?? _realPrinter,
      Level.error: error ?? _realPrinter,
    };
  }

  @override
  List<String> log(LogEvent event) => _printerMap[event.level].log(event);
}
