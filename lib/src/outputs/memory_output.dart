part of logger;

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
      buffer.take(1);
    }

    buffer.add(event);

    if (secondOutput != null) {
      secondOutput.output(event);
    }
  }
}
