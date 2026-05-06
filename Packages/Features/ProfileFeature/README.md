# ProfileFeature

Profile sekmesi: favori karakter sayısını ve listesini sunar. `ProfileFeatureInterface`'i implement eder.

## Genel bilgiler

- iOS 17+ / macOS 14+
- Swift 5.9
- Bağımlılıklar:
  - `ProfileFeatureInterface`
  - `AppCore`
  - `DesignSystem`
  - `HomeFeature` (favorileri okumak için `FavoritesStore` ve karakter modeli `HomeEntity`)

## Public API

### Composition

| Tip | Tür | Amaç |
|---|---|---|
| `ProfileFeatureAssembly` | final class | `ProfileFeatureInterface`'i implement eder. `init(favoritesStore:characterDetailFactory:delegate:)`, `makeProfileView() -> AnyView`, `makeProfileScene() -> ProfileView` |

> Not: `FavoriteCharactersSceneFactory` sınıfı kaldırıldı; favori liste sahnesi `ProfileFeatureAssembly.makeProfileView()` içinde oluşturulup SwiftUI Environment ile `ProfileView`'e veriliyor (`favoriteCharactersFactory`, internal closure).

### Presentation

| Tip | Tür | Amaç |
|---|---|---|
| `ProfileView`, `ProfileInteractor`, `ProfilePresenter` | VIP-S üçlüsü | Profile root sahnesi |
| `Profile` | enum (namespace) | `Request` / `Response` / `ViewState` |
| `FavoriteCharactersView`, `FavoriteCharactersInteractor`, `FavoriteCharactersPresenter` | VIP-S üçlüsü | Favori liste sahnesi |
| `FavoriteCharacters` | enum (namespace) | `Request` / `Response` / `ViewState` |

## Kullanım

```swift
import ProfileFeature
import ProfileFeatureInterface
import HomeFeature   // FavoritesStore için

let profile: ProfileFeatureInterface = ProfileFeatureAssembly(
    favoritesStore: favoritesStore,   // Shared FavoritesStore (composition root)
    delegate: appCoordinator
)

let profileView = profile.makeProfileView()
```

## Test edilebilirlik

- `ProfilePresenter` ve `FavoriteCharactersPresenter` saf dönüşüm — doğrudan test edilir.
- Interactor'lar `any FavoritesStoring` üzerinden çalışır; testlerde `InMemoryFavoritesStore` kullanılır (8.E sonrası — UserDefaults side effect yok).
- Concrete `ProfileView` ve `FavoriteCharactersView` `make*Scene()` ile snapshot test'e alınabilir.

## Sürüm

Başlangıç sürüm: `0.1.0` (monorepo, tag formatı `ProfileFeature-<semver>`).

## Notlar

- `HomeFeature` import'u (a) `HomeEntity` modeli, (b) `FavoritesStoring` protokolü ve (c) `CharacterDetailFactory` typealias'ı için kalır; concrete `FavoritesStore` veya kaldırılmış `*SceneFactory` sınıfına doğrudan bağımlı değildir. Karakter detayı navigation'ı App shell'in inject ettiği `CharacterDetailFactory` üzerindendir.
- `FavoriteCharactersSceneFactory.shared` global state'i 8.F'de Environment DI'a alınacaktır.
