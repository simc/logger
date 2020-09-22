import 'dart:html';

import 'package:logger/logger.dart';

import 'platform.dart';

bool isPlatformWebImpl() => true;

bool isPlatformVMImpl() => false;

bool getPlatformConsoleAcceptsColorsImpl() => false;

int getPlatformConsoleColumnsImpl() => 80;

ConsolePrinter getPlatformConsoleLogPrinter() =>
    (arg) => window.console.log(arg);

ConsolePrinter getPlatformConsoleInfoPrinter() =>
    (arg) => window.console.info(arg);

ConsolePrinter getPlatformConsoleWarnPrinter() =>
    (arg) => window.console.warn(arg);

ConsolePrinter getPlatformConsoleErrorPrinter() =>
    (arg) => window.console.error(arg);

bool isPlatformConsolePrinterHeadIndented(Level level) {
  if (_isChrome()) {
    return level == Level.warning || level == Level.error || level == Level.wtf;
  }
  return false;
}

bool _chrome;

bool _isChrome() {
  _chrome ??= _getUserAgent().contains('chrome');
  return _chrome;
}

String _userAgent;

String _getUserAgent() {
  if (_userAgent == null) {
    String userAgent;
    try {
      userAgent = window.navigator.userAgent;
    } catch (e) {
      userAgent = '';
    }
    _userAgent = (userAgent ?? '').toLowerCase();
  }
  return _userAgent;
}
