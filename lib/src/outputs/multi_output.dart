import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Logs simultaneously to multiple [LogOutput] outputs.
class MultiOutput extends LogOutput {
  List<LogOutput> _outputs;

  MultiOutput(List<LogOutput> outputs) {
    _outputs = _normalizeOutputs(outputs);
  }

  List<LogOutput> _normalizeOutputs(List<LogOutput> outputs) {
    if (outputs == null) return [];

    outputs.removeWhere((o) => o == null);

    return outputs;
  }

  @override
  void init() {
    _outputs.forEach((o) => o.init());
  }

  @override
  void output(OutputEvent event) {
    _outputs.forEach((o) => o.output(event));
  }
}
