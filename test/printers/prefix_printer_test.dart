import 'package:logger_fork/src/logger.dart';
import 'package:logger_fork/src/printers/prefix_printer.dart';
import 'package:logger_fork/src/printers/pretty_printer.dart';
import 'package:logger_fork/src/printers/simple_printer.dart';
import 'package:test/test.dart';

void main() {
  var debugEvent = LogEvent(Level.debug, 'debug', 'blah', StackTrace.current);
  var infoEvent = LogEvent(Level.info, 'info', 'blah', StackTrace.current);
  var warningEvent = LogEvent(Level.warning, 'warning', 'blah', StackTrace.current);
  var errorEvent = LogEvent(Level.error, 'debug', 'blah', StackTrace.current);
  var verboseEvent = LogEvent(Level.verbose, 'debug', 'blah', StackTrace.current);
  var wtfEvent = LogEvent(Level.wtf, 'debug', 'blah', StackTrace.current);

  var allEvents = [debugEvent, warningEvent, errorEvent, verboseEvent, wtfEvent];

  test('prefixes logs', () {
    var printer = PrefixPrinter(PrettyPrinter());
    var actualLog = printer.log(infoEvent);
    for (final logString in actualLog) {
      expect(logString, contains('INFO'));
    }

    var debugLog = printer.log(debugEvent);
    for (final logString in debugLog) {
      expect(logString, contains('DEBUG'));
    }
  });

  test('can supply own prefixes', () {
    var printer = PrefixPrinter(PrettyPrinter(), debug: 'BLAH');
    var actualLog = printer.log(debugEvent);
    for (final logString in actualLog) {
      expect(logString, contains('BLAH'));
    }
  });

  test('pads to same length', () {
    const longPrefix = 'EXTRALONGPREFIX';
    const len = longPrefix.length;
    var printer = PrefixPrinter(SimplePrinter(), debug: longPrefix);
    for (final event in allEvents) {
      var l1 = printer.log(event);
      for (final logString in l1) {
        expect(logString.substring(0, len), isNot(contains('[')));
      }
    }
  });
}
