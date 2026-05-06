# AppStorage

Token persistence soyutlaması: Keychain'e yazan default implementasyon ve preview/test için in-memory mock.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar: `AppCore` (hata tipleri için)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `TokenStorageProtocol` | protocol | `saveToken(_:)`, `getToken()`, `deleteToken()`, `hasToken` sözleşmesi |
| `KeychainTokenStorage` | final class | Apple Keychain (`kSecClassGenericPassword`) destekli production implementasyon. `service` ve `account` parametreleri ile çoklu token saklayabilir |
| `MockTokenStorage` | final class | In-memory; testler ve SwiftUI preview'ları için |

## Kullanım

```swift
import AppStorage

let storage: TokenStorageProtocol = KeychainTokenStorage(
    service: "com.example.auth",
    account: "accessToken"
)

try storage.saveToken("eyJhbGciOi...")
if storage.hasToken {
    let token = try storage.getToken()
}
try storage.deleteToken()
```

## Test edilebilirlik

```swift
let storage = MockTokenStorage(token: "preset")
#expect(storage.hasToken == true)
try storage.deleteToken()
#expect(storage.hasToken == false)
```

`KeychainTokenStorage`'ın gerçek Keychain'e yazdığını unutmayın — testlerde **`MockTokenStorage`** kullanın.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AppStorage-<semver>`).
