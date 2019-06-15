part of logger;

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class SimplePrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  final bool printTime;

  SimplePrinter({this.printTime = false});

  @override
  void log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);
    var errorStr = event.error != null ? "  ERROR: ${event.error}" : "";
    println("${levelPrefixes[event.level]}  $messageStr$errorStr");
  }

  String stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
