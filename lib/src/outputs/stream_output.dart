import 'dart:async';

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_output.dart';

class StreamOutput extends LogOutput {
  late StreamController<List<String>> _controller;
  bool _shouldForward = false;

  StreamOutput() {
    _controller = StreamController<List<String>>(
      onListen: () => _shouldForward = true,
      onPause: () => _shouldForward = false,
      onResume: () => _shouldForward = true,
      onCancel: () => _shouldForward = false,
    );
  }

  Stream<List<String>> get stream => _controller.stream;

  @override
  void output(OutputEvent event) {
    if (!_shouldForward) {
      return;
    }

    _controller.add(event.lines);
  }

  @override
  void destroy() {
    _controller.close();
  }
}
