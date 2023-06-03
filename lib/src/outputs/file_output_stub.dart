import 'dart:convert';
import 'dart:io';

import '../log_output.dart';
import '../logger.dart';

class FileOutput extends LogOutput {
  FileOutput({
    required File file,
    bool overrideExisting = false,
    Encoding encoding = utf8,
  }) {
    throw UnsupportedError("Not supported on this platform.");
  }

  @override
  void output(OutputEvent event) {
    throw UnsupportedError("Not supported on this platform.");
  }
}
