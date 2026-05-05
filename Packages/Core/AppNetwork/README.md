# AppNetwork

Networking layer for the RicknadMorty app.

Provides `Endpoint` protocol, `NetworkClientProtocol`, a concrete `NetworkClient` backed by `URLSession`, `HTTPMethod` enum, and a builder-pattern `RequestBuilder`.

## Dependencies

- **AppCore** — uses `NetworkError` for error handling.
- **AppLogger** — uses `LoggerProtocol` for request/response logging.
