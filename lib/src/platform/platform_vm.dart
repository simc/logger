import 'dart:io' as io;

import 'package:logger/logger.dart';

import 'platform.dart';

bool isPlatformWebImpl() => false;

bool isPlatformVMImpl() => true;

bool _platformConsoleAcceptsColors;

bool getPlatformConsoleAcceptsColorsImpl() {
  if (_platformConsoleAcceptsColors == null) {
    try {
      _platformConsoleAcceptsColors = io.stdout.supportsAnsiEscapes;
    } catch (e) {
      _platformConsoleAcceptsColors = false;
    }
  }
  return _platformConsoleAcceptsColors;
}

int _platformConsoleColumns;

int getPlatformConsoleColumnsImpl() {
  if (_platformConsoleColumns == null) {
    try {
      _platformConsoleColumns = io.stdout.terminalColumns;
    } catch (e) {
      _platformConsoleColumns = 120;
    }
  }

  return _platformConsoleColumns;
}

ConsolePrinter getPlatformConsoleLogPrinter() => _stdoutWriteln;

ConsolePrinter getPlatformConsoleInfoPrinter() => _stdoutWriteln;

ConsolePrinter getPlatformConsoleWarnPrinter() => _stdoutWriteln;

ConsolePrinter getPlatformConsoleErrorPrinter() =>
    LogPlatform.enableSTDERR ? _stderrWriteln : _stdoutWriteln;

void _stdoutWriteln(String arg) => io.stdout.writeln(arg);

void _stderrWriteln(String arg) => io.stderr.writeln(arg);

bool isPlatformConsolePrinterHeadIndented(Level level) => false;
