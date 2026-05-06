# AuthFeatureInterface

Auth feature'ı için public sözleşme. Concrete implementation **içermez**; composition root ve diğer feature'lar bu paketi import eder, somut `AuthFeature`'a ise yalnızca App target bağlanır.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (saf SwiftUI + Foundation)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `AuthFeatureInterface` | protocol | Auth feature sözleşmesi: `makeLoginView() -> AnyView`, `isAuthenticated: Bool { get async }`, `signOut() async throws` |
| `AuthRoute` | enum | Auth navigation çıktıları: `loginCompleted`, `forgotPassword`, `register` |
| `AuthFeatureDelegate` | protocol | App coordinator'ın auth event'lerini dinleyeceği sözleşme: `authFeature(didComplete:)` |

## Kullanım

```swift
import AuthFeatureInterface

@MainActor
final class AppCoordinator: AuthFeatureDelegate {
    let authFeature: AuthFeatureInterface

    func showLogin() -> AnyView { authFeature.makeLoginView() }

    func authFeature(didComplete route: AuthRoute) {
        if case .loginCompleted = route { /* navigate */ }
    }
}
```

## Test edilebilirlik

`AuthFeatureInterface`'a uyan basit bir mock yazıp delegate akışlarını test edebilirsiniz:

```swift
final class StubAuthFeature: AuthFeatureInterface {
    @MainActor func makeLoginView() -> AnyView { AnyView(EmptyView()) }
    var isAuthenticated: Bool { get async { false } }
    func signOut() async throws { }
}
```

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AuthFeatureInterface-<semver>`).

> **Breaking change politikası:** Bu pakete eklenen her yeni gereksinim **MAJOR** bump gerektirir (tüm implementation tarafları kırılır).
