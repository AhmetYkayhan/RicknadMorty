# AppStorage

Token persistence abstraction for the RicknadMorty app.

Provides `TokenStorageProtocol` with a Keychain-backed implementation (`KeychainTokenStorage`) and a lightweight in-memory mock (`MockTokenStorage`) for previews and tests.

## Dependencies

- **AppCore** — uses `StorageError` for error handling.
