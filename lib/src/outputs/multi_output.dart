import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Logs simultaneously to multiple [LogOutput] outputs.
class MultiOutput extends LogOutput {
  late List<LogOutput> _outputs;

  MultiOutput(List<LogOutput?>? outputs) {
    _outputs = _normalizeOutputs(outputs);
  }

  List<LogOutput> _normalizeOutputs(List<LogOutput?>? outputs) {
    final normalizedOutputs = <LogOutput>[];

    if (outputs != null) {
      for (final output in outputs) {
        if (output != null) {
          normalizedOutputs.add(output);
        }
      }
    }

    return normalizedOutputs;
  }

  @override
  void init() {
    for (var o in _outputs) {
      o.init();
    }
  }

  @override
  void output(OutputEvent event) {
    for (var o in _outputs) {
      o.output(event);
    }
  }

  @override
  void destroy() {
    for (var o in _outputs) {
      o.destroy();
    }
  }
}
