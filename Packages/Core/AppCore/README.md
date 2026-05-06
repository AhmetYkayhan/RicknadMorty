# AppCore

Uygulamadan bağımsız çekirdek tipler: hata hiyerarşisi, generic loadable state ve view state sözleşmesi.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (fully standalone)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `AppErrorProtocol` | protocol | Tüm uygulama hatalarının uyduğu sözleşme (`code`, `userMessage`, `LocalizedError`) |
| `AppError` | enum | `network` / `storage` / `auth` / `unknown` üst hata türleri için sumtype |
| `NetworkError` | enum | `invalidURL`, `noData`, `decodingFailed`, `unauthorized`, `serverError(statusCode:)`, `timeout`, `noConnection`, `unknown(String)` |
| `StorageError` | enum | `saveFailed`, `readFailed`, `deleteFailed`, `notFound` |
| `AuthError` | enum | `invalidCredentials`, `tokenExpired`, `accountLocked`, `registrationFailed` |
| `GenericAppError` | struct | `AppErrorProtocol`'a uymayan herhangi bir Swift `Error`'u sözleşmeye uyumlu hale getiren adapter. Presenter'lar tek tip hata kontratı görür |
| `LoadableState<T: Equatable>` | enum | Generic veri yükleme durumu: `idle` / `loading` / `loaded(T)` / `failed(String)`. `isLoading`, `value`, `errorMessage` türetilmiş alanları sunar |
| `ViewStateProtocol` | protocol | View modellerinin `isLoading` + `errorMessage` sözleşmesi |

## Kullanım

```swift
import AppCore

func login() async throws {
    do {
        try await service.signIn()
    } catch {
        throw AppError.auth(.invalidCredentials)
    }
}

@MainActor
final class HomeListPresenter {
    var state: LoadableState<[Character]> = .idle
}
```

## Test edilebilirlik

Tüm tipler değer/`enum` veya saf protokol — mock'a gerek yoktur. Test'lerde direkt instantiate edilir.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AppCore-<semver>`).
