# SettingsFeature

Settings + arama (Character / Episode / Location) + episode/location detayları + logout. `SettingsFeatureInterface`'i implement eder.

VIP-S (Clean Swift for SwiftUI) iki sahne için uygulanır: `Settings` (kök) ve `SearchResults`. `EpisodeDetailView` ve `LocationDetailView` business logic içermediği için düz `View` olarak kalır.

Search'te character sonuçları `HomeFeature.HomeEntity` ile döner ve detay için `HomeFeature.CharacterDetailSceneFactory` kullanılır; bu yüzden paket `HomeFeature`'a bağımlıdır.
