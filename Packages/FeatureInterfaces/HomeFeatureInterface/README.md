# HomeFeatureInterface

Home feature'ı için public sözleşme. Concrete implementation **içermez**.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (saf SwiftUI + Foundation)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `HomeFeatureInterface` | protocol | `makeHomeView() -> AnyView` (root scene factory) |
| `HomeRoute` | enum | Home navigation çıktıları: `characterDetail(id:)`, `settings`, `profile` |
| `HomeFeatureDelegate` | protocol | Coordinator'ın home navigation'ını dinlediği sözleşme: `homeFeature(didSelect:)` |

## Kullanım

```swift
import HomeFeatureInterface

@MainActor
final class AppCoordinator: HomeFeatureDelegate {
    let homeFeature: HomeFeatureInterface

    func showHome() -> AnyView { homeFeature.makeHomeView() }

    func homeFeature(didSelect route: HomeRoute) {
        switch route {
        case .characterDetail(let id): /* push */
        case .settings, .profile: /* tab switch */
        }
    }
}
```

## Test edilebilirlik

```swift
final class StubHomeFeature: HomeFeatureInterface {
    @MainActor func makeHomeView() -> AnyView { AnyView(EmptyView()) }
}
```

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `HomeFeatureInterface-<semver>`).
