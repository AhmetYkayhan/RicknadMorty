# AppNetwork

URLSession tabanlı, Endpoint protokolü etrafında inşa edilmiş ufak bir networking katmanı.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar: `AppCore`, `AppLogger`

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `Endpoint` | protocol | `baseURL`, `path`, `method`, `headers`, `queryItems`, `body`. `baseURL` **default'u yok** — her concrete endpoint açıkça belirtmeli (paket Rick&Morty'den bağımsız) |
| `Endpoint.asURLRequest()` | extension method | `URLRequest` üretir; URL inşası ve hata haritalama dahili |
| `HTTPMethod` | enum | `get`, `post`, `put`, `delete`, `patch` |
| `NetworkClientProtocol` | protocol | `request<T: Decodable>(...) async throws -> T` ve `request(...) async throws -> Data` |
| `NetworkClient` | final class | Default `URLSession` + `JSONDecoder` implementasyonu. Hataları `NetworkError`'a haritalar; `LoggerProtocol` üzerinden istek/yanıt loglar |
| `RequestBuilder` | struct | Builder pattern; programmatik URL inşası gerektiğinde kullanılabilir (`Endpoint`'a alternatif) |

## Kullanım

```swift
import AppNetwork
import AppLogger

enum CharactersEndpoint: Endpoint {
    case list(page: Int)

    var baseURL: String { "https://rickandmortyapi.com/api" }
    var path: String { "/character" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? {
        if case .list(let page) = self { return [.init(name: "page", value: "\(page)")] }
        return nil
    }
}

let logger: LoggerProtocol = AppLogger(category: "network")
let client: NetworkClientProtocol = NetworkClient(logger: logger)

struct CharactersResponse: Decodable { let results: [Character] }
let response: CharactersResponse = try await client.request(CharactersEndpoint.list(page: 1))
```

## Test edilebilirlik

`NetworkClientProtocol` mock'lanır; veya `NetworkClient(session: URLSession(configuration: .ephemeral))` ile `URLProtocol`-stub yaklaşımı kullanılır. Bu paket built-in mock sunmaz.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AppNetwork-<semver>`).

## Notlar

- 8.A kapsamında `Endpoint`'in default `baseURL` davranışı kaldırıldı; her endpoint kendi base URL'ini override eder. Böylece paket başka projeye düşürüldüğünde hardcoded bir host kalmaz.
