## 0.9.2
- New MultiOutput: allow multiple simultaneous outputs.
- New LogPlatform: identifies the runtime platform, and it's capabilities.
- ConsoleOutput: now merging multiple lines to one String to avoid multiple IO calls.
- MemoryOutput: overrides `[]` operator for events buffer access.
- SimplePrinter, PrettyPrinter, PrefixPrinter: added optional `name` property.
- Logger.log(): `try` `catch` while sending events to output, to avoid `Logger` influence over the main software.
- README.md: fixed and improved badges.

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
