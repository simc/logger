import 'package:logger/logger.dart';

import 'platform.dart';

bool isPlatformWebImpl() => false;

bool isPlatformVMImpl() => false;

bool getPlatformConsoleAcceptsColorsImpl() => false;

int getPlatformConsoleColumnsImpl() => 120;

ConsolePrinter getPlatformConsoleLogPrinter() => (arg) => print(arg);

ConsolePrinter getPlatformConsoleInfoPrinter() => (arg) => print(arg);

ConsolePrinter getPlatformConsoleWarnPrinter() => (arg) => print(arg);

ConsolePrinter getPlatformConsoleErrorPrinter() => (arg) => print(arg);

bool isPlatformConsolePrinterHeadIndented(Level level) => false;
