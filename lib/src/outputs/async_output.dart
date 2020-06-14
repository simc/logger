import 'dart:collection';

import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Logs asynchronously to [mainOutput].
///
/// Useful when you wan't to avoid interference of log operations in the main
/// software, specially of IO operations, like writing to files and network.
class AsyncOutput extends LogOutput {
  /// The main [LogOutput].
  final LogOutput mainOutput;

  AsyncOutput(this.mainOutput);

  @override
  void output(OutputEvent event) {
    _outputAsync(event);
  }

  /// The event queue.
  final ListQueue<OutputEvent> _eventsQueue = ListQueue(32);

  /// Returns [true] if has some event in queue to flush ([eventsQueueLength] > 0).
  bool get hasEventToFlush => _eventsQueue.isNotEmpty;

  /// Returns [true] if events queue is empty ([eventsQueueLength] == 0).
  bool get isFullyFlushed => _eventsQueue.isEmpty;

  /// Returns the length of the events queue.
  int get eventsQueueLength => _eventsQueue.length;

  void _outputAsync(OutputEvent event) {
    _eventsQueue.addLast(event);
    _scheduleFlush();
  }

  bool _scheduledFlush = false;

  void _scheduleFlush() {
    if (_scheduledFlush) return;
    _scheduledFlush = true;
    Future.microtask(flush);
  }

  int _maximumFlushTime = 100;

  /// The maximum amount of time in milliseconds that a single flush operation
  /// can take.
  ///
  /// If a flush operation takes more than [maximumFlushTime]
  /// it will stop and resume after some milliseconds, releasing time for
  /// the main software.
  int get maximumFlushTime => _maximumFlushTime;

  set maximumFlushTime(int value) {
    if (value == null) {
      value = 100;
    } else if (value < 1) {
      value = 1;
    }
    _maximumFlushTime = value;
  }

  int _consecutiveIncompleteFlushCount = 0;

  /// Flushes the queue of events.
  /// Returns the amount of events sent to [mainOutput].
  ///
  /// You don't need to call directly this method, since internally it's
  /// automatically scheduled. If you really want you can call it at any time.
  int flush() {
    var eventCount = 0;

    int init;

    while (true) {
      var length = _eventsQueue.length;
      if (length == 0) break;

      var event = _eventsQueue.removeFirst();

      if (length == 1) {
        _mainOutput(event);
        eventCount++;
        break;
      } else {
        init ??= DateTime.now().microsecondsSinceEpoch;
        _mainOutput(event);
        eventCount++;
        var elapsedTime = DateTime.now().microsecondsSinceEpoch - init;
        if (elapsedTime > _maximumFlushTime) {
          break;
        }
      }
    }

    if (_eventsQueue.isNotEmpty) {
      _scheduledFlush = true;
      _consecutiveIncompleteFlushCount++;

      var delay = _consecutiveIncompleteFlushCount * 2;
      if (delay > 100) delay = 100;

      Future.delayed(Duration(milliseconds: delay), flush);
    } else {
      _consecutiveIncompleteFlushCount = 0;
      _scheduledFlush = false;
    }

    return eventCount;
  }

  /// Fully flushes the events queue.
  int fullyFlush() {
    var eventCount = 0;

    while (_eventsQueue.isNotEmpty) {
      var event = _eventsQueue.removeFirst();
      _mainOutput(event);
      eventCount++;
    }

    _consecutiveIncompleteFlushCount = 0;
    _scheduledFlush = false;

    return eventCount;
  }

  /// Outputs to the [mainOutput].
  void _mainOutput(OutputEvent event) {
    try {
      mainOutput.output(event);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
