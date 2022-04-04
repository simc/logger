import 'package:test/test.dart';
import 'package:logger/logger.dart';

void main() {
  test('writes to a Stream', () {
    var out = StreamOutput();

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(level: Level.debug, lines: ['hi there']));
  });

  test('respects listen', () {
    var out = StreamOutput();

    out.output(OutputEvent(level: Level.debug, lines: ['dropped']));

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(level: Level.debug, lines: ['hi there']));
  });

  test('respects pause', () {
    var out = StreamOutput();

    var sub = out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    sub.pause();
    out.output(OutputEvent(level: Level.debug, lines: ['dropped']));
    sub.resume();
    out.output(OutputEvent(level: Level.debug, lines: ['hi there']));
  });
}
