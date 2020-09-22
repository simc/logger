import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Multiple outputs are populated with the same events', () {
    final output1 = MemoryOutput(bufferSize: 2);
    final output2 = MemoryOutput(bufferSize: 2);

    final multiOutput = MultiOutput([output1, output2]);

    final event0 = OutputEvent(Level.info, []);
    multiOutput.output(event0);

    expect(output1.buffer.length, 1);
    expect(output2.buffer.length, 1);
    expect(output1.buffer.elementAt(0), equals(output2.buffer.elementAt(0)));
    expect(output1.buffer.elementAt(0), equals(event0));

    final event1 = OutputEvent(Level.info, []);
    multiOutput.output(event1);

    expect(output1.buffer.length, 2);
    expect(output2.buffer.length, 2);
    expect(output1.buffer.elementAt(0), equals(output2.buffer.elementAt(0)));
    expect(output1.buffer.elementAt(0), equals(event0));
    expect(output1.buffer.elementAt(1), equals(output2.buffer.elementAt(1)));
    expect(output1.buffer.elementAt(1), equals(event1));
  });

  test('passing null does not throw an exception', () {
    final output = MultiOutput(null);
    output.output(OutputEvent(Level.info, []));
  });

  test('passing null in the list does not throw an exception', () {
    final output = MultiOutput([null]);
    output.output(OutputEvent(Level.info, []));
  });
}
