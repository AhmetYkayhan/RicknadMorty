# Faz 2 Handoff — Xcode'daki Claude için talimatlar

Bu doküman, RicknadMorty projesini SPM tabanlı Clean Swift refactor'üne hazırlamak için **Faz 2'yi (Workspace + ilk Core paketi)** Xcode IDE'sinde Claude ile yürütürken kullanacağın eksiksiz adım listesidir.

> **Faz 1 kararları (sabitlendi):** iOS 17, Swift 5 + minimum concurrency, Swift Testing, Scene-bazlı klasör yapısı.

---

## A. Faz 2 Adımları (Sıralı)

### A.1. Pre-flight (sen yap)

1. Mevcut working tree'yi commitle: `git add -A && git commit -m "snapshot before SPM refactor"`.
2. Yeni branch aç: `git checkout -b refactor/spm-faz2`.
3. Xcode'u kapat (workspace oluşturulurken kapalı olması daha güvenli).

### A.2. Klasör iskeleti (Xcode-Claude'dan iste)

Repo köküne (`/RicknadMorty/`) şu klasör yapısını oluştur:

```
Packages/
└── Core/
    └── CoreFoundation/
        ├── Package.swift
        ├── README.md
        ├── Sources/
        │   └── CoreFoundation/
        │       └── .gitkeep
        └── Tests/
            └── CoreFoundationTests/
                └── .gitkeep
```

### A.3. `Package.swift` içeriği

`Packages/Core/CoreFoundation/Package.swift` dosyasına yapıştır:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreFoundation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreFoundation",
            targets: ["CoreFoundation"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreFoundation",
            path: "Sources/CoreFoundation"
        ),
        .testTarget(
            name: "CoreFoundationTests",
            dependencies: ["CoreFoundation"],
            path: "Tests/CoreFoundationTests"
        )
    ]
)
```

> Apple'ın `Foundation` framework'ü ile çakışma riski: `import CoreFoundation` Apple'ın low-level C framework'üyle aynı isim! İki seçenek:
> - **Önerilen:** Paket adını `RMCoreFoundation` veya `AppCore` yap, modül çakışmasını önle.
> - Alternatif: `CoreKit` veya `SharedKit` gibi nötr bir isim.
>
> Bu plana **`AppCore`** ismini öneriyorum. Aşağıdaki adımlarda `AppCore` üzerinden gideceğim — sen `CoreFoundation`'ı tercih edersen tüm referansları değiştirirsin.

### A.4. Düzeltilmiş yapı (`AppCore` ismiyle)

```
Packages/
└── Core/
    └── AppCore/
        ├── Package.swift
        ├── README.md
        ├── Sources/
        │   └── AppCore/
        │       ├── AppError.swift           ← Mevcut CoreError/AppError.swift'ten taşınacak
        │       ├── LoadableState.swift      ← Mevcut Shared/LoadableState.swift'ten
        │       └── ViewState.swift          ← Mevcut Shared/ViewState.swift'ten
        └── Tests/
            └── AppCoreTests/
                └── AppErrorTests.swift
```

`Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "AppCore", targets: ["AppCore"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppCore",
            path: "Sources/AppCore"
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"],
            path: "Tests/AppCoreTests"
        )
    ]
)
```

### A.5. Taşınacak dosyalar ve yapılacak değişiklikler

| Kaynak (mevcut) | Hedef (paket içinde) | Değişiklik |
|---|---|---|
| `RicknadMorty/CoreError/AppError.swift` | `Sources/AppCore/AppError.swift` | `protocol AppErrorProtocol` ve onunla ilgili tipleri `public` yap. Public init'leri ekle. |
| `RicknadMorty/Shared/LoadableState.swift` | `Sources/AppCore/LoadableState.swift` | Tip ve case'leri `public` yap. |
| `RicknadMorty/Shared/ViewState.swift` | `Sources/AppCore/ViewState.swift` | Aynı: `public`. |

> `Shared/FavoritesStore.swift` bu pakete **GİRMEZ** — domain'e özel. İlerleyen fazda `ProfileFeature` veya ayrı bir paket olur.

**Public erişim kontrol checklist'i** (her dosya için):
- [ ] `class`, `struct`, `enum`, `protocol`, `extension` → `public`
- [ ] `init(...)` → `public init(...)`
- [ ] `case`'ler enum public ise otomatik public; ama enum kendisi public olmalı.
- [ ] `let`/`var` property'ler → kullanılacaksa `public`.
- [ ] App target'tan kullanılmayan internal helper'lar `internal` kalsın (paket dışına sızmasın).

### A.6. Xcode Workspace oluşturma (manuel UI)

1. Xcode'u aç (henüz `.xcodeproj` ile).
2. **File → New → Workspace...** → adı `RicknadMorty.xcworkspace`, repo köküne kaydet.
3. Yeni workspace açıldı; sol panelde boş.
4. **File → Add Files to "RicknadMorty"...** → mevcut `RicknadMorty.xcodeproj`'u seç. Workspace'e eklenir.
5. **File → Add Package Dependencies...** → sağ alttaki **Add Local...** butonuna tıkla → `Packages/Core/AppCore` klasörünü seç → **Add Package**.
6. Workspace'e local package eklendi. App target'a bağla:
   - Workspace navigatöründe `RicknadMorty` projesi → **TARGETS → RicknadMorty** → **General → Frameworks, Libraries, and Embedded Content** → **+** → `AppCore` library'sini seç.

### A.7. App içindeki import'ları düzelt

Aşağıdaki dosyalarda `AppError`, `LoadableState`, `ViewState` kullanılıyor. Her birinin başına `import AppCore` eklenmesi gerekecek (Xcode-Claude bunu hızlıca yapar):

Tahmini etkilenen dosyalar (grep önerisi):

```bash
grep -rln "AppErrorProtocol\|LoadableState\|ViewState" RicknadMorty/ \
  --include="*.swift"
```

Bu listedeki her dosyaya `import AppCore` ekle.

### A.8. Smoke testi

`Tests/AppCoreTests/AppErrorTests.swift`:

```swift
import Testing
@testable import AppCore

@Suite("AppError userMessage")
struct AppErrorTests {
    @Test("network error has user-facing message")
    func networkErrorMessage() async throws {
        // Burada gerçek AppError tipinle örnek bir test yaz.
        // Örn:
        // let err = AppError.network(.timeout)
        // #expect(err.userMessage.isEmpty == false)
    }
}
```

> Swift Testing için Package.swift'te ek dependency gerekmez — Xcode 16'dan itibaren Swift toolchain ile geliyor. Eğer toolchain'in eski ise:
> ```swift
> .package(url: "https://github.com/apple/swift-testing.git", from: "0.10.0"),
> ```
> ile ekle ve test target'ı `dependencies: ["AppCore", .product(name: "Testing", package: "swift-testing")]` yap.

### A.9. Doğrulama checklist'i

- [ ] `RicknadMorty.xcworkspace` açılıyor, app derleniyor.
- [ ] App'te `import AppCore` çalışıyor.
- [ ] `AppError`, `LoadableState`, `ViewState` artık app target'ında değil — sadece pakette.
- [ ] `swift test` (paket kökünde) yeşil.
- [ ] Firebase Auth + Home akışı eski gibi çalışıyor (smoke test).
- [ ] Commit: `git add -A && git commit -m "feat(spm): extract AppCore package with shared error/state types"`

---

## B. Xcode-Claude'a Verebileceğin Hazır Prompt'lar

### B.1. Klasör + Package.swift oluşturma prompt'u

```
RicknadMorty repo'sunda Faz 2 SPM refactor'üne başlıyorum. Şu adımları yap:

1. Repo köküne Packages/Core/AppCore/ klasörünü oluştur.
2. Packages/Core/AppCore/Package.swift dosyasını şu içerikle yaz:
[A.4'teki Package.swift'i yapıştır]

3. Sources/AppCore/ ve Tests/AppCoreTests/ alt klasörlerini oluştur, içlerine .gitkeep koy.

4. README.md'yi şöyle yaz: "AppCore — RicknadMorty uygulamasının ortak çekirdek tipleri (AppError, LoadableState, ViewState). iOS 17+, Swift 5.9."

Bittiğinde dosya ağacını listele.
```

### B.2. Dosya taşıma prompt'u

```
Aşağıdaki dosyaları RicknadMorty app target'ından AppCore paketine taşı ve içeriklerinde tüm tipleri public yap:

- RicknadMorty/CoreError/AppError.swift → Packages/Core/AppCore/Sources/AppCore/AppError.swift
- RicknadMorty/Shared/LoadableState.swift → Packages/Core/AppCore/Sources/AppCore/LoadableState.swift
- RicknadMorty/Shared/ViewState.swift → Packages/Core/AppCore/Sources/AppCore/ViewState.swift

Public hale getirirken:
- struct/class/enum/protocol/extension'ları public yap
- init'leri public init yap
- dış kullanılacak property'leri public yap
- internal helper'lar varsa internal bırak

Sonra app target'taki tüm Swift dosyalarında bu tiplere referans veren dosyaları bul ve başlarına 'import AppCore' ekle. Hangi dosyalara import eklediğini listele.
```

### B.3. Workspace ekleme prompt'u

```
Şu anda Xcode'da RicknadMorty.xcodeproj açık. Aşağıdaki manuel adımları senin için ben yapacağım — sadece doğru sırayla ne yapacağımı söyle:

1. Workspace nasıl oluşturulur, mevcut .xcodeproj nasıl eklenir?
2. AppCore local package nasıl eklenir?
3. App target'a paket nasıl link edilir?

Adım adım Xcode UI talimatları ver.
```

### B.4. Build hatası giderme prompt'u (gerektiğinde)

```
Workspace + AppCore paketini ekledim. Şimdi build aldığımda şu hataları alıyorum:

[hata mesajlarını yapıştır]

Bunları analiz et ve düzelt. Public erişim eksiklikleri için en olası neden, bir tipin public, ama init'inin veya ihtiyaç duyulan property'sinin internal kalması.
```

---

## C. Faz 2 Sonrası Karar Noktaları

Faz 2 başarıyla bittikten sonra Faz 3 (kalan Core paketleri) için aynı şablon uygulanır:

| Sıra | Paket | Bağımlılık | Taşınacak |
|---|---|---|---|
| 3.1 | `AppLogger` | yok | `CoreLogger/Logger.swift` |
| 3.2 | `AppStorage` | `AppCore` (AppError için) | `CoreStorage/*` |
| 3.3 | `AppNetwork` | `AppCore`, `AppLogger` | `CoreNetwork/*` |
| 3.4 | `DesignSystem` | `AppCore` | `DesignSystem/*` |

> "Core" prefix'i Apple'ın CoreData/CoreGraphics/CoreFoundation modülleriyle çakışmaması için "App" prefix'ine çevrildi.

Her birinin Package.swift'i yukarıdaki AppCore şablonu temel alınarak yazılır; sadece `dependencies` ve `path` değişir.

---

## D. Bana Geri Bildirim Vermek İstediğinde

Xcode-Claude'da takıldığın yerlerde:
- Tam hata mesajını
- Build edilen target ve scheme'i
- Hangi adımda olduğunu (A.1 — A.9)

bu Cowork sohbetine yapıştır; planı veya prompt'ları güncelleyelim.
