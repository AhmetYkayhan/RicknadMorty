# DesignSystem

Design token'ları (renk, spacing, tipografi) ve yeniden kullanılabilir SwiftUI bileşenleri.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılık: yok (saf SwiftUI)

## Public API

### Tokens

| Tip | Tür | Amaç |
|---|---|---|
| `AppColors` | enum (namespace) | Marka renk paleti — `primary`, `secondary`, `background`, `error`, vb. |
| `AppSpacing` | enum (namespace) | 4-pt spacing skalası — `xs`, `sm`, `md`, `lg`, `xl` |
| `AppTypography` | enum (namespace) | Tipografik stiller — `largeTitle`, `headline`, `body`, `caption` |

### Components

| Tip | Tür | Amaç |
|---|---|---|
| `AppButton` | struct (`View`) | Stilize buton (`primary` / `secondary` / `destructive`) + isLoading state |
| `AppButton.Style` | enum | Buton stil seçenekleri |
| `AppTextField` | struct (`View`) | Stilize text field (label + placeholder + secure mode) |
| `LoadingView` | struct (`View`) | Spinner + isteğe bağlı mesaj |
| `ErrorView` | struct (`View`) | Hata mesajı + retry butonu |

## Kullanım

```swift
import SwiftUI
import DesignSystem

struct LoginView: View {
    @State private var email = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            AppTextField(title: "Email", text: $email)
            AppButton(title: "Sign In", isLoading: isLoading) {
                isLoading.toggle()
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.background)
    }
}
```

## Test edilebilirlik

SwiftUI bileşenleri snapshot testlerine uygundur. Token'lar değer (enum + static let) — direkt testlenir.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `DesignSystem-<semver>`).
