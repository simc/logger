## 1.3.0

- Fixed stackTrace count when using `stackTraceBeginIndex`.
  Addresses [#114](https://github.com/simc/logger/issues/114).
- Added proper FileOutput stub. Addresses [#94](https://github.com/simc/logger/issues/94).
- Added `isClosed`. Addresses [#130](https://github.com/simc/logger/issues/130).
- Added `time` to LogEvent.
- Added `error` handling to LogfmtPrinter.

## 1.2.2

- Fixed conditional LogOutput export. Credits to
  @ChristopheOosterlynck [#4](https://github.com/Bungeefan/logger/pull/4).

## 1.2.1

- Reverted `${this}` interpolation and added linter
  ignore. [#1](https://github.com/Bungeefan/logger/issues/1)

## 1.2.0

- Added origin LogEvent to OutputEvent. Addresses [#133](https://github.com/simc/logger/pull/133).
- Re-added LogListener and OutputListener (Should restore compatibility with logger_flutter).
- Replaced pedantic with lints.

## 1.1.0

- Enhance boxing control with PrettyPrinter. Credits to @timmaffett
- Add trailing new line to FileOutput. Credits to @narumishi
- Add functions as a log message. Credits to @smotastic

## 1.0.0

- Stable nullsafety

## 1.0.0-nullsafety.0
- Convert to nullsafety. Credits to @DevNico

## 0.9.4
- Remove broken platform detection.

## 0.9.3
- Add `MultiOutput`. Credits to @gmpassos.
- Handle browser Dart stacktraces in PrettyPrinter. Credits to @gmpassos.
- Add platform detection. Credits to @gmpassos.
- Catch output exceptions. Credits to @gmpassos.
- Several documentation fixes. Credits to @gmpassos.

## 0.9.2
- Add `PrefixPrinter`. Credits to @tkutcher.
- Add `HybridPrinter`. Credits to @tkutcher.

## 0.9.1
- Fix logging output for Flutter Web. Credits to @nateshmbhat and @Cocotus.

## 0.9.0
- Remove `OutputCallback` and `LogCallback`
- Rename `SimplePrinter`s argument `useColor` to `colors`
- Rename `DebugFilter` to `DevelopmentFilter`
- 
## 0.8.3
- Add LogfmtPrinter
- Add colored output to SimplePrinter

## 0.8.2
- Add StreamOutput

## 0.8.1
- Deprecate callbacks

## 0.8.0
- Fix SimplePrinter showTime #12
- Remove buffer field
- Update library structure (thanks @marcgraub!)

## 0.7.0+1
- Added `ProductionFilter`, `FileOutput`, `MemoryOutput`, `SimplePrinter`
- Breaking: Changed `LogFilter`, `LogPrinter` and `LogOutput`

## 0.6.0
- Added option to output timestamp
- Added option to disable color
- Added `LogOutput`
- Behaviour change of `LogPrinter`
- Remove dependency

## 0.5.0
- Added emojis
- `LogFilter` is a class now

## 0.4.0
- First version of the new logger
