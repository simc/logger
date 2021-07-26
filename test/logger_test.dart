import 'dart:math';

import 'package:test/test.dart';
import 'package:logger/logger.dart';

typedef PrinterCallback = List<String> Function(
  Level level,
  dynamic message,
  dynamic error,
  StackTrace? stackTrace,
  String? tag,
);

class _AlwaysFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

class _NeverFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => false;
}

class _CallbackPrinter extends LogPrinter {
  final PrinterCallback callback;

  _CallbackPrinter(this.callback);

  @override
  List<String> log(LogEvent event) {
    return callback(
      event.level,
      event.message,
      event.error,
      event.stackTrace,
      event.tag,
    );
  }
}

void main() {
  Level? printedLevel;
  dynamic printedMessage;
  dynamic printedError;
  StackTrace? printedStackTrace;
  String? printTag;
  var callbackPrinter = _CallbackPrinter((l, m, e, s,t) {
    printedLevel = l;
    printedMessage = m;
    printedError = e;
    printedStackTrace = s;
    printTag = t;
    return [];
  });

  setUp(() {
    printedLevel = null;
    printedMessage = null;
    printedError = null;
    printedStackTrace = null;
  });

  test('Logger.log', () {
    var logger = Logger(filter: _NeverFilter(), printer: callbackPrinter);
    logger.log(Level.debug, 'Some message');

    expect(printedMessage, null);

    logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);

    var levels = Level.values.take(6);
    for (var level in levels) {
      var message = Random().nextInt(999999999).toString();
      logger.log(level, message);
      expect(printedLevel, level);
      expect(printedMessage, message);
      expect(printedError, null);
      expect(printedStackTrace, null);

      message = Random().nextInt(999999999).toString();
      logger.log(level, message, 'MyError');
      expect(printedLevel, level);
      expect(printedMessage, message);
      expect(printedError, 'MyError');
      expect(printedStackTrace, null);

      message = Random().nextInt(999999999).toString();
      var stackTrace = StackTrace.current;
      logger.log(level, message, 'MyError', stackTrace);
      expect(printedLevel, level);
      expect(printedMessage, message);
      expect(printedError, 'MyError');
      expect(printedStackTrace, stackTrace);
    }

    expect(() => logger.log(Level.verbose, 'Test', StackTrace.current),
        throwsArgumentError);
    expect(() => logger.log(Level.nothing, 'Test'), throwsArgumentError);
  });

  test('Logger.v', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.v(message: 'Test', error: 'Error', stackTrace: stackTrace, tag: 'LogV');
    expect(printedLevel, Level.verbose);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogV');
  });

  test('Logger.d', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.d(message: 'Test', error: 'Error', stackTrace:stackTrace, tag: 'LogD');
    expect(printedLevel, Level.debug);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogD');
  });

  test('Logger.i', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.i(message: 'Test', error: 'Error', stackTrace: stackTrace, tag: 'LogI');
    expect(printedLevel, Level.info);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogI');
  });

  test('Logger.w', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.w(message: 'Test', error: 'Error', stackTrace: stackTrace, tag: 'LogW');
    expect(printedLevel, Level.warning);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogW');
  });

  test('Logger.e', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.e(message: 'Test', error: 'Error', stackTrace: stackTrace,tag: 'LogE');
    expect(printedLevel, Level.error);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogE');
  });

  test('Logger.wtf', () {
    var logger = Logger(filter: _AlwaysFilter(), printer: callbackPrinter);
    var stackTrace = StackTrace.current;
    logger.wtf(message: 'Test', error: 'Error', stackTrace: stackTrace, tag: 'LogWTF');
    expect(printedLevel, Level.wtf);
    expect(printedMessage, 'Test');
    expect(printedError, 'Error');
    expect(printedStackTrace, stackTrace);
    expect(printTag, 'LogWTF');
  });

  test('setting log level above log level of message', () {
    printedMessage = null;
    var logger = Logger(
      filter: ProductionFilter(),
      printer: callbackPrinter,
      level: Level.warning,
    );

    logger.d(message: 'This isn\'t logged');
    expect(printedMessage, isNull);

    logger.w(message: 'This is');
    expect(printedMessage, 'This is');
  });
}
