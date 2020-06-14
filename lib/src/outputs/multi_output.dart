import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Logs simultaneously to multiple [LogOutput] outputs.
class MultiOutput extends LogOutput {
  List<LogOutput> _outputs;

  MultiOutput(List<LogOutput> outputs) {
    _outputs = _normalizeOutputs(outputs);
  }

  /// Returns [true] if contains [output].
  bool containsOutput(LogOutput output) {
    for (var o in _outputs) {
      if (identical(o, output)) return true;

      if (o is MultiOutput) {
        if (o.containsOutput(output)) return true;
      }
    }
    return false;
  }

  List<LogOutput> _normalizeOutputs(List<LogOutput> outputs) {
    if (outputs == null || outputs.isEmpty) return [];

    var outputs2 = List<LogOutput>.from(outputs);

    // Remove null or self referenced output:
    outputs2.removeWhere((o) =>
        o == null ||
        identical(o, this) ||
        (o is MultiOutput && o.containsOutput(this)));

    return outputs2;
  }

  @override
  void output(OutputEvent event) {
    for (var o in _outputs) {
      o.output(event);
    }
  }
}
