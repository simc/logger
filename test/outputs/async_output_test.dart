import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  test('Async output is fully flushed', () async {
    var mainOutput = MemoryOutput(bufferSize: 2);
    var asyncOutput = AsyncOutput(mainOutput);

    expect(mainOutput.length, 0);

    final event0 = OutputEvent(Level.info, ['0']);
    asyncOutput.output(event0);
    expect(mainOutput.length, 0);

    await _sleep(500);
    expect(mainOutput.length, 1);

    final event1 = OutputEvent(Level.info, ['1']);
    asyncOutput.output(event1);
    expect(mainOutput.length, 1);

    await _sleep(500);
    expect(mainOutput.length, 2);

    expect(mainOutput[0], equals(event0));
    expect(mainOutput[1], equals(event1));

    final event2 = OutputEvent(Level.info, ['2']);
    asyncOutput.output(event2);
    expect(mainOutput.length, 2);

    await _sleep(500);
    expect(mainOutput.length, 2);

    expect(mainOutput[0], equals(event1));
    expect(mainOutput[1], equals(event2));

    expect(asyncOutput.eventsQueueLength, 0);
    expect(asyncOutput.flush(), 0);
    expect(asyncOutput.eventsQueueLength, 0);

    final event3 = OutputEvent(Level.info, ['3']);
    asyncOutput.output(event3);
    expect(mainOutput[1], equals(event2));

    expect(asyncOutput.eventsQueueLength, 1);
    expect(asyncOutput.flush(), 1);
    expect(asyncOutput.eventsQueueLength, 0);

    expect(mainOutput[1], equals(event3));

    final event4 = OutputEvent(Level.info, ['4']);
    final event5 = OutputEvent(Level.info, ['5']);
    asyncOutput.output(event4);
    asyncOutput.output(event5);
    expect(mainOutput[1], equals(event3));

    expect(asyncOutput.eventsQueueLength, 2);
    await _sleep(500);
    expect(asyncOutput.eventsQueueLength, 0);

    expect(mainOutput[0], equals(event4));
    expect(mainOutput[1], equals(event5));

    final event6 = OutputEvent(Level.info, ['6']);
    final event7 = OutputEvent(Level.info, ['7']);
    asyncOutput.output(event6);
    asyncOutput.output(event7);
    expect(mainOutput[1], equals(event5));

    expect(asyncOutput.eventsQueueLength, 2);
    expect(asyncOutput.fullyFlush(), 2);
    expect(asyncOutput.eventsQueueLength, 0);

    expect(mainOutput[0], equals(event6));
    expect(mainOutput[1], equals(event7));
  });
}

Future _sleep(int delayMs) {
  return Future.delayed(Duration(milliseconds: delayMs), () {});
}
