# AppLogger

OSLog (`os.Logger`) tabanlı protokol soyutlamalı logging.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (fully standalone)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `LoggerProtocol` | protocol | `debug` / `info` / `warning` / `error` sözleşmesi. Çağrı taraflarında `#file`, `#function`, `#line` default'ları kullanılabilsin diye public extension'da varsayılanlı sarmalayıcılar tanımlıdır |
| `AppLogger` | final class | Apple unified logging (`os.Logger`) tabanlı default implementasyon. `subsystem`, `category`, `isEnabled` parametreleri ile yapılandırılır |

## Kullanım

```swift
import AppLogger

let logger: LoggerProtocol = AppLogger(category: "network")
logger.debug("Request started")
logger.info("Request completed")
logger.error("Failure: \(error.localizedDescription)")
```

`subsystem` default olarak `Bundle.main.bundleIdentifier`; testte `subsystem: "test.suite"` ile izole edilir.

## Test edilebilirlik

`LoggerProtocol`'a uyan basit bir test double üretip mesajları biriktirebilirsiniz; bu paket bir mock sunmuyor (`os.Logger` zaten test'lerde sessiz çalışır).

```swift
final class StubLogger: LoggerProtocol {
    var messages: [(String, String)] = []
    func debug(_ m: String, file: String, function: String, line: Int) { messages.append(("D", m)) }
    func info(_ m: String, file: String, function: String, line: Int)  { messages.append(("I", m)) }
    func warning(_ m: String, file: String, function: String, line: Int) { messages.append(("W", m)) }
    func error(_ m: String, file: String, function: String, line: Int) { messages.append(("E", m)) }
}
```

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AppLogger-<semver>`).
