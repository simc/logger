import 'package:test/test.dart';
import 'package:logger/logger.dart';

void main() {
  LogEvent event = LogEvent(
    Level.debug,
    "some message",
    "some error",
    StackTrace.current,
  );

  test('represent event on a single line (ignoring stacktrace)', () {
    var outputs = SimplePrinter().log(event);

    expect(outputs, hasLength(1));
    expect(outputs[0], '[D]  some message  ERROR: some error');
  });

  test('print time', () {
    var printer = SimplePrinter(printTime: true);

    expect(printer.log(event)[0], contains('TIME'));
  });

  test('omits error when null', () {
    LogEvent withoutError = LogEvent(
      Level.debug,
      "some message",
      null,
      StackTrace.current,
    );
    var outputs = SimplePrinter().log(withoutError);

    expect(outputs[0], isNot(contains('ERROR')));
  });

  test('deal with Map type message', () {
    var withMap = LogEvent(
      Level.debug,
      {"foo": 123},
      "some error",
      StackTrace.current,
    );

    expect(
      SimplePrinter().log(withMap)[0],
      '[D]  {"foo":123}  ERROR: some error',
    );
  });

  test('deal with Iterable type message', () {
    var withIterable = LogEvent(
      Level.debug,
      [1, 2, 3, 4],
      "some error",
      StackTrace.current,
    );

    expect(
      SimplePrinter().log(withIterable)[0],
      '[D]  [1,2,3,4]  ERROR: some error',
    );
  });
}
