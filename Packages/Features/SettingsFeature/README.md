# SettingsFeature

Settings ekranı + arama (Character / Episode / Location) + Episode/Location detayları + logout. `SettingsFeatureInterface`'i implement eder.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar:
  - `SettingsFeatureInterface`
  - `AppCore`, `AppLogger`, `AppNetwork`, `DesignSystem`
  - `HomeFeature` (search'te character sonuçları `HomeEntity` olarak döner; detay için `CharacterDetailSceneFactory` kullanılır)

## Public API

### Composition

| Tip | Tür | Amaç |
|---|---|---|
| `SettingsFeatureAssembly` | final class | `SettingsFeatureInterface`'i implement eder. `init(networkClient:logger:characterDetailFactory:delegate:)`, `makeSettingsView() -> AnyView`, `makeSettingsScene() -> SettingsView` |

> Not: `SearchResultsSceneFactory` sınıfı kaldırıldı; SearchResults sahnesi artık `SettingsFeatureAssembly.makeSettingsView()` içinde oluşturulup SwiftUI Environment ile `SettingsView`'e veriliyor (`searchResultsFactory`, internal closure).

### Domain

| Tip | Tür | Amaç |
|---|---|---|
| `SearchType` | enum | `character`, `episode`, `location` |
| `EpisodeEntity` | struct | Episode domain modeli |
| `LocationEntity` | struct | Location domain modeli |
| `SearchResultEntity` | enum | `character(HomeEntity)` / `episode(EpisodeEntity)` / `location(LocationEntity)` |
| `SearchUseCaseProtocol` / `SearchUseCase` | protocol + final class | Arama akışı |

### Presentation

| Tip | Tür | Amaç |
|---|---|---|
| `SettingsView`, `SettingsInteractor`, `SettingsPresenter` | VIP-S üçlüsü | Settings root sahnesi |
| `Settings` | enum (namespace) | `SearchParams`, `Request`, `Response`, `ViewState` |
| `SearchResultsView`, `SearchResultsInteractor`, `SearchResultsPresenter` | VIP-S üçlüsü | Search sonuç sahnesi |
| `SearchResults` | enum (namespace) | `Request` / `Response` / `ViewState` |
| `EpisodeDetailView` | struct (`View`) | Saf gösterim sahnesi (business logic yok) |
| `LocationDetailView` | struct (`View`) | Saf gösterim sahnesi |

## Kullanım

```swift
import SettingsFeature
import SettingsFeatureInterface

let settings: SettingsFeatureInterface = SettingsFeatureAssembly(
    networkClient: networkClient,
    logger: logger,
    delegate: appCoordinator
)

let settingsView = settings.makeSettingsView()
```

## Test edilebilirlik

- `SearchUseCase` mock `SearchRepositoryProtocol` ile testlenir.
- `SettingsPresenter` ve `SearchResultsPresenter` saf dönüşüm — doğrudan test edilir.
- Concrete `SettingsView` ve `SearchResultsView` `make*Scene()` ile snapshot test'e alınabilir.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `SettingsFeature-<semver>`).

## Notlar

- `HomeFeature`'a olan bağımlılık tasarım gereği: search'te character → CharacterDetail navigation'ı tek bir sahneye yöneliyor (DRY). Bu çapraz import composition root'u kurtarır.
- CharacterDetail sahnesi App shell'in tek bir `CharacterDetailFactory` closure'u olarak Environment'a inject ettiği yapı üzerinden kullanılır (8.F sonrası — `*SceneFactory.shared` yok).
