import 'package:logger/logger.dart';

/// Creates a filter which allows logs to be selectively ignored based on the
/// caller Type so that you can compartmentalise printed logs. To be used in
/// conjunction with a Logger.
///
/// E.g., if ExampleClass1.method() and ExampleClass2.method() calls
/// logger.d('some debug message');
/// and you are working in Level.debug, but only need the logs for ExampleClass1,
/// then you can initialise [ignoreTypes] with {ExampleClass2}, and logs from
/// ExampleClass 2 will not be shown.
class TypeFilter extends DevelopmentFilter {
  TypeFilter({required this.ignoreTypes, required this.ignoreLevel});

  /// Sets the caller types where logs should not be printed below a certain ignoreLevel
  final Set<Type> ignoreTypes;

  /// Sets the level above which logs for callers in ignoreTypes are not printed.
  ///
  /// This allows you to always print higher level logs, e.g., warnings and above, even
  /// if it is in ignoreTypes
  final Level ignoreLevel;

  @override
  bool shouldLog(LogEvent event) {
    // Ignore printing of callers of types included in ignoreClass so that you
    //
    if (ignoreTypes.any(
        (element) => event.message.toString().contains(element.toString()))) {
      // Always print if event level is above ignoreLevel
      if (event.level.index >= ignoreLevel.index) {
        return true;
      } else {
        return false;
      }
    }
    // If not in a caller type which should be ignored, use default handling
    return super.shouldLog(event);
  }
}
