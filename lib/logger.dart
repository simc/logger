/// Small, easy to use and extensible logger which prints beautiful logs.
library logger;

export 'src/ansi_color.dart';

export 'src/filters/development_filter.dart';
export 'src/filters/production_filter.dart';

export 'src/outputs/console_output.dart';
export 'src/outputs/stream_output.dart';
export 'src/outputs/memory_output.dart';
export 'src/outputs/multi_output.dart';

export 'src/printers/pretty_printer.dart';
export 'src/printers/logfmt_printer.dart';
export 'src/printers/simple_printer.dart';
export 'src/printers/hybrid_printer.dart';
export 'src/printers/prefix_printer.dart';

export 'src/log_output.dart'
    if (dart.library.io) 'src/outputs/file_output.dart';

export 'src/log_filter.dart';
export 'src/log_output.dart';
export 'src/log_printer.dart';
export 'src/logger.dart';
