# Xcode-Claude'a Yapıştırılacak Prompt — Faz 4

Aşağıdaki metnin tamamını seç, kopyala ve Xcode'daki Claude'a tek mesaj olarak yapıştır.

---

## (BURADAN İTİBAREN KOPYALA)

Faz 3 tamamlandı: 5 Core paketi (`AppCore`, `AppLogger`, `AppStorage`, `AppNetwork`, `DesignSystem`) workspace'te ve app target'a bağlı. Şimdi **Faz 4: FeatureInterface paketleri**.

### Amaç

Mevcut 4 interface dosyası (`AuthFeatureInterface`, `HomeFeatureInterface`, `ProfileFeatureInterface`, `SettingsFeatureInterface`) sadece protokol + route enum + delegate içeriyor. Her birini ayrı, çok küçük bir SPM paketine taşıyacağız. Bu paketler:

- Hiçbir Core pakete bağlı değil (sadece `SwiftUI` import'u var)
- Sadece `public` protokol + `public enum Route` + `public protocol Delegate` içerir
- App target ve **kendi Feature paketi** (Faz 5'te oluşacak) tarafından import edilir

Klasör yapısı:

```
Packages/FeatureInterfaces/
├── AuthFeatureInterface/
├── HomeFeatureInterface/
├── ProfileFeatureInterface/
└── SettingsFeatureInterface/
```

Sabit kurallar (Faz 2/3'le aynı): iOS 17, Swift 5.9, Swift Testing, scene-bazlı yapı, `public` her şey.

Çalışma kuralı: **4 paketi ardışık yap, ama hepsini bitirmeden DURMA** — birbirine çok benziyorlar, hepsi aynı şablonu izliyor. Bittiğinde toplu özet ver.

---

### Adım 4.1 — Şablon (her paket için tekrarlanacak)

Her FeatureInterface paketi için aşağıdaki şablonu uygula. `<Name>` yerine `Auth`, `Home`, `Profile`, `Settings` koy.

#### 4.1.a Klasör + Package.swift

`Packages/FeatureInterfaces/<Name>FeatureInterface/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "<Name>FeatureInterface",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "<Name>FeatureInterface", targets: ["<Name>FeatureInterface"])
    ],
    targets: [
        .target(
            name: "<Name>FeatureInterface",
            path: "Sources/<Name>FeatureInterface"
        ),
        .testTarget(
            name: "<Name>FeatureInterfaceTests",
            dependencies: ["<Name>FeatureInterface"],
            path: "Tests/<Name>FeatureInterfaceTests"
        )
    ]
)
```

`README.md`: kısa, "X feature'ının dış dünya ile sözleşmesi. Sadece protokol + route + delegate."

#### 4.1.b Dosyayı taşı

`RicknadMorty/<Name>FeatureInterface/<Name>FeatureInterface.swift` → `Packages/FeatureInterfaces/<Name>FeatureInterface/Sources/<Name>FeatureInterface/<Name>FeatureInterface.swift`

İçinde:
- `protocol <Name>FeatureInterface` → `public protocol`
- `enum <Name>Route` → `public enum`, tüm case'ler otomatik public olur (enum public olduğu için)
- `protocol <Name>FeatureDelegate` → `public protocol`
- Delegate metod imzaları ve protocol method'ları (ör. `makeXxxView() -> AnyView`) otomatik olarak `public protocol` içinde olduğu için public — ama protocol içinde değişiklik yapmana gerek yok.

> **Önemli:** `func makeXxxView() -> AnyView` imzası protokol içinde olduğu için **default implementation gerektirmez**. `@MainActor` annotation'ı korunmalı.

#### 4.1.c Klasörü temizle

`RicknadMorty/<Name>FeatureInterface/` klasörünü sil (boş kalmış olmalı).

#### 4.1.d Smoke test

`Tests/<Name>FeatureInterfaceTests/<Name>FeatureInterfaceTests.swift`:

```swift
import Testing
@testable import <Name>FeatureInterface

@Suite("<Name>FeatureInterface smoke")
struct <Name>FeatureInterfaceSmokeTests {
    @Test("interface module loads")
    func loads() {
        #expect(Bool(true))
    }
}
```

---

### Adım 4.2 — 4 paketi sırayla oluştur

Yukarıdaki şablonu şu sırayla uygula:

1. **AuthFeatureInterface**
2. **HomeFeatureInterface**
3. **ProfileFeatureInterface**
4. **SettingsFeatureInterface**

Her birinin sadece dosya adlarını ve protokol isimlerini değiştir, içerik aynı şablon.

---

### Adım 4.3 — Workspace + bağlama (UI talimatları)

4 paketi tek tek workspace'e ekleyip app target'a bağla. Bana sırayla şunları sor:

1. 4 local paketi workspace'e tek seferde nasıl eklerim? (Add Package Dependencies → Add Local sürecini her biri için ayrı mı yapmalıyım, yoksa hepsini aynı dialog'da seçebilir miyim?)
2. App target'ın **General → Frameworks** bölümüne 4 library'yi sırayla nasıl eklerim?

---

### Adım 4.4 — Import düzeltmeleri

App target'taki şu dosyalar muhtemelen interface'leri import etmesi gerekecek (kontrol et):

- `RicknadMorty/AppShell/AppDependencyContainer.swift` — `import AuthFeatureInterface`, `import HomeFeatureInterface`, `import ProfileFeatureInterface`, `import SettingsFeatureInterface`
- `RicknadMorty/AppShell/AppCoordinator.swift` — büyük ihtimalle interface delegate'leri kullanıyor
- `RicknadMorty/AppShell/RootView.swift`
- `RicknadMorty/AppShell/MainTabView.swift`
- `RicknadMorty/AuthFeature/AuthFeatureAssembly.swift` — `import AuthFeatureInterface`
- `RicknadMorty/HomeFeature/HomeFeatureAssembly.swift` — `import HomeFeatureInterface`
- `RicknadMorty/AuthFeature/Presentation/LoginViewModel.swift` — `AuthFeatureDelegate` kullanıyor → import et

Etkilenen dosyaların listesini çıkar ve her birine doğru import'u ekle.

---

### Adım 4.5 — Toplu doğrulama

Hepsi bittiğinde:

- [ ] `Packages/FeatureInterfaces/` altında 4 klasör.
- [ ] App target'ında `*FeatureInterface/` klasörleri **silinmiş**.
- [ ] Workspace'te 4 yeni paket görünüyor.
- [ ] Her interface paketi için `swift test` yeşil (smoke).
- [ ] App build alıyor ve tüm akışlar çalışıyor.

Önerilen commit:

```
feat(spm): extract feature interface packages

- AuthFeatureInterface, HomeFeatureInterface, ProfileFeatureInterface, SettingsFeatureInterface
- Each is a tiny SPM module with public protocol + route + delegate
- App target and (future) feature packages depend on these for cross-feature contracts
```

Bittiğinde toplu özet ver: oluşturulan paketler, taşınan dosyalar, eklenen import'lar.

## (BURAYA KADAR KOPYALA)

---

## Sonrası

Faz 4 bittiğinde "Faz 4 tamam" yaz. Sonraki **Faz 5 büyük olacak**: feature'ların VIP-S (Clean Swift adapt) yapısına dönüşü ve kendi SPM paketlerine taşınması. Onu **AuthFeature ile başlayıp tek tek** yapacağız — her feature kendi başına bir alt-prompt olacak.

Sorun çıkarsa hata mesajını + hangi adımda (4.1 — 4.5) olduğunu yapıştır.
