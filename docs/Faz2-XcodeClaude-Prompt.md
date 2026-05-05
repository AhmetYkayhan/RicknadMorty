# Xcode-Claude'a Yapıştırılacak Prompt — Faz 2

Aşağıdaki metnin tamamını seç, kopyala ve Xcode'daki Claude'a tek mesaj olarak yapıştır. Aralarda not düşmeden, olduğu gibi gönder.

---

## (BURADAN İTİBAREN KOPYALA)

Bu RicknadMorty projesini Clean Swift + SwiftUI disiplinine uygun, modüler SPM paketleri halinde yeniden yapılandırıyorum. Şu an **Faz 2: ilk Core paketinin (AppCore) çıkarılması ve Workspace kurulumu** aşamasındayım. Aşağıdaki kararlar sabit:

- iOS deployment target: **iOS 17**
- Swift sürümü: **5.9**, strict concurrency yok
- Test framework: **Swift Testing**
- İlk paket adı: **AppCore** (Apple'ın CoreFoundation modülüyle çakışmamak için "Core" prefix'inden kaçınıyoruz)

Lütfen aşağıdaki adımları sırayla yap. Her adımdan sonra bana ne yaptığını özetle, sonraki adıma geç.

### Adım 1 — Klasör ve paket iskeletini oluştur

Repo köküne (`.xcodeproj` ile aynı seviye) şu klasör yapısını oluştur:

```
Packages/
└── Core/
    └── AppCore/
        ├── Package.swift
        ├── README.md
        ├── Sources/
        │   └── AppCore/
        │       └── .gitkeep
        └── Tests/
            └── AppCoreTests/
                └── .gitkeep
```

`Packages/Core/AppCore/Package.swift` içeriği:

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

`Packages/Core/AppCore/README.md` içeriği:

```markdown
# AppCore

RicknadMorty uygulamasının ortak çekirdek tipleri: AppError, LoadableState, ViewState.

- iOS 17+
- Swift 5.9
- Bağımsız (başka pakete bağımlı değil)
```

### Adım 2 — Mevcut dosyaları AppCore paketine taşı

Aşağıdaki dosyaları **taşı** (kopyala değil, eski yerden sil):

| Eskisi | Yenisi |
|---|---|
| `RicknadMorty/CoreError/AppError.swift` | `Packages/Core/AppCore/Sources/AppCore/AppError.swift` |
| `RicknadMorty/Shared/LoadableState.swift` | `Packages/Core/AppCore/Sources/AppCore/LoadableState.swift` |
| `RicknadMorty/Shared/ViewState.swift` | `Packages/Core/AppCore/Sources/AppCore/ViewState.swift` |

> `RicknadMorty/Shared/FavoritesStore.swift` taşınmaz, app target'ında kalır. (Bu sonra ProfileFeature'a gider.)

Taşıdığın dosyalarda **erişim kontrolünü güncelle** ki app target paketten kullanabilsin:
- Tüm `class`, `struct`, `enum`, `protocol`, `extension` tanımlarını `public` yap.
- `init(...)` metodlarını `public init(...)` yap.
- Dışarıdan okunması/kullanılması gereken tüm property ve fonksiyonları `public` yap.
- Sadece dosya içinde kullanılan internal helper'lar `internal` veya `fileprivate` kalsın.

Boş kalan klasörleri sil (`RicknadMorty/CoreError/` boş kalırsa kaldır; `RicknadMorty/Shared/` içinde FavoritesStore kalmaya devam edecek, klasörü silme).

### Adım 3 — App target'ında import'ları düzelt

Repo içinde `AppErrorProtocol`, `AppError`, `LoadableState`, `ViewState` tiplerine referans veren her Swift dosyasını bul ve dosyanın en üstüne `import AppCore` ekle (mevcut import'ların altına).

Hangi dosyalara import eklediğini liste olarak bana ver.

### Adım 4 — Workspace ve paket entegrasyonu (UI adımları için TALİMAT VER)

Bu adımı sen kod olarak yapamıyorsun, ben Xcode UI'ında yapacağım. Bana şu UI adımlarının **net sırasını** ver:

1. Mevcut Xcode'u kapat.
2. `RicknadMorty.xcworkspace` nasıl oluşturulur (File menüsünden), nereye kaydedilir?
3. Mevcut `RicknadMorty.xcodeproj` workspace'e nasıl eklenir?
4. `Packages/Core/AppCore` local SPM paketi workspace'e nasıl eklenir? (Add Package Dependencies → Add Local...)
5. App target'ın **General → Frameworks, Libraries, and Embedded Content** bölümüne `AppCore` library'si nasıl bağlanır?

Talimatları kısa ve sıralı ver, ekran görüntüsü şart değil.

### Adım 5 — Smoke test dosyası ekle

`Packages/Core/AppCore/Tests/AppCoreTests/AppErrorTests.swift` dosyasını oluştur:

```swift
import Testing
@testable import AppCore

@Suite("AppCore smoke")
struct AppCoreSmokeTests {
    @Test("AppCore imports successfully")
    func canImportModule() {
        #expect(Bool(true))
    }
}
```

> Eğer benim Xcode toolchain'imde `import Testing` çalışmazsa, Package.swift'e `swift-testing` paketini bağımlılık olarak nasıl ekleyeceğimi söyle.

### Adım 6 — Doğrulama

Adım 4 bitince app build aldığında:
- App'te kalmaması gereken (taşınan) tipler artık `import AppCore` ile geliyor mu?
- `swift test` Packages/Core/AppCore/ klasöründen yeşil mi?
- Firebase Auth login akışı ve Home karakter listesi eskisi gibi çalışıyor mu?

Bunlar yeşilse şu commit mesajını öner:

```
feat(spm): extract AppCore package with shared error/state types

- Create Packages/Core/AppCore SPM module (iOS 17, Swift 5.9)
- Move AppError, LoadableState, ViewState to AppCore
- Add AppCore as local package dependency to RicknadMorty workspace
- Update imports across app target
```

### Çalışma kuralı

Her adımdan sonra bana:
1. Ne yaptığının kısa özeti
2. Değişen / oluşturulan dosya listesi
3. Sonraki adıma geçmek için onay isteme

ile dön. Yapamadığın veya emin olmadığın şeyleri sor, tahmin etme.

## (BURAYA KADAR KOPYALA)

---

## Sonrası

Adım 4 (workspace UI) bittiğinde, bu Cowork sohbetine "Faz 2 tamam" yazarsan ben:
- Faz 3 için aynı şablonun bir benzerini hazırlarım (`AppLogger`, `AppStorage`, `AppNetwork`, `DesignSystem` paketleri).
- Veya ortada bir hata kaldıysa onu çözeriz.

Takıldığın bir Xcode hatası olursa: hata mesajını + hangi adımda olduğunu (1–6) yapıştır.
