/// Small, easy to use and extensible logger which prints beautiful logs.
library logger;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'src/ansi_color.dart';

part 'src/filters/debug_filter.dart';
part 'src/filters/production_filter.dart';
part 'src/outputs/console_output.dart';
part 'src/outputs/file_output.dart';
part 'src/outputs/memory_output.dart';
part 'src/printers/pretty_printer.dart';
part 'src/printers/simple_printer.dart';

part 'src/log_filter.dart';
part 'src/log_output.dart';
part 'src/log_printer.dart';
part 'src/logger.dart';
