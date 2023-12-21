import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  var printer = LogfmtPrinter();

  test('includes level', () {
    expect(
      printer.log(LogEvent(
        Level.debug,
        'some message',
        Exception('boom'),
        StackTrace.current,
      ))[0],
      contains('level=debug'),
    );
  });

  test('with a string message includes a msg key', () {
    expect(
      printer.log(LogEvent(
        Level.debug,
        'some message',
        Exception('boom'),
        StackTrace.current,
      ))[0],
      contains('msg="some message"'),
    );
  });

  test('includes random key=value pairs', () {
    var output = printer.log(LogEvent(
      Level.debug,
      {'a': 123, 'foo': 'bar baz'},
      Exception('boom'),
      StackTrace.current,
    ))[0];

    expect(output, contains('a=123'));
    expect(output, contains('foo="bar baz"'));
  });

  test('handles an error/exception', () {
    var output = printer.log(LogEvent(
      Level.debug,
      'some message',
      Exception('boom'),
      StackTrace.current,
    ))[0];
    expect(output, contains('error="Exception: boom"'));

    output = printer.log(LogEvent(
      Level.debug,
      'some message',
    ))[0];
    expect(output, isNot(contains('error=')));
  });

  test('handles a stacktrace', () {}, skip: 'TODO');
}
