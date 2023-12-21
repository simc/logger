import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Memory output buffer size is limited', () {
    var output = MemoryOutput(bufferSize: 2);

    final event0 = OutputEvent(LogEvent(Level.info, null), []);
    final event1 = OutputEvent(LogEvent(Level.info, null), []);
    final event2 = OutputEvent(LogEvent(Level.info, null), []);

    output.output(event0);
    output.output(event1);
    output.output(event2);

    expect(output.buffer.length, 2);
    expect(output.buffer, containsAllInOrder([event1, event2]));
  });
}
