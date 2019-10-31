import 'dart:collection';

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_output.dart';

/// Buffers [OutputEvent]s.
class MemoryOutput extends LogOutput {
  final int bufferSize;
  final LogOutput secondOutput;
  final ListQueue<OutputEvent> buffer;

  MemoryOutput({this.bufferSize = 20, this.secondOutput})
      : buffer = ListQueue(bufferSize);

  @override
  void output(OutputEvent event) {
    if (buffer.length == bufferSize) {
      buffer.removeFirst();
    }

    buffer.add(event);

    if (secondOutput != null) {
      secondOutput.output(event);
    }
  }
}
