# Xcode-Claude'a Yapıştırılacak Prompt — Faz 5.1 (AuthFeature)

Aşağıdaki metnin tamamını seç, kopyala ve Xcode'daki Claude'a tek mesaj olarak yapıştır.

---

## (BURADAN İTİBAREN KOPYALA)

Faz 4 tamamlandı: 4 FeatureInterface paketi workspace'te. Şimdi **Faz 5.1: AuthFeature'ı SPM paketine çıkar VE Login sahnesini Clean Swift VIP-S disiplinine çevir.**

### Hedef mimari (VIP-S = Clean Swift'in SwiftUI adaptasyonu)

Klasik VIP'in SwiftUI karşılıkları:

| Klasik | SwiftUI VIP-S |
|---|---|
| ViewController | `View` (struct) |
| Interactor | `Interactor` (@MainActor class) — iş mantığı |
| Presenter | `Presenter` (@MainActor + @Observable) — Response → ViewState formatlama |
| Worker | UseCase / Repository / Service (zaten var) |
| Router | SwiftUI'da Coordinator delegate üzerinden — çoğu zaman ayrı Router gerekmez |
| Models | `Scene.Request` / `Scene.Response` / `Scene.ViewState` |

Akış: **View** kullanıcı niyetini çağırır → **Interactor** UseCase'i çalıştırır → sonucu Response olarak **Presenter**'a verir → Presenter ViewState'i günceller → **View** yeni ViewState'i render eder.

### Hedef paket yapısı

```
Packages/Features/AuthFeature/
├── Package.swift
├── README.md
├── Sources/
│   └── AuthFeature/
│       ├── Domain/
│       │   ├── AuthEntity.swift
│       │   ├── AuthRepositoryProtocol.swift
│       │   └── LoginUseCase.swift
│       ├── Data/
│       │   ├── AuthEndpoint.swift
│       │   ├── AuthMapper.swift
│       │   ├── AuthRepository.swift
│       │   ├── AuthService.swift
│       │   ├── FirebaseAuthService.swift
│       │   ├── LoginRequestDTO.swift
│       │   └── LoginResponseDTO.swift
│       ├── Scenes/
│       │   └── Login/
│       │       ├── LoginModels.swift          ← YENİ (Request/Response/ViewState)
│       │       ├── LoginInteractor.swift      ← YENİ (eski ViewModel'ın iş mantığı kısmı)
│       │       ├── LoginPresenter.swift       ← YENİ (eski ViewModel'ın state formatlama kısmı)
│       │       └── LoginView.swift            ← YENİDEN YAZILACAK
│       └── Assembly/
│           └── AuthFeatureAssembly.swift      ← VIP-S wiring'e güncellenecek
└── Tests/
    └── AuthFeatureTests/
        ├── LoginInteractorTests.swift
        ├── LoginPresenterTests.swift
        └── LoginUseCaseTests.swift
```

> Eski `LoginViewModel.swift` ve `LoginViewState.swift` dosyaları **silinecek** — yerlerine Interactor + Presenter + Models geliyor.

### Sabit kararlar

- iOS 17, Swift 5.9, Swift Testing
- Tüm dış kullanılacak tipler `public`
- `AuthFeatureAssembly` sınıfı sadece **internal** — App `AuthFeatureInterface` üzerinden ulaşır
- `AuthFeatureInterface.makeLoginView()` `AnyView` döndürmeye devam ediyor (Faz 8'de cilalanır)

Çalışma kuralı: aşağıdaki adımları sırayla yap. Her adımdan sonra kısa özet ver. Adım 5 (VIP-S refactor) sonunda mutlaka build aldığını ve uygulamanın çalıştığını doğrula.

---

### Adım 1 — AuthFeature paketini oluştur

`Packages/Features/AuthFeature/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AuthFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AuthFeature", targets: ["AuthFeature"])
    ],
    dependencies: [
        .package(path: "../../FeatureInterfaces/AuthFeatureInterface"),
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/AppLogger"),
        .package(path: "../../Core/AppStorage"),
        .package(path: "../../Core/AppNetwork"),
        .package(path: "../../Core/DesignSystem"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.0.0")
    ],
    targets: [
        .target(
            name: "AuthFeature",
            dependencies: [
                "AuthFeatureInterface",
                "AppCore",
                "AppLogger",
                "AppStorage",
                "AppNetwork",
                "DesignSystem",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Sources/AuthFeature"
        ),
        .testTarget(
            name: "AuthFeatureTests",
            dependencies: ["AuthFeature"],
            path: "Tests/AuthFeatureTests"
        )
    ]
)
```

> **Firebase versiyonu:** Mevcut app target'ında bağlı olan firebase-ios-sdk versiyonunu kontrol et ve `from:` değerini eşle. Versiyon farkı SPM çakışmasına yol açar.

`Packages/Features/AuthFeature/README.md`: kısa açıklama yaz (Firebase Auth ile login, AuthFeatureInterface implementasyonu).

---

### Adım 2 — Domain ve Data dosyalarını taşı (refactor YOK)

Aşağıdaki dosyaları olduğu gibi yeni paketin altına taşı, içeriklerinde **sadece public/internal erişim kontrolü güncelle**:

| Eski | Yeni |
|---|---|
| `RicknadMorty/AuthFeature/Domain/AuthEntity.swift` | `Sources/AuthFeature/Domain/AuthEntity.swift` |
| `RicknadMorty/AuthFeature/Domain/AuthRepositoryProtocol.swift` | `Sources/AuthFeature/Domain/AuthRepositoryProtocol.swift` |
| `RicknadMorty/AuthFeature/Domain/LoginUseCase.swift` | `Sources/AuthFeature/Domain/LoginUseCase.swift` |
| `RicknadMorty/AuthFeature/Data/LoginRequestDTO.swift` | `Sources/AuthFeature/Data/LoginRequestDTO.swift` |
| `RicknadMorty/AuthFeature/Data/LoginResponseDTO.swift` | `Sources/AuthFeature/Data/LoginResponseDTO.swift` |
| `RicknadMorty/AuthFeature/Data/AuthMapper.swift` | `Sources/AuthFeature/Data/AuthMapper.swift` |
| `RicknadMorty/AuthFeature/Data/AuthEndpoint.swift` | `Sources/AuthFeature/Data/AuthEndpoint.swift` |
| `RicknadMorty/AuthFeature/Data/AuthRepository.swift` | `Sources/AuthFeature/Data/AuthRepository.swift` |
| `RicknadMorty/AuthFeature/Data/AuthService.swift` | `Sources/AuthFeature/Data/AuthService.swift` |
| `RicknadMorty/AuthFeature/Data/FirebaseAuthService.swift` | `Sources/AuthFeature/Data/FirebaseAuthService.swift` |

Erişim kuralı:
- `LoginUseCaseProtocol`, `LoginUseCase` → `public` (Assembly içinden kullanılıyor; ayrıca dış paket testten erişebilir)
- `AuthRepositoryProtocol`, `AuthEntity`, `AuthServiceProtocol`, `FirebaseAuthService`, `AuthRepository`, `AuthService` → **internal** (paket dışına sızmasın, sadece Assembly üzerinden erişim)
- DTO'lar, Mapper, Endpoint → **internal**

Eğer `MockAuthService` veya benzeri bir mock varsa Tests target'ı için `internal` yeter; `@testable import` çalışır.

---

### Adım 3 — Eski Presentation dosyalarını SİL

Şu dosyaları sil:

- `RicknadMorty/AuthFeature/Presentation/LoginView.swift`
- `RicknadMorty/AuthFeature/Presentation/LoginViewModel.swift`
- `RicknadMorty/AuthFeature/Presentation/LoginViewState.swift`

Ve eski `RicknadMorty/AuthFeature/AuthFeatureAssembly.swift`'i de **sil** — yenisini paket içinde yazacağız.

---

### Adım 4 — Yeni Login scene dosyalarını yaz (VIP-S)

#### 4.a `Sources/AuthFeature/Scenes/Login/LoginModels.swift`

```swift
import Foundation
import AppCore

// MARK: - Login Scene Models

public enum Login {

    // MARK: Request — View'dan Interactor'a
    public enum Request {
        case updateEmail(String)
        case updatePassword(String)
        case submit
        case forgotPassword
    }

    // MARK: Response — Interactor'dan Presenter'a
    public enum Response {
        case formUpdated(email: String, password: String)
        case loadingStarted
        case loginSucceeded
        case loginFailed(error: any AppErrorProtocol)
    }

    // MARK: ViewState — Presenter'dan View'a
    public struct ViewState: ViewStateProtocol {
        public var email: String = ""
        public var password: String = ""
        public var isLoading: Bool = false
        public var errorMessage: String? = nil
        public var isLoginSuccessful: Bool = false

        public init() {}

        public var isFormValid: Bool {
            !email.trimmingCharacters(in: .whitespaces).isEmpty &&
            password.count >= 6
        }

        public var emailError: String? {
            guard !email.isEmpty else { return nil }
            let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
            return email.wholeMatch(of: emailRegex) == nil ? "Invalid email format" : nil
        }

        public var passwordError: String? {
            guard !password.isEmpty else { return nil }
            return password.count < 6 ? "Password must be at least 6 characters" : nil
        }
    }
}
```

#### 4.b `Sources/AuthFeature/Scenes/Login/LoginPresenter.swift`

```swift
import Foundation
import Observation
import AppCore

// MARK: - Login Presenter

@MainActor
@Observable
public final class LoginPresenter {
    public private(set) var viewState = Login.ViewState()

    public init() {}

    public func present(_ response: Login.Response) {
        switch response {
        case let .formUpdated(email, password):
            viewState.email = email
            viewState.password = password
            viewState.errorMessage = nil

        case .loadingStarted:
            viewState.isLoading = true
            viewState.errorMessage = nil

        case .loginSucceeded:
            viewState.isLoading = false
            viewState.isLoginSuccessful = true

        case let .loginFailed(error):
            viewState.isLoading = false
            viewState.errorMessage = error.userMessage
        }
    }
}
```

#### 4.c `Sources/AuthFeature/Scenes/Login/LoginInteractor.swift`

```swift
import Foundation
import AppCore
import AuthFeatureInterface

// MARK: - Login Interactor

@MainActor
public final class LoginInteractor {
    private let useCase: LoginUseCaseProtocol
    private let presenter: LoginPresenter
    private weak var delegate: AuthFeatureDelegate?

    private var email: String = ""
    private var password: String = ""

    public init(useCase: LoginUseCaseProtocol,
                presenter: LoginPresenter,
                delegate: AuthFeatureDelegate?) {
        self.useCase = useCase
        self.presenter = presenter
        self.delegate = delegate
    }

    public func handle(_ request: Login.Request) {
        switch request {
        case let .updateEmail(value):
            email = value
            presenter.present(.formUpdated(email: email, password: password))

        case let .updatePassword(value):
            password = value
            presenter.present(.formUpdated(email: email, password: password))

        case .submit:
            submit()

        case .forgotPassword:
            delegate?.authFeature(didComplete: .forgotPassword)
        }
    }

    private func submit() {
        // Form validity'yi presenter ViewState'inden değil interactor'dan kontrol et
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else { return }

        presenter.present(.loadingStarted)

        Task {
            do {
                _ = try await useCase.execute(email: email, password: password)
                presenter.present(.loginSucceeded)
                delegate?.authFeature(didComplete: .loginCompleted)
            } catch let error as any AppErrorProtocol {
                presenter.present(.loginFailed(error: error))
            } catch {
                // Tipik olmayan hatalar için fallback
                presenter.present(.loginFailed(error: WrappedError(underlying: error)))
            }
        }
    }
}

// MARK: - Generic AppError fallback (sadece Auth Interactor'a özel)
private struct WrappedError: AppErrorProtocol {
    let underlying: Error
    var userMessage: String { underlying.localizedDescription }
}
```

> `WrappedError` quick&dirty bir fallback. Eğer `AppCore` zaten generic bir wrapper sunuyorsa onu kullan; yoksa şimdilik bu private kalsın, Faz 8'de düzeltilir.

#### 4.d `Sources/AuthFeature/Scenes/Login/LoginView.swift`

```swift
import SwiftUI
import DesignSystem

// MARK: - Login View

struct LoginView: View {
    let interactor: LoginInteractor
    @Bindable var presenter: LoginPresenter

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                headerSection
                formSection
                loginButton
                forgotPasswordButton
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.background)
    }

    private var headerSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(AppColors.accent)
            Text("Welcome Back")
                .font(AppTypography.largeTitle).fontWeight(.bold)
            Text("Sign in to continue")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)
        }
        .padding(.top, AppSpacing.xxl)
    }

    private var formSection: some View {
        VStack(spacing: AppSpacing.md) {
            AppTextField(
                placeholder: "Email",
                text: Binding(
                    get: { presenter.viewState.email },
                    set: { interactor.handle(.updateEmail($0)) }
                ),
                errorMessage: presenter.viewState.emailError
            )
            .keyboardType(.emailAddress)

            AppTextField(
                placeholder: "Password",
                text: Binding(
                    get: { presenter.viewState.password },
                    set: { interactor.handle(.updatePassword($0)) }
                ),
                isSecure: true,
                errorMessage: presenter.viewState.passwordError
            )
        }
    }

    private var loginButton: some View {
        VStack(spacing: AppSpacing.xs) {
            AppButton(
                title: "Sign In",
                isLoading: presenter.viewState.isLoading
            ) {
                interactor.handle(.submit)
            }

            if let error = presenter.viewState.errorMessage {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.destructive)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var forgotPasswordButton: some View {
        Button {
            interactor.handle(.forgotPassword)
        } label: {
            Text("Forgot Password?")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.accent)
        }
    }
}
```

> **`#Preview`'i şimdilik EKLEME** — Mock'lar paket içinde mi yoksa Tests target'ta mı durmalı kararını Faz 5 sonunda alacağız. Build'in temiz çıkmasına odaklan.

---

### Adım 5 — `Sources/AuthFeature/Assembly/AuthFeatureAssembly.swift`

Eski Assembly artık paket içinde, VIP-S wiring yapıyor:

```swift
import SwiftUI
import AppCore
import AppLogger
import AppStorage
import AppNetwork
import AuthFeatureInterface

// MARK: - Auth Feature Assembly

public final class AuthFeatureAssembly: AuthFeatureInterface {

    private let logger: LoggerProtocol
    private let tokenStorage: TokenStorageProtocol
    private weak var delegate: AuthFeatureDelegate?

    public init(logger: LoggerProtocol,
                tokenStorage: TokenStorageProtocol,
                delegate: AuthFeatureDelegate?) {
        self.logger = logger
        self.tokenStorage = tokenStorage
        self.delegate = delegate
    }

    @MainActor
    public func makeLoginView() -> AnyView {
        // Worker chain (internal'lar)
        let service: AuthServiceProtocol = FirebaseAuthService()
        let repository: AuthRepositoryProtocol = AuthRepository(service: service, logger: logger)
        let useCase: LoginUseCaseProtocol = LoginUseCase(
            repository: repository,
            tokenStorage: tokenStorage
        )

        // VIP-S
        let presenter = LoginPresenter()
        let interactor = LoginInteractor(
            useCase: useCase,
            presenter: presenter,
            delegate: delegate
        )
        let view = LoginView(interactor: interactor, presenter: presenter)

        return AnyView(view)
    }

    public var isAuthenticated: Bool {
        get async { tokenStorage.hasToken }
    }
}
```

> Dikkat: Eski Assembly app target'taki `AppDependencyContainer`'dan `loginUseCase` ve `tokenStorage` enjekte alıyordu. Yeni Assembly artık **kendi internal worker chain'ini kuruyor**, sadece `logger` ve `tokenStorage` dışarıdan geliyor. Bu, AuthFeature'ın self-contained reusable olmasını sağlar.

---

### Adım 6 — Eski klasörleri sil

`RicknadMorty/AuthFeature/` altındaki tüm dosya ve klasörler artık pakete taşındı veya silindi. Klasörü tamamen kaldır.

---

### Adım 7 — Workspace + bağlama (UI talimatları ver)

Bana sırayla şu UI adımlarını ver:
1. `Packages/Features/AuthFeature` local paketini workspace'e nasıl eklerim?
2. App target'ta artık **doğrudan FirebaseAuth bağımlılığını kaldırmalı mıyım** (paket içine taşıdığımız için)? Eğer evet, nasıl?
   - **Cevabını bilmiyorsan**: "Faz 6'ya bırakalım" diyebilirsin. Şimdilik FirebaseAuth duplicate olarak hem app target hem AuthFeature paketinde kalabilir, derlemede sorun olmamalı.
3. App target'a `AuthFeature` library'sini nasıl bağlarım? (Sadece `AuthFeatureInterface` yeterli olabilir mi? — App, container'da `AuthFeatureAssembly` somut tipini new'liyorsa `AuthFeature` import'una ihtiyaç var.)

---

### Adım 8 — `AppDependencyContainer`'ı güncelle

`RicknadMorty/AppShell/AppDependencyContainer.swift` içindeki `makeAuthFeature` metodunu sadeleştir:

```swift
import AuthFeatureInterface
import AuthFeature

// ...

func makeAuthFeature(delegate: AuthFeatureDelegate?) -> AuthFeatureInterface {
    AuthFeatureAssembly(
        logger: logger,
        tokenStorage: tokenStorage,
        delegate: delegate
    )
}
```

Eski içerideki `service`, `repository`, `loginUseCase` üretimleri silindi — onları artık AuthFeatureAssembly kendi içinde yapıyor.

App target'tan eski `AuthRepositoryProtocol`, `LoginUseCaseProtocol`, `AuthService*`, `FirebaseAuthService`, `AuthRepository`, `LoginUseCase` referansları gitmeli — sadece `AuthFeatureInterface.AuthFeatureDelegate` ve `AuthFeature.AuthFeatureAssembly` kalır.

---

### Adım 9 — Test ekle (Swift Testing)

`Tests/AuthFeatureTests/LoginPresenterTests.swift`:

```swift
import Testing
@testable import AuthFeature
@testable import AppCore

@MainActor
@Suite("LoginPresenter")
struct LoginPresenterTests {

    @Test("loadingStarted sets isLoading and clears error")
    func loadingStarted() {
        let presenter = LoginPresenter()
        presenter.viewState.errorMessage = "old error"

        presenter.present(.loadingStarted)

        #expect(presenter.viewState.isLoading == true)
        #expect(presenter.viewState.errorMessage == nil)
    }

    @Test("loginSucceeded clears loading and sets success flag")
    func loginSucceeded() {
        let presenter = LoginPresenter()
        presenter.present(.loadingStarted)

        presenter.present(.loginSucceeded)

        #expect(presenter.viewState.isLoading == false)
        #expect(presenter.viewState.isLoginSuccessful == true)
    }

    @Test("formUpdated mirrors values into viewState")
    func formUpdated() {
        let presenter = LoginPresenter()
        presenter.present(.formUpdated(email: "a@b.com", password: "secret"))

        #expect(presenter.viewState.email == "a@b.com")
        #expect(presenter.viewState.password == "secret")
        #expect(presenter.viewState.errorMessage == nil)
    }
}
```

`Tests/AuthFeatureTests/LoginInteractorTests.swift`:

```swift
import Testing
@testable import AuthFeature
@testable import AuthFeatureInterface
@testable import AppCore

@MainActor
@Suite("LoginInteractor")
struct LoginInteractorTests {

    final class StubUseCase: LoginUseCaseProtocol {
        var capturedEmail: String?
        var capturedPassword: String?
        var result: Result<AuthEntity, Error> = .failure(StubError.notSet)

        func execute(email: String, password: String) async throws -> AuthEntity {
            capturedEmail = email
            capturedPassword = password
            return try result.get()
        }
    }

    final class SpyDelegate: AuthFeatureDelegate {
        var capturedRoute: AuthRoute?
        func authFeature(didComplete route: AuthRoute) {
            capturedRoute = route
        }
    }

    enum StubError: Error { case notSet }

    @Test("submit with empty email is no-op")
    func submitEmpty() async {
        let useCase = StubUseCase()
        let presenter = LoginPresenter()
        let delegate = SpyDelegate()
        let sut = LoginInteractor(useCase: useCase, presenter: presenter, delegate: delegate)

        sut.handle(.submit)

        #expect(useCase.capturedEmail == nil)
        #expect(presenter.viewState.isLoading == false)
    }

    @Test("forgotPassword routes via delegate")
    func forgot() async {
        let useCase = StubUseCase()
        let presenter = LoginPresenter()
        let delegate = SpyDelegate()
        let sut = LoginInteractor(useCase: useCase, presenter: presenter, delegate: delegate)

        sut.handle(.forgotPassword)

        #expect(delegate.capturedRoute == .forgotPassword)
    }
}
```

> Eğer `AuthEntity`'nin public init'i yoksa StubUseCase'in result tipini değiştirmen gerekebilir. Test build'i kırılırsa minimal düzeltmeyi yap, ana hedef testlerin çalışması.

---

### Adım 10 — Doğrulama

- [ ] App build alıyor.
- [ ] `swift test --package-path Packages/Features/AuthFeature` yeşil.
- [ ] App'te login akışı eskisi gibi çalışıyor:
  - Email/password gir → form validation → Sign In tıkla → Firebase ile login → Home'a geç
  - Yanlış password → kırmızı hata mesajı
  - Forgot Password → AppCoordinator delegate çağrılıyor (loglarda görünür)

Önerilen commit:

```
feat(spm): extract AuthFeature package and refactor Login to VIP-S

- Move AuthFeature into Packages/Features/AuthFeature
- Migrate FirebaseAuth dependency into the feature package
- Refactor Login MVVM (ViewModel + ViewState) to VIP-S:
  Login.Request / Login.Response / Login.ViewState
  LoginInteractor (business) + LoginPresenter (@Observable formatting)
  LoginView consumes interactor + presenter
- Internal worker chain wired in AuthFeatureAssembly
- AppDependencyContainer simplified to factory call only
- Add LoginPresenter / LoginInteractor unit tests (Swift Testing)
```

Bittiğinde toplu özet ver: yapılan dosya değişiklikleri, build durumu, test sonuçları, app davranışında bir regresyon var mı.

## (BURAYA KADAR KOPYALA)

---

## Sonrası

Faz 5.1 bittiğinde "Faz 5.1 tamam" yaz. Sonraki **Faz 5.2: HomeFeature**'a geçeceğiz — aynı VIP-S şablonu ama Home'un sahneleri (HomeList + CharacterDetail) için.

Sorun çıkarsa hata mesajını + hangi adımda (1 — 10) olduğunu yapıştır. **Özellikle Firebase versiyon çakışması**, `@Bindable` davranışı, ya da `AnyView` ile import sırası problemleri çıkarsa hemen bana yaz, paslaşalım.
