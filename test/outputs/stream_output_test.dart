import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('writes to a Stream', () {
    var out = StreamOutput();

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(LogEvent(Level.debug, null), ['hi there']));
  });

  test('respects listen', () {
    var out = StreamOutput();

    out.output(OutputEvent(LogEvent(Level.debug, null), ['dropped']));

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(LogEvent(Level.debug, null), ['hi there']));
  });

  test('respects pause', () {
    var out = StreamOutput();

    var sub = out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    sub.pause();
    out.output(OutputEvent(LogEvent(Level.debug, null), ['dropped']));
    sub.resume();
    out.output(OutputEvent(LogEvent(Level.debug, null), ['hi there']));
  });
}
