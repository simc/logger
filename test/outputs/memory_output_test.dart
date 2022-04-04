import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Memory output buffer size is limited', () {
    var output = MemoryOutput(bufferSize: 2);

    final event0 = OutputEvent(level: Level.info, lines: []);
    final event1 = OutputEvent(level: Level.info, lines: []);
    final event2 = OutputEvent(level: Level.info, lines: []);

    output.output(event0);
    output.output(event1);
    output.output(event2);

    expect(output.buffer.length, 2);
    expect(output.buffer, containsAllInOrder([event1, event2]));
  });
}
