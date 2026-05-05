# RicknadMorty — Clean Swift + SwiftUI + Reusable SPM Yol Haritası

Bu doküman; mevcut RicknadMorty projesini **Clean Swift disiplinini koruyarak**, **SwiftUI uyumlu bir VIP-S adaptasyonu** ile **Core + Feature SPM paketleri** halinde yeniden yapılandırmak için hazırlanmış yüksek seviyeli yol haritasıdır.

> Hedef: App target neredeyse boş kalacak — sadece composition root + App entry point. Tüm domain/data/presentation kodu, bağımsız Swift Package'larda yaşayacak ve test edilebilir olacak.

---

## 0. Kabuller ve Hedef Mimari

### Clean Swift'in SwiftUI'ya adapte hâli (VIP-S)

Klasik Clean Swift (VIP) UIKit'e göre tasarlandı; SwiftUI'da `UIViewController` yerine `View` struct'larıyla çalıştığımız için aşağıdaki adaptasyonu öneriyorum:

| Klasik VIP | SwiftUI VIP-S karşılığı | Sorumluluk |
|---|---|---|
| `ViewController` | `View` (SwiftUI) | Sadece UI çizimi, kullanıcı niyetlerini Interactor'a iletir |
| `Interactor` | `Interactor` (`actor` veya `@MainActor` sınıf) | İş mantığı, UseCase/Worker çağrısı |
| `Presenter` | `Presenter` (`@Observable` sınıf) | Response → `ViewState` formatlama; View bunu gözler |
| `Worker` | `UseCase` / `Repository` / `Service` | Tek bir teknik iş (network, keychain, vb.) |
| `Router` | `Coordinator` veya `NavigationPath` binding | Sahne arası geçiş |
| `Models` | `Scene.Request` / `Scene.Response` / `Scene.ViewState` | Katmanlar arası DTO |

Tek View başına bir "scene" klasörü olur:
```
LoginScene/
  LoginModels.swift          // Request / Response / ViewState
  LoginInteractor.swift
  LoginPresenter.swift
  LoginView.swift
  LoginRouter.swift          // SwiftUI'da çoğu zaman Coordinator delegesi
```

### Paketleme stratejisi: Core + Feature

```
RicknadMortyWorkspace/
├── Packages/
│   ├── Core/
│   │   ├── CoreFoundation        (AppError, LoadableState, ViewState, ortak tipler)
│   │   ├── CoreLogger
│   │   ├── CoreNetwork           (Endpoint, NetworkClient, RequestBuilder)
│   │   ├── CoreStorage           (TokenStorage, Keychain)
│   │   ├── CoreUI / DesignSystem (Tokens + Components)
│   │   └── CoreTesting           (Mock'lar, test helper'ları — sadece test target'larında)
│   ├── FeatureInterfaces/
│   │   ├── AuthFeatureInterface
│   │   ├── HomeFeatureInterface
│   │   ├── ProfileFeatureInterface
│   │   └── SettingsFeatureInterface
│   └── Features/
│       ├── AuthFeature           → AuthFeatureInterface, Core*
│       ├── HomeFeature           → HomeFeatureInterface, Core*
│       ├── ProfileFeature        → ProfileFeatureInterface, Core*
│       └── SettingsFeature       → SettingsFeatureInterface, Core*
└── App/
    └── RicknadMorty.xcodeproj    (sadece composition root + App entry)
```

**Bağımlılık kuralı (tek yön):**
```
App → FeatureInterfaces + Features
Features → FeatureInterfaces + Core*
FeatureInterfaces → CoreFoundation (sadece public model tipleri için)
Core* → birbirinden bağımsız (CoreNetwork, CoreStorage vs. CoreFoundation hariç hiçbirine bağlanmaz)
```

Featurelar **birbirine doğrudan bağlanmaz**; iletişim her zaman `*FeatureInterface` üzerinden ve `delegate` callback'leri ile olur. Bu, paketlerin tek tek başka projelerde reusable olmasını sağlar.

---

## 1. Faz — Hazırlık ve Karar Alma ✅ TAMAMLANDI

Alınan kararlar:

| Konu | Karar |
|---|---|
| iOS deployment target | **iOS 17** |
| Swift sürümü / concurrency | **Swift 5**, minimum concurrency uyarıları (Swift 6 strict yok) |
| Test framework | **Swift Testing** (yeni) |
| Klasör konvansiyonu | Scene-bazlı (her sahne kendi `Scene/` klasörü altında VIP-S dosyalarıyla) |
| FeatureInterface yüzeyi | Sadece `public` protokol + `Sendable` model + `Delegate` |
| Composition root | `App` target'taki `AppDependencyContainer` — feature paketleri kendi internal DI'larını yapar, dışa sadece factory metodları açar |

---

## 2. Faz — Workspace ve İlk SPM İskeletinin Kurulması (1 gün)

**Amaç:** Kod taşımadan önce paket iskeleti hazır olsun, mevcut app çalışmaya devam etsin.

İşler:
- `RicknadMortyWorkspace.xcworkspace` oluştur. Mevcut `RicknadMorty.xcodeproj`'u içine al.
- `Packages/Core/CoreFoundation` paketini oluştur (boş `Package.swift` + dummy hedef). Workspace'e ekle, app target'a bağla.
- Xcode'da derleme akışını doğrula: app hâlâ build alıyor mu?
- Git stratejisi: her faz için ayrı feature branch, küçük PR'lar.
- Firebase SPM bağımlılıklarını Workspace seviyesine taşı veya ilgili Feature paketine kapat (AuthFeature içine).

Acceptance:
- [ ] Workspace açılıyor, app derleniyor, Firebase çalışıyor.
- [ ] Boş bir Core paketi import edilebiliyor.

---

## 3. Faz — Core Paketlerinin Çıkarılması (2-3 gün)

**Amaç:** `Core*` klasörlerinin tamamını paketlere taşı. Feature kodu henüz dokunulmaz.

Sıra (bağımlılık zincirinin tabanından tepeye):
1. **CoreFoundation** — `AppError`, `LoadableState`, `ViewState`. Public API minimal tutulur, gereksiz internal tipler `internal` kalır.
2. **CoreLogger** — `LoggerProtocol`, `AppLogger`. Bağımsız.
3. **CoreStorage** — `TokenStorageProtocol`, `KeychainTokenStorage`, `MockTokenStorage`. Sadece CoreFoundation'a bağlı.
4. **CoreNetwork** — `Endpoint`, `HTTPMethod`, `RequestBuilder`, `NetworkClient(Protocol)`. CoreLogger + CoreFoundation'a bağlı.
5. **CoreUI / DesignSystem** — `Tokens/*`, `Components/*`. Sadece CoreFoundation'a bağlı (renkler, tipografi).

Her paket için yapılacaklar:
- `Sources/<PackageName>/` altına dosyaları taşı.
- Dışarıya açılması gerekenleri `public` yap (özellikle initializer'ları!).
- `Tests/<PackageName>Tests/` ile en az smoke test ekle.
- README.md (kısa: ne işe yarıyor, nasıl import ediliyor).

Acceptance:
- [ ] App target'tan `Core*` klasörleri silinmiş, paketlerden import ediliyor.
- [ ] Her Core paketi standalone build alıyor (`swift build`).
- [ ] CI'da `swift test` her paket için yeşil.

---

## 4. Faz — FeatureInterface Paketleri (0,5-1 gün)

**Amaç:** Feature'ların shell ile konuştuğu sözleşmeleri ayrı, küçük, bağımlılığı az paketlere çıkar.

İşler:
- Her `*FeatureInterface.swift` dosyası kendi `*FeatureInterface` paketine taşınır.
- İçeriği sade tut: protokol + `Delegate` + `Output` enum + public model tipleri.
- Sadece `CoreFoundation`'a bağlanır (örn. `AppError` paylaşımı için).
- `AnyView` döndürmek yerine `some View` veya generic factory dönmeyi değerlendir (test edilebilirlik için).

> **Not:** Mevcut `AnyView` dönüşü reusable bir paket için kabul edilebilir, fakat composition root testlerinde sorun çıkarabilir. Bu fazda interface'leri tasarımı kıracak şekilde değil, sadece dosya organizasyonu açısından taşıyoruz; `AnyView` değişikliği Faz 5'te scene refactor'ünde ele alınır.

Acceptance:
- [ ] Her `*FeatureInterface` paketi bağımsız build alıyor.
- [ ] App target hâlâ derleniyor.

---

## 5. Faz — Feature'ların Clean Swift VIP-S'e Çevrilmesi (Feature başına 1-2 gün)

**Amaç:** Mevcut MVVM ViewModel'leri, Clean Swift VIP-S disiplinine uygun Interactor + Presenter + Models yapısına çevir.

Sıra (riskten düşüğe doğru): **AuthFeature → HomeFeature → SettingsFeature → ProfileFeature**

Her feature için yapılacaklar:

**5.1 Paket iskeleti**
- `Packages/Features/<Name>Feature` paketi.
- `Package.swift` bağımlılıkları: `<Name>FeatureInterface`, `CoreFoundation`, `CoreNetwork`, `CoreStorage`, `CoreLogger`, `CoreUI`.

**5.2 Dosya yapısının yenilenmesi**
- `Sources/<Name>Feature/` altında:
  ```
  Domain/         (Entity, RepositoryProtocol, UseCase) — mevcut yapı korunur, paketlenir
  Data/           (DTO, Mapper, Endpoint, Service, Repository) — mevcut yapı korunur
  Scenes/
    <Scene>/
      <Scene>Models.swift     // Request / Response / ViewState
      <Scene>Interactor.swift
      <Scene>Presenter.swift
      <Scene>View.swift
      <Scene>Router.swift     // ihtiyaç varsa
  Assembly/
    <Name>FeatureAssembly.swift
  ```

**5.3 ViewModel → Interactor + Presenter dönüşümü**
- Mevcut `LoginViewModel.login()` aşağıdaki gibi bölünür:
  - **View** → `Interactor.handle(.login(email, password))` çağırır.
  - **Interactor** → `LoginUseCase.execute(...)` (mevcut `UseCase` Worker rolünde) → sonucu `Response` olarak `Presenter.present(...)`'a verir.
  - **Presenter** → `Response`'u `ViewState`'e map eder, `@Observable` üzerinden View gözler.
- Hata yolları (network, validation) için `Response` enum'u net olsun.

**5.4 Test eklenmesi**
- Interactor unit testi (mock UseCase ile).
- Presenter unit testi (formatlama mantığı).
- View → snapshot test (opsiyonel).

**5.5 Tutarlılık temizliği**
- **SettingsFeature/Search:** Şu an `AppDependencyContainer.makeSearchViewModel()` doğrudan ViewModel döndürüyor. Bu, `SettingsFeatureAssembly` üzerinden `SettingsFeatureInterface`'e taşınacak.
- **ProfileFeature:** Şu an sadece Presentation'da. `ProfileFeatureInterface` için Domain/Data katmanı (favoriler kaynak verisi) tanımlanacak. `FavoritesStore` muhtemelen `ProfileFeature` içine veya ayrı bir paket olarak çıkarılmalı.

Acceptance (her feature için):
- [ ] App, feature'ı sadece interface üzerinden tüketiyor.
- [ ] Feature paketi standalone build + test alıyor.
- [ ] Public API minimum: sadece interface ve assembly factory.

---

## 6. Faz — App Shell + Composition Root Sadeleştirmesi (1 gün)

**Amaç:** App target neredeyse "ince" hale gelsin.

İşler:
- `AppDependencyContainer` artık sadece feature interface factory'leri döndürür; içerideki use case/repository üretimi feature paketlerine taşınmış olabilir (her feature kendi internal composition'ını yapar, dışa sadece factory metodları açar).
- `AppCoordinator`, `RootView`, `MainTabView`, `AppRoute` app target'ta kalır.
- `RicknadMortyApp` Firebase'i konfigüre eder ve container'ı kurar — başka iş yapmaz.

Acceptance:
- [ ] App target'ında sadece: `AppShell/`, `RicknadMortyApp.swift`, `Assets.xcassets`, `GoogleService-Info.plist`.
- [ ] Tüm `import RicknadMorty…` referansları `import FeatureInterface` olmuş.

---

## 7. Faz — Test, CI, Lint, Format (1-2 gün)

**Amaç:** Disiplinin korunmasını otomatikleştir.

İşler:
- **Test runner:** GitHub Actions / Xcode Cloud — her paket için `swift test`, app için `xcodebuild test`.
- **SwiftLint** + **SwiftFormat** konfigürasyonu repo köküne. Paketlerde de aynı kural.
- **Mimari testleri** (opsiyonel ama değerli): `import` graph kontrolü — `CoreNetwork` `AuthFeature`'ı asla import edemez gibi kuralları doğrulayan basit bir CI script'i.
- **Code coverage** raporu Core ve Feature paketleri için.
- **Public API stability:** Her paket için README'de "Public API" listesi tutulur.

---

## 8. Faz — Reusability İçin Cilalama (0,5-1 gün)

**Amaç:** Paketler başka projelerde de kullanılabilir hale gelsin.

İşler:
- Her paket için `README.md` (kullanım örneği + minimum iOS sürümü + bağımlılık listesi).
- `Package.swift` `swiftLanguageVersions` ve `platforms` doğru ayarlı.
- Domain'e özgü olan / olmayan ayrımı: örneğin `CoreNetwork` tamamen generic olmalı, Rick&Morty'ye özgü hiçbir şey içermemeli. Eğer bulursak temizleriz.
- Feature paketleri "RicknadMorty"ye özel kalabilir; ama Core paketleri başka projeye düşürülebilir olmalı.
- Versiyonlama: SemVer + Git tag (`CoreNetwork-1.0.0` gibi monorepo tag formatı).

---

## 9. Risk ve Dikkat Edilecekler

| Risk | Etki | Önlem |
|---|---|---|
| Firebase'in Auth feature içinde "kapatılması" | AuthFeature paketi Firebase'e bağımlı kalır → CoreNetwork değil ama AuthFeature reusable olmaz | Service implementasyonu (`FirebaseAuthService`) AuthFeature içinde "internal" kalsın; protokol public. Kullanmak istemeyen başka projede REST `AuthService` enjekte edilebilir. |
| `AnyView` dönüşü generic API'yi engelliyor | Test edilebilirlik ve preview deneyimi düşer | Faz 5'te interface'i `func makeLoginView() -> some View` veya generic associated type ile yeniden tasarla. |
| Strict concurrency Swift 6 hataları | Refactor sırasında uzun sürer | Önce Swift 5 + minor concurrency uyarıları, en sonda Swift 6'ya yükselt. |
| Cross-feature data paylaşımı (örn. FavoritesStore Profile <→ Home arası) | Feature izolasyonu kırılır | `FavoritesStore`'u ya bağımsız `Packages/Core/CoreFavorites` paketi yap, ya da event-bus / interface üzerinden expose et. |
| iOS 26.2 deployment target | Çok dar bir kullanıcı kitlesi, paketler reusable olmaz | `iOS 17` (veya 16) hedefle; yeni API'ler için runtime check. |

---

## 10. Zaman Tahmini ve Sıralama

Tek geliştiriciyle, yarım günlük blok başına:

| # | Faz | Tahmin |
|---|---|---|
| 1 | Hazırlık / kararlar | 0,5 gün |
| 2 | Workspace + ilk paket | 1 gün |
| 3 | Core paketleri | 2-3 gün |
| 4 | FeatureInterface paketleri | 0,5-1 gün |
| 5 | AuthFeature VIP-S | 1-2 gün |
| 5 | HomeFeature VIP-S | 1-2 gün |
| 5 | SettingsFeature VIP-S + temizlik | 1-2 gün |
| 5 | ProfileFeature VIP-S | 1 gün |
| 6 | App shell sadeleştirme | 1 gün |
| 7 | CI + lint + test | 1-2 gün |
| 8 | Reusability cilalama | 0,5-1 gün |

**Toplam:** ~10-15 efektif geliştirici günü.

---

## 11. Sıradaki Adım: Faz 2

Faz 1 kapandığına göre artık **Faz 2 — Workspace ve İlk SPM İskeletinin Kurulması** başlıyor. Bu fazda yapılacaklar:

1. Repo köküne `Packages/` klasörü açılacak.
2. `Packages/Core/CoreFoundation/` altında ilk Swift Package oluşturulacak (boş ama derlenebilir).
3. `RicknadMortyWorkspace.xcworkspace` mevcut `RicknadMorty.xcodeproj` ile birlikte oluşturulacak — paket workspace'e local package olarak referans verilecek.
4. App target'a `CoreFoundation` paketi bağımlılık olarak eklenecek (Xcode UI'ından).
5. App'in build aldığı doğrulanacak, küçük bir smoke commit atılacak.

> Xcode 16+ workspace ve "Add Package Dependency → Add Local..." adımları manuel UI gerektiriyor; bu satırları Xcode'da senin tıklaman gerekecek. Diğer her şeyi (klasör yapısı, `Package.swift`, ilk dosya taşıma, README) ben hazırlayabilirim.
