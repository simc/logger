import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Default implementation of [LogOutput].
///
/// It sends everything to the system console.
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(print);
  }
}
