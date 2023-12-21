import 'package:logger/logger.dart';
import 'package:logger/src/printers/caller_printer.dart';

/// Custom Logger which prints the caller of the Logger.log() method.
///
/// E.g., if ExampleClass1.method() calls logger.d('some debug message'),
/// then the console will show: ExampleClass1.method: some debug message
///
/// [ignoreCallers] can be specified to show the most relevant caller
class CallerLogger extends Logger {
  CallerLogger._({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
    required Set<String> ignoreCallers,
  })  : _ignoreCallers = ignoreCallers,
        super(filter: filter, printer: printer, output: output, level: level);

  factory CallerLogger({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
    Set<String>? ignoreCallers,
  }) {
    /// Skip callers in stack trace so that the more relevant caller is printed,
    /// e.g., methods from the loggers or utility functions
    final _defaultIgnoreCallers = {
      'CallerLogger.log',
      'Logger.',
    };
    if (ignoreCallers == null) {
      ignoreCallers = _defaultIgnoreCallers;
    } else {
      ignoreCallers.addAll(_defaultIgnoreCallers);
    }
    return CallerLogger._(
      filter: filter,
      printer: printer ?? CallerPrinter(),
      output: output,
      level: level,
      ignoreCallers: ignoreCallers,
    );
  }

  Set<String> _ignoreCallers;

  @override
  void log(Level level, message, [error, StackTrace? stackTrace]) {
    // get caller
    final lines = StackTrace.current.toString().split('\n');
    var caller = 'CallerNotFound';
    for (var line in lines) {
      if (_ignoreCallers.any((element) => line.contains(element))) {
        continue;
      } else {
        // ! caller in StackTrace #x seems to be i=6 when split by spaces
        // ! this may bug out if formatting of StackTrace changes
        caller = line.split(' ')[6].trim();
        break; // exit loop to save first caller which is not from the logger
      }
    }
    super.log(level, caller + ': ' + message, error, stackTrace);
  }
}
