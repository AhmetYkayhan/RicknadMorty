# Xcode-Claude'a Yapıştırılacak Prompt — Faz 3

Aşağıdaki metnin tamamını seç, kopyala ve Xcode'daki Claude'a tek mesaj olarak yapıştır.

---

## (BURADAN İTİBAREN KOPYALA)

Faz 2 tamamlandı: `Packages/Core/AppCore` paketi hazır, app target'a bağlı, `AppError` / `LoadableState` / `ViewState` orada. Şimdi **Faz 3: kalan Core paketlerini çıkarıyoruz** — sırayla `AppLogger`, `AppStorage`, `AppNetwork`, `DesignSystem`.

Sabit kararlar (her paket için aynı):
- iOS 17, Swift 5.9, strict concurrency yok, Swift Testing
- Paket yolu: `Packages/Core/<PaketAdı>/`
- Yapı: `Sources/<PaketAdı>/`, `Tests/<PaketAdı>Tests/`
- Tüm dış kullanılacak tipler `public`, init'ler `public init`

Çalışma kuralı: **her alt paketin sonunda DUR, bana özetle, ben "devam" dediğimde sonrakine geç.** Bir alt paket bittiğinde mutlaka build alındığını ve smoke testin yeşil olduğunu doğrula.

---

### Adım 3.1 — AppLogger paketi (bağımsız)

#### 3.1.a Paketi oluştur

`Packages/Core/AppLogger/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppLogger",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppLogger", targets: ["AppLogger"])
    ],
    targets: [
        .target(name: "AppLogger", path: "Sources/AppLogger"),
        .testTarget(
            name: "AppLoggerTests",
            dependencies: ["AppLogger"],
            path: "Tests/AppLoggerTests"
        )
    ]
)
```

`Packages/Core/AppLogger/README.md`: kısa bir açıklama yaz (OSLog tabanlı logger, bağımsız).

#### 3.1.b Dosya taşı

`RicknadMorty/CoreLogger/Logger.swift` → `Packages/Core/AppLogger/Sources/AppLogger/Logger.swift`. Tüm tipleri `public` yap (`LoggerProtocol`, `AppLogger`, init'ler, default-arg'lı extension metodları).

> Not: `AppLogger` hem **paketin adı** hem de dosyadaki **sınıfın adı**. Bu Swift'te sorun değil — modül adı tip adıyla aynı olabilir, kullanım `AppLogger.AppLogger(...)` gerekmez. Ancak `subsystem` parametresi `Bundle.main.bundleIdentifier` kullandığı için paket testinde bundle olmayabilir; default'u `"com.ricknadmorty"` olarak güvende tut.

#### 3.1.c Klasörü temizle

Boş kalan `RicknadMorty/CoreLogger/` klasörünü sil.

#### 3.1.d Workspace'e ekle ve bağla (sen bana UI talimatı ver)

Bana sırayla şu UI adımlarını tek tek söyle:
1. Workspace'e `Packages/Core/AppLogger` local paketini nasıl eklerim?
2. App target'a `AppLogger` library'sini nasıl bağlarım?

#### 3.1.e Import'ları düzelt

App target'taki dosyalarda `LoggerProtocol`, `AppLogger` referansı veren her dosyaya `import AppLogger` ekle. **AYRICA** `Packages/Core/AppCore` paketi logger kullanıyorsa orada da düzeltme gerekebilir — kontrol et. Eğer AppCore artık AppLogger'a ihtiyaç duyarsa AppCore'un Package.swift'ine `dependencies` olarak ekle.

> Şu anda AppCore'da logger kullanımı olmamalı (sadece error/state tipleri vardı). Eğer öyleyse iki paket bağımsız kalır, harika.

#### 3.1.f Smoke test

`Tests/AppLoggerTests/AppLoggerTests.swift`:

```swift
import Testing
@testable import AppLogger

@Suite("AppLogger smoke")
struct AppLoggerSmokeTests {
    @Test("AppLogger initializes")
    func initializes() {
        let logger: LoggerProtocol = AppLogger(category: "test")
        logger.info("hello")
        #expect(Bool(true))
    }
}
```

#### 3.1.g Doğrulama

- [ ] App build alıyor.
- [ ] Paket testleri yeşil.
- [ ] Firebase login akışı ve Home listesi çalışıyor.

Sonra DUR ve bana özet ver.

---

### Adım 3.2 — AppStorage paketi (AppCore'a bağlı)

> "Devam" dediğimde başla.

#### 3.2.a Paketi oluştur

`Packages/Core/AppStorage/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppStorage",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppStorage", targets: ["AppStorage"])
    ],
    dependencies: [
        .package(path: "../AppCore")
    ],
    targets: [
        .target(
            name: "AppStorage",
            dependencies: ["AppCore"],
            path: "Sources/AppStorage"
        ),
        .testTarget(
            name: "AppStorageTests",
            dependencies: ["AppStorage"],
            path: "Tests/AppStorageTests"
        )
    ]
)
```

> Apple'ın SwiftUI'daki `@AppStorage` property wrapper'ı ile isim çakışması olabilir. Kullanırken `import AppStorage` yeterli, çakışma yoksa devam et. Çakışma çıkarsa paket adını **`AppKeychain`** veya **`AppPersistence`** yap. Sen bana hangisinin uygun olduğunu kontrol edip söyle.

#### 3.2.b Dosya taşı

- `RicknadMorty/CoreStorage/TokenStorageProtocol.swift` → `Sources/AppStorage/`
- `RicknadMorty/CoreStorage/KeychainTokenStorage.swift` → `Sources/AppStorage/`
- `RicknadMorty/CoreStorage/MockTokenStorage.swift` → `Sources/AppStorage/`

Tüm tipleri `public`, init'leri `public init` yap.

#### 3.2.c Klasör temizliği

`RicknadMorty/CoreStorage/` klasörünü sil.

#### 3.2.d Workspace + bağlama

Bana UI adımlarını ver: paketi workspace'e ekle, app target'a `AppStorage` bağla.

#### 3.2.e Import düzelt

`TokenStorageProtocol`, `KeychainTokenStorage`, `MockTokenStorage` referans veren her dosyaya `import AppStorage` ekle. Liste çıkar.

#### 3.2.f Smoke test

`Tests/AppStorageTests/MockTokenStorageTests.swift`:

```swift
import Testing
@testable import AppStorage

@Suite("MockTokenStorage")
struct MockTokenStorageTests {
    @Test("save/get roundtrip")
    func roundtrip() throws {
        let storage = MockTokenStorage()
        try storage.saveToken("abc")
        #expect(try storage.getToken() == "abc")
        #expect(storage.hasToken == true)
        try storage.deleteToken()
        #expect(storage.hasToken == false)
    }
}
```

#### 3.2.g Doğrulama

App build + test + login akışı. DUR, özetle.

---

### Adım 3.3 — AppNetwork paketi (AppCore + AppLogger'a bağlı)

> "Devam" dediğimde başla.

#### 3.3.a Paketi oluştur

`Packages/Core/AppNetwork/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppNetwork",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppNetwork", targets: ["AppNetwork"])
    ],
    dependencies: [
        .package(path: "../AppCore"),
        .package(path: "../AppLogger")
    ],
    targets: [
        .target(
            name: "AppNetwork",
            dependencies: ["AppCore", "AppLogger"],
            path: "Sources/AppNetwork"
        ),
        .testTarget(
            name: "AppNetworkTests",
            dependencies: ["AppNetwork"],
            path: "Tests/AppNetworkTests"
        )
    ]
)
```

#### 3.3.b Dosya taşı

CoreNetwork klasörünün TAMAMI:
- `HTTPMethod.swift`
- `Endpoint.swift` (içinde default `baseURL` var — uygulama spesifik. Bu paket reusable olacaksa default'u kaldırmak gerekebilir; **şimdilik bırak**, Faz 8'de cilalama yaparken ele alırız)
- `RequestBuilder.swift`
- `NetworkClientProtocol.swift`
- `NetworkClient.swift`

Hepsini `Sources/AppNetwork/` altına taşı.

`NetworkError` muhtemelen bu klasörde tanımlı (NetworkClient ve RequestBuilder kullanıyor) — onu da public yap.

Tüm tipler `public`, init'ler `public init`.

#### 3.3.c Klasör temizliği

`RicknadMorty/CoreNetwork/` sil.

#### 3.3.d Workspace + bağlama

UI adımları.

#### 3.3.e Import düzelt

`Endpoint`, `NetworkClient`, `NetworkClientProtocol`, `HTTPMethod`, `NetworkError`, `RequestBuilder` referans veren her dosyaya `import AppNetwork` ekle. Etkilenenler tahminen:
- `RicknadMorty/AppShell/AppDependencyContainer.swift`
- `RicknadMorty/AuthFeature/Data/AuthEndpoint.swift`
- `RicknadMorty/AuthFeature/Data/AuthService.swift`
- `RicknadMorty/HomeFeature/Data/HomeEndpoint.swift`
- `RicknadMorty/HomeFeature/Data/HomeService.swift`
- `RicknadMorty/SettingsFeature/Data/SearchEndpoint.swift`
- `RicknadMorty/SettingsFeature/Data/SearchService.swift`

Liste çıkar.

#### 3.3.f Smoke test

`Tests/AppNetworkTests/HTTPMethodTests.swift`:

```swift
import Testing
@testable import AppNetwork

@Suite("HTTPMethod")
struct HTTPMethodTests {
    @Test("rawValue is uppercase verb")
    func rawValue() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
    }
}
```

#### 3.3.g Doğrulama

App build + login + Home listesi + Search akışı. DUR, özetle.

---

### Adım 3.4 — DesignSystem paketi (AppCore'a bağlı)

> "Devam" dediğimde başla.

#### 3.4.a Paketi oluştur

`Packages/Core/DesignSystem/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(path: "../AppCore")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: ["AppCore"],
            path: "Sources/DesignSystem"
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            path: "Tests/DesignSystemTests"
        )
    ]
)
```

#### 3.4.b Dosya taşı

`RicknadMorty/DesignSystem/` altındaki tüm dosyalar `Sources/DesignSystem/` altına gider, **alt klasör yapısı korunur**:

```
Sources/DesignSystem/
├── Tokens/
│   ├── AppColors.swift
│   ├── AppSpacing.swift
│   └── AppTypography.swift
└── Components/
    ├── AppButton.swift
    ├── AppTextField.swift
    ├── LoadingView.swift
    └── ErrorView.swift
```

> SPM tek bir target altında alt klasörlere izin verir; Sources/DesignSystem altındaki tüm Swift dosyaları otomatik dahil edilir.

Tüm tipleri `public`, init'leri `public init`. Renk/font asset'leri varsa `Resources/` klasörü ekle ve `Package.swift`'e `resources: [.process("Resources")]` ekle. (Şu an asset yoksa atla.)

#### 3.4.c Klasör temizliği

`RicknadMorty/DesignSystem/` sil.

#### 3.4.d Workspace + bağlama

UI adımları.

#### 3.4.e Import düzelt

`AppButton`, `AppTextField`, `LoadingView`, `ErrorView`, `AppColors`, `AppSpacing`, `AppTypography` referans veren her View dosyasına `import DesignSystem` ekle.

#### 3.4.f Smoke test

`Tests/DesignSystemTests/TokensTests.swift`:

```swift
import Testing
import SwiftUI
@testable import DesignSystem

@Suite("DesignSystem tokens")
struct TokensTests {
    @Test("spacing tokens are positive")
    func spacings() {
        // AppSpacing'in API'sine göre uyarla
        #expect(Bool(true))
    }
}
```

#### 3.4.g Doğrulama

Tüm app screen'leri eskisi gibi render oluyor mu?

---

### Faz 3 Bitiş Kontrol Listesi

Hepsi bittiğinde şunları doğrula:

- [ ] `RicknadMorty/CoreLogger/`, `CoreStorage/`, `CoreNetwork/`, `DesignSystem/` klasörleri **silinmiş**.
- [ ] App target sadece şu klasörleri içeriyor: `AppShell/`, `AuthFeature/`, `HomeFeature/`, `ProfileFeature/`, `SettingsFeature/`, `*FeatureInterface/`, `Shared/` (sadece `FavoritesStore.swift` kalmış olmalı), `Assets.xcassets`, `GoogleService-Info.plist`, `RicknadMortyApp.swift`, `ContentView.swift` (varsa).
- [ ] Workspace 5 paket içeriyor: `AppCore`, `AppLogger`, `AppStorage`, `AppNetwork`, `DesignSystem`.
- [ ] Her paket bağımsız `swift test` ile yeşil.
- [ ] App tüm akışlarıyla çalışıyor (login, karakter listesi, detay, arama, çıkış).

Önerilen commit mesajları (her alt adım için ayrı):

```
feat(spm): extract AppLogger package
feat(spm): extract AppStorage package
feat(spm): extract AppNetwork package (depends on AppCore, AppLogger)
feat(spm): extract DesignSystem package
```

Her alt adım sonunda DUR ve bana onay sor. Hata alırsan tahmin etme, sor.

## (BURAYA KADAR KOPYALA)

---

## Sonrası

Faz 3 bittiğinde bana "Faz 3 tamam" yaz, ben **Faz 4 (FeatureInterface paketleri)** için prompt hazırlarım. O da kısa olacak — interface paketleri küçük ve birbirine benzer.

Sorun çıkarsa hata mesajını + hangi alt adımda (3.1 — 3.4) olduğunu yapıştır.
