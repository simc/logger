import 'package:test/test.dart';

import 'package:logger/src/printers/hybrid_printer.dart';
import 'package:logger/logger.dart';

final realPrinter = SimplePrinter();

class TestLogPrinter extends LogPrinter {
  LogEvent? latestEvent;
  @override
  List<String> log(LogEvent event) {
    latestEvent = event;
    return realPrinter.log(event);
  }
}

void main() {
  var printerA = TestLogPrinter();
  var printerB = TestLogPrinter();
  var printerC = TestLogPrinter();

  var debugEvent = LogEvent(Level.debug, 'debug', 'blah', StackTrace.current);
  var infoEvent = LogEvent(Level.info, 'info', 'blah', StackTrace.current);
  var warningEvent =
      LogEvent(Level.warning, 'warning', 'blah', StackTrace.current);
  var errorEvent = LogEvent(Level.error, 'error', 'blah', StackTrace.current);

  var hybridPrinter = HybridPrinter(printerA, debug: printerB, error: printerC);
  test('uses wrapped printer by default', () {
    hybridPrinter.log(infoEvent);
    expect(printerA.latestEvent, equals(infoEvent));
  });

  test('forwards logs to correct logger', () {
    hybridPrinter.log(debugEvent);
    hybridPrinter.log(errorEvent);
    hybridPrinter.log(warningEvent);
    expect(printerA.latestEvent, equals(warningEvent));
    expect(printerB.latestEvent, equals(debugEvent));
    expect(printerC.latestEvent, equals(errorEvent));
  });
}
