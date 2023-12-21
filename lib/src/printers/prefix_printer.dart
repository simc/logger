import 'package:logger_fork/src/logger_fork.dart';
import 'package:logger_fork/src/log_printer.dart';

/// A decorator for a [LogPrinter] that allows for the prepending of every
/// line in the log output with a string for the level of that log. For
/// example:
///
/// ```
/// PrefixPrinter(PrettyPrinter());
/// ```
///
/// Would prepend "DEBUG" to every line in a debug log. You can supply
/// parameters for a custom message for a specific log level.
class PrefixPrinter extends LogPrinter {
  final LogPrinter _realPrinter;
  late Map<Level, String> _prefixMap;

  PrefixPrinter(this._realPrinter, {debug, verbose, wtf, info, warning, error}) {
    _prefixMap = {
      Level.debug: debug ?? 'DEBUG',
      Level.verbose: verbose ?? 'VERBOSE',
      Level.wtf: wtf ?? 'WTF',
      Level.info: info ?? 'INFO',
      Level.warning: warning ?? 'WARNING',
      Level.error: error ?? 'ERROR',
    };

    var len = _longestPrefixLength();
    _prefixMap.forEach((k, v) => _prefixMap[k] = '${v.padLeft(len)} ');
  }

  @override
  List<String> log(LogEvent event) {
    var realLogs = _realPrinter.log(event);
    return realLogs.map((s) => '${_prefixMap[event.level]}$s').toList();
  }

  int _longestPrefixLength() {
    return _prefixMap.values.reduce(_compFunc).length;
  }

  String _compFunc(String a, String b) => a.length > b.length ? a : b;
}
