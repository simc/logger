import 'package:logger/src/logger.dart';

/// An abstract handler of log events.
///
/// A log printer creates and formats the output, which is then sent to
/// [LogOutput]. Every implementation has to use the [LogPrinter.println]
/// method to send the output.
///
/// You can implement a `LogPrinter` from scratch or extend [PrettyPrinter].
abstract class LogPrinter {
  void init() {}

  /// Is called every time a new [LogEvent] is sent and handles printing or
  /// storing the message.
  List<String> log(LogEvent event);

  void destroy() {}
}
