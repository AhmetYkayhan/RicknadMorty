# SettingsFeatureInterface

Settings feature'ı için public sözleşme. Concrete implementation **içermez**.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (saf SwiftUI + Foundation)

## Public API

| Tip | Tür | Amaç |
|---|---|---|
| `SettingsFeatureInterface` | protocol | `makeSettingsView() -> AnyView` |
| `SettingsRoute` | enum | Settings navigation çıktıları: `about`, `privacy`, `logout` |
| `SettingsFeatureDelegate` | protocol | `settingsFeature(didSelect:)` event hookı |

## Kullanım

```swift
import SettingsFeatureInterface

let view: AnyView = settingsFeature.makeSettingsView()
```

## Test edilebilirlik

```swift
final class StubSettingsFeature: SettingsFeatureInterface {
    @MainActor func makeSettingsView() -> AnyView { AnyView(EmptyView()) }
}
```

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `SettingsFeatureInterface-<semver>`).
