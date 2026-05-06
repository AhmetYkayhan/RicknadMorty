# ProfileFeatureInterface

Profile feature'ı için public sözleşme. Concrete implementation **içermez**.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (saf SwiftUI + Foundation)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `ProfileFeatureInterface` | protocol | `makeProfileView() -> AnyView` |
| `ProfileRoute` | enum | Profile navigation çıktıları: `editProfile`, `logout` |
| `ProfileFeatureDelegate` | protocol | `profileFeature(didSelect:)` event hookı |

## Kullanım

```swift
import ProfileFeatureInterface

let view: AnyView = profileFeature.makeProfileView()
```

## Test edilebilirlik

```swift
final class StubProfileFeature: ProfileFeatureInterface {
    @MainActor func makeProfileView() -> AnyView { AnyView(EmptyView()) }
}
```

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `ProfileFeatureInterface-<semver>`).
