import 'package:logger/logger.dart';
import 'dart:developer';

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      log(line); // use log() from 'dart:developer' instead of print()
    }
  }
}

var logger = Logger(
  output: ConsoleOutput(),
);

void main() {
  logger.e('My Error');
}
