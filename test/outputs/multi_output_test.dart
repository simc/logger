import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Multiple outputs are populated with the same events', () {
    var output1 = MemoryOutput(bufferSize: 2);
    var output2 = MemoryOutput(bufferSize: 2);

    var multiOutput = MultiOutput([output1, output2]);

    expect(output1.length, 0);
    expect(output2.length, 0);

    final event0 = OutputEvent(Level.info, []);
    multiOutput.output(event0);

    expect(output1.length, 1);
    expect(output2.length, 1);
    expect(output1[0], equals(output2[0]));
    expect(output1[0], equals(event0));

    final event1 = OutputEvent(Level.info, []);
    multiOutput.output(event1);

    expect(output1.length, 2);
    expect(output2.length, 2);
    expect(output1[0], equals(output2[0]));
    expect(output1[0], equals(event0));
    expect(output1[1], equals(output2[1]));
    expect(output1[1], equals(event1));

    final event2 = OutputEvent(Level.info, []);
    multiOutput.output(event2);

    expect(output1.length, 2);
    expect(output2.length, 2);
    expect(output1[0], equals(output2[0]));
    expect(output1[0], equals(event1));
    expect(output1[1], equals(output2[1]));
    expect(output1[1], equals(event2));
  });
}
