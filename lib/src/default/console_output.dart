part of logger;

/// Default implementation of [LogOutput].
///
/// It sends everything to the system console.
class ConsoleOutput extends LogOutput {
  @override
  void output(Level level, List<String> lines) {
    for (var line in lines) {
      print(line);
    }
  }
}
