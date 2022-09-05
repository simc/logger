import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:logger/src/filters/type_filter.dart';
import 'package:logger/src/loggers/caller_logger.dart';

var logger = CallerLogger(
  ignoreCallers: {
    'syncTryCatchHandler',
  },
  filter: TypeFilter(
    ignoreTypes: {
      IgnoredClass,
    },
    ignoreLevel: Level.warning,
  ),
  level: Level.verbose,
);

void main() {
  print(
      'Run with either `dart example/caller_logger/main.dart` or `dart --enable-asserts example/caller_logger/main.dart`.');
  demo();
}

void demo() {
  /// Settings are such that:
  ///
  /// 1. All logs in ExampleClass are printed (because level: Level.verbose)
  /// 2. Logs in IgnoredClass are not printed (because ignoreTypes: IgnoredClass),
  /// except for logs at level of warning and above (because ignoreLevel: Level.warning)

  ExampleClass.run();
  print('========================================');
  IgnoredClass.run();
  print('========================================');

  /// 3. Printed log for this will show ExampleClass.nestedRun() instead of
  /// syncTryCatchHandler (because ignoreCallers: {'syncTryCatchHandler'})
  ExampleClass.nestedRun();
}

class ExampleClass {
  static void run() {
    logger.log(Level.verbose, 'log: verbose');

    logger.v('verbose');
    logger.d('debug');
    logger.i('info');
    logger.w('warning');
    logger.e('error');
    logger.wtf('wtf');
  }

  static void nestedRun() {
    // nested functions will print
    syncTryCatchHandler(
      tryFunction: () => jsonDecode('thisIsNotJson'),
    );
  }
}

class IgnoredClass {
  static void run() {
    logger.v('verbose');
    logger.d('debug');
    logger.i('info');
    logger.w('warning');
    logger.e('error');
    logger.wtf('wtf');
  }
}

/// Synchronous try and catch handler to reduce boilerplate
///
/// Used as an example to show how nested functions can be ignored in [ignoreCallers]
dynamic syncTryCatchHandler(
    {dynamic Function()? tryFunction,
    Map<Exception, dynamic Function()?>? catchKnownExceptions,
    dynamic Function()? catchUnknownExceptions}) {
  try {
    try {
      return tryFunction?.call();
    } on Exception catch (e, s) {
      if (catchKnownExceptions == null) {
        rethrow;
      } else if (catchKnownExceptions.containsKey(e)) {
        logger.w('handling known exception', e, s);
        catchKnownExceptions[e]?.call();
      } else {
        rethrow;
      }
    }
  } catch (e, s) {
    logger.e('catchUnknown', e, s);
    catchUnknownExceptions?.call();
  }
}
