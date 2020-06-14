import 'dart:collection';

import 'package:logger/logger.dart';

/// A [Logger] factory.
class LoggerFactory {
  /// Name to use in printer.
  final String name;

  /// The [Logger] base [Level].
  final Level level;

  /// The [Logger] [LogFilter].
  final LogFilter filter;

  /// The [Logger] [LogPrinter].
  final LogPrinter printer;

  /// The outputs ([LogOutput]) of [Logger]. If necessary uses [MultiOutput].
  final List<LogOutput> outputs;

  /// The main [LogOutput] of [Logger]. If necessary uses [MultiOutput] to merge
  /// with [outputs].
  final LogOutput output;

  LoggerFactory(
      {this.name, this.level, this.filter, this.printer, this.outputs, this.output});

  /// Returns a new instance of [Logger].
  ///
  /// You can overwrite any constructor parameter passing it again.
  Logger get(
      {String name,
      LogFilter filter,
      Level level,
      LogPrinter printer,
      List<LogOutput> outputs,
      LogOutput output}) {
    name ??= this.name;
    filter ??= this.filter;
    printer ??= this.printer ?? PrettyPrinter(name: name);
    level ??= this.level;
    outputs ??= this.outputs ?? <LogOutput>[];
    output ??= this.output;

    if (name != null && name.isNotEmpty && printer is LogPrinterWithName) {
      var printerWithName = printer as LogPrinterWithName ;
      name = name.trim() ;
      if (name.isNotEmpty && printerWithName.name != name) {
        printer = printerWithName.copy(withName: name) ;
      }
    }

    // Ensure that order is preserved:
    // ignore: prefer_collection_literals
    var allOutputs = LinkedHashSet<LogOutput>() ;

    if (output != null) allOutputs.add(output);
    allOutputs.addAll( outputs.where((e) => e != null) ) ;

    LogOutput theOutput;

    if (allOutputs.isNotEmpty) {
      theOutput = allOutputs.length == 1
          ? allOutputs.single
          : MultiOutput(allOutputs.toList());
    }

    return Logger(level: level, filter: filter, printer: printer, output: theOutput);
  }
}
