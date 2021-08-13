import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  String _readMessage(List<String> log) {
    return log.reduce((acc, val) => acc + val);
  }

  final prettyPrinter = PrettyPrinter(printEmojis: false);
  test('should print an emoji when option is enabled', () {
    final expectedMessage = 'some message with an emoji';
    final emojiPrettyPrinter = PrettyPrinter(printEmojis: true);

    final event = LogEvent(
      Level.debug,
      expectedMessage,
      'some error',
      StackTrace.current,
    );

    final actualLog = emojiPrettyPrinter.log(event);
    final actualLogString = _readMessage(actualLog);
    expect(actualLogString, contains(PrettyPrinter.levelEmojis[Level.debug]));
    expect(actualLogString, contains(expectedMessage));
  });

  test('deal with string type message', () {
    final expectedMessage = 'normally computed message';
    final withFunction = LogEvent(
      Level.debug,
      expectedMessage,
      'some error',
      StackTrace.current,
    );

    final actualLog = prettyPrinter.log(withFunction);
    final actualLogString = _readMessage(actualLog);

    expect(
      actualLogString,
      contains(expectedMessage),
    );
  });
  test('deal with Map type message', () {
    final expectedMsgMap = {'foo': 123, 1: 2, true: 'false'};
    var withMap = LogEvent(
      Level.debug,
      expectedMsgMap,
      'some error',
      StackTrace.current,
    );

    final actualLog = prettyPrinter.log(withMap);
    final actualLogString = _readMessage(actualLog);
    for (var expectedMsg in expectedMsgMap.entries) {
      expect(
        actualLogString,
        contains('${expectedMsg.key}: ${expectedMsg.value}'),
      );
    }
  });

  test('deal with Iterable type message', () {
    final expectedMsgItems = ['first', 'second', 'third', 'last'];
    var withIterable = LogEvent(
      Level.debug,
      ['first', 'second', 'third', 'last'],
      'some error',
      StackTrace.current,
    );
    final actualLog = prettyPrinter.log(withIterable);
    final actualLogString = _readMessage(actualLog);
    for (var expectedMsg in expectedMsgItems) {
      expect(
        actualLogString,
        contains(expectedMsg),
      );
    }
  });

  test('deal with Function type message', () {
    final expectedMessage = 'heavily computed very pretty Message';
    final withFunction = LogEvent(
      Level.debug,
      () => expectedMessage,
      'some error',
      StackTrace.current,
    );

    final actualLog = prettyPrinter.log(withFunction);
    final actualLogString = _readMessage(actualLog);

    expect(
      actualLogString,
      contains(expectedMessage),
    );
  });
}
