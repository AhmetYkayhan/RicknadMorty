# AppLogger

OSLog-based logging abstraction for the RicknadMorty app.

Provides `LoggerProtocol` and a concrete `AppLogger` implementation backed by Apple's unified logging system (`os.Logger`).

## Usage

```swift
import AppLogger

let logger: LoggerProtocol = AppLogger(category: "network")
logger.info("Request sent")
logger.error("Something went wrong")
```

## Dependencies

None — this package is fully standalone.
