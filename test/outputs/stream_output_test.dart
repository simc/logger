import 'package:test/test.dart';
import 'package:logger/logger.dart';

void main() {
  test('writes to a Stream', () {
    var out = StreamOutput();

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(Level.debug, ['hi there']));
  });

  test('respects listen', () {
    var out = StreamOutput();

    out.output(OutputEvent(Level.debug, ['dropped']));

    out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    out.output(OutputEvent(Level.debug, ['hi there']));
  });

  test('respects pause', () {
    var out = StreamOutput();

    var sub = out.stream.listen((var e) {
      expect(e, ['hi there']);
    });

    sub.pause();
    out.output(OutputEvent(Level.debug, ['dropped']));
    sub.resume();
    out.output(OutputEvent(Level.debug, ['hi there']));
  });
}
