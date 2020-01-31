import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Memory output buffer size is limited', () {
    var output = MemoryOutput(bufferSize: 2);

    final event0 = OutputEvent(Level.info, []);
    final event1 = OutputEvent(Level.info, []);
    final event2 = OutputEvent(Level.info, []);

    output.output(event0);
    output.output(event1);
    output.output(event2);

    expect(output.buffer.length, 2);
    expect(output.buffer, containsAllInOrder([event1, event2]));
  });
}
