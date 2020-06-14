import 'dart:collection';

import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Buffers [OutputEvent]s.
class MemoryOutput extends LogOutput {
  /// Maximum elements in [buffer].
  final int bufferSize;

  /// A secondary [LogOutput] to also received events.
  final LogOutput secondOutput;

  /// The buffer of events.
  final ListQueue<OutputEvent> buffer;

  MemoryOutput({this.bufferSize = 20, this.secondOutput})
      : buffer = ListQueue(bufferSize);

  /// Length of memory [buffer].
  int get length => buffer.length;

  /// Returns the event in [buffer] at [index].
  ///
  /// If [index] is out of bounds returns [null].
  OutputEvent operator [](int index) {
    return index < buffer.length ? buffer.elementAt(index) : null;
  }

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
