# AuthFeature

`AuthFeatureInterface`'in concrete implementasyonu. VIP-S (Clean Swift for SwiftUI) mimarisi ile Login sahnesini sunar; auth provider olarak Firebase Auth kullanır.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar:
  - `AuthFeatureInterface` (sözleşme)
  - `AppCore` (hata haritalama)
  - `AppLogger` (logging)
  - `AppStorage` (token saklama)
  - `AppNetwork` (REST `AuthEndpoint` için — Firebase service ana yol)
  - `DesignSystem` (UI bileşenleri)
  - `firebase-ios-sdk` → `FirebaseAuth` (yalnızca paket içinde, AppShell'e sızmaz)

## Public API

### Composition

| Tip | Tür | Amaç |
|---|---|---|
| `AuthFeatureAssembly` | final class | `AuthFeatureInterface`'i implement eder. `init(logger:tokenStorage:delegate:)`. `makeLoginView() -> AnyView`, `makeLoginScene() -> LoginView` (concrete, preview/test için), `signOut()`, `isAuthenticated` |

### Domain

| Tip | Tür | Amaç |
|---|---|---|
| `AuthRepositoryProtocol` | protocol | `login(email:password:)`, `logout()` |
| `AuthEntity` | struct | Login sonucu domain modeli |
| `LoginUseCaseProtocol` / `LoginUseCase` | protocol + final class | Login akışını yürütür, token'ı `TokenStorageProtocol` üzerine yazar |

### Presentation (Login)

| Tip | Tür | Amaç |
|---|---|---|
| `LoginView` | struct (`View`) | Login ekranı |
| `LoginInteractorProtocol` / `LoginInteractor` | protocol + final class | VIP-S interactor |
| `LoginPresenter` | final class | Response → ViewState dönüşümü |
| `Login` | enum (namespace) | `Request` / `Response` / `ViewState` modelleri |

## Kullanım

```swift
import AuthFeature
import AuthFeatureInterface
import AppLogger
import AppStorage

let logger: LoggerProtocol = AppLogger(category: "auth")
let storage: TokenStorageProtocol = KeychainTokenStorage()

let auth: AuthFeatureInterface = AuthFeatureAssembly(
    logger: logger,
    tokenStorage: storage,
    delegate: appCoordinator   // AuthFeatureDelegate
)

let loginView = auth.makeLoginView()

// Logout
try await auth.signOut()
```

## Test edilebilirlik

- `LoginUseCase` mock `AuthRepositoryProtocol` + `MockTokenStorage` ile birim testlenir.
- `LoginPresenter` saf input/output → state dönüşümü; tek başına test edilir.
- `LoginInteractor` `output: LoginInteractorOutput` mock'u ile event akışı testlenir.
- Concrete `LoginView` `makeLoginScene()` üzerinden snapshot testlerine açılabilir (`AnyView` engeli yok).

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `AuthFeature-<semver>`).

## Notlar

- **Firebase coupling Service katmanına gizlenmiştir** (`Data/FirebaseAuthService.swift`). `AuthFeatureAssembly` artık `import FirebaseAuth` içermez. Auth provider'ı değiştirmek isterseniz tek dokunmanız gereken nokta `AuthServiceProtocol` implementasyonudur.
- `AuthEndpoint` REST tabanlı bir alternatif uç olarak durur ama production'da `FirebaseAuthService` kullanılır.
