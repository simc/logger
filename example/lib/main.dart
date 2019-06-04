import 'package:logger/logger.dart';

var logger = Logger();

var loggerNoStack = Logger(printer: PrettyPrinter());

void main() {
  teesr();
}

void foo() {
  logger.v("Log message with 2 methods");

  logger.d("Log message with 2 methods", "MIST");

  logger.i("Log message with 2 methods");

  logger.w("Just a warning!");

  logger.e("Error! Something bad happened", "PROB");

  logger.wtf("Hello world.", "PROBLEM!", StackTrace.current);

  logger.d({"key": 5, "value": "something"});
}

void teesr() {
  foo();
}
