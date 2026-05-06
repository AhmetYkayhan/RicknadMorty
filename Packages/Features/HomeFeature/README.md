# HomeFeature

Karakter listesi + detay + favoriler. `HomeFeatureInterface`'i implement eder; iki VIP-S sahnesi (`HomeList`, `CharacterDetail`) içerir ve favori state'i `FavoritesStore` üzerinden paylaşır.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar:
  - `HomeFeatureInterface` (sözleşme)
  - `AppCore` (hata + state)
  - `AppLogger`
  - `AppNetwork` (REST)
  - `DesignSystem`

## Public API

### Composition

| Tip | Tür | Amaç |
|---|---|---|
| `HomeFeatureAssembly` | final class | `HomeFeatureInterface`'i implement eder. `init(networkClient:logger:favoritesStore:delegate:)`, `makeHomeView() -> AnyView`, `makeHomeScene() -> HomeListView`, static `makeCharacterDetailFactory(favoritesStore:) -> CharacterDetailFactory` (composition root için) |
| `CharacterDetailFactory` | typealias | `@MainActor (HomeEntity) -> AnyView` — App shell tarafından bir kez üretilip Environment ile her tab'a inject edilir |
| `EnvironmentValues.characterDetailFactory` | extension | SwiftUI Environment üzerinden `CharacterDetailFactory?` (Profile + Settings de buradan tüketir) |

### Domain

| Tip | Tür | Amaç |
|---|---|---|
| `HomeEntity` | struct | Karakter domain modeli (`id`, `name`, `status`, `species`, `gender`, `origin`, `location`, `imageURL`) |
| `HomeEntity.Status` | enum | `alive` / `dead` / `unknown` |
| `GetHomeUseCaseProtocol` / `GetHomeUseCase` | protocol + final class | Karakter listesi sayfa sayfa çeker |

### Favorites

| Tip | Tür | Amaç |
|---|---|---|
| `FavoritesStoring` | `@MainActor` protocol (`AnyObject`) | Favorites read/write sözleşmesi. Interactor'lar bu protokole bağlanır (concrete `FavoritesStore`'a değil) |
| `FavoritesStore` | `@Observable` final class | `FavoritesStoring`'i implement eder. `UserDefaults` üzerinden persiste eder; persistence injectable |
| `FavoritesPersistence` | protocol | `load()` / `save(_:)` side-effect sözleşmesi |
| `UserDefaultsFavoritesPersistence` | final class | `FavoritesPersistence` default implementasyonu (`UserDefaults` enjekte edilebilir) |
| `InMemoryFavoritesStore` | final class | Test/preview için side-effect'siz `FavoritesStoring` |
| `EnvironmentValues.favoritesStore` | extension | SwiftUI Environment üzerinden **concrete** `FavoritesStore?` injection (observation tracking için concrete tip gerekir) |

### Presentation

| Tip | Tür | Amaç |
|---|---|---|
| `HomeListView`, `HomeListInteractor`, `HomeListPresenter` | VIP-S üçlüsü | Liste sahnesi |
| `HomeList` | enum (namespace) | `Request` / `Response` / `ViewState` |
| `CharacterDetailView`, `CharacterDetailInteractor`, `CharacterDetailPresenter` | VIP-S üçlüsü | Detay sahnesi |
| `CharacterDetail` | enum (namespace) | `Request` / `Response` / `ViewState` |

### Data

| Tip | Tür | Amaç |
|---|---|---|
| `CharacterDTO`, `LocationDTO` | struct (`Decodable`) | Wire formatları |
| `HomeMapper` | enum (namespace) | DTO → `HomeEntity` |

## Kullanım

```swift
import HomeFeature
import HomeFeatureInterface

let home: HomeFeatureInterface = HomeFeatureAssembly(
    networkClient: networkClient,
    logger: logger,
    favoritesStore: FavoritesStore(),
    delegate: appCoordinator
)

let homeView = home.makeHomeView()
```

## Test edilebilirlik

- `GetHomeUseCase` mock `HomeRepositoryProtocol` ile testlenir.
- `HomeListPresenter` saf dönüşüm; doğrudan test edilir.
- `HomeListInteractor` mock use-case + output ile testlenir.
- Concrete `HomeListView` `makeHomeScene()` ile snapshot test'e alınabilir.
- `FavoritesStore` UserDefaults'a yazıyor; testlerde **`UserDefaultsFavoritesPersistence(store: UserDefaults(suiteName:))` ile izolasyon** veya **`InMemoryFavoritesStore` ile sıfır side effect** kullanılır (8.E sonrası).

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `HomeFeature-<semver>`).

## Notlar

- Detay sahnesi artık SwiftUI Environment üzerinden `CharacterDetailFactory` closure'u olarak inject edilir; `*SceneFactory.shared` global state'i kalktı (8.F sonrası).
- Liste, Rick&Morty'nin `https://rickandmortyapi.com/api` endpoint'ini kullanır; REST host'u `HomeEndpoint`'te explicit override edilmiştir (8.A sonrası).
