import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';
import 'package:logger/src/platform/platform.dart';

/// Default implementation of [LogOutput].
///
/// It sends everything to the system console.
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    var linesLength = event.lines.length;
    if (linesLength == 0) return;

    var level = event.level;
    var allLines = LogPlatform.joinLines(event.lines, level);
    var printer = LogPlatform.getConsolePrinter(level);

    printer(allLines);
  }
}
