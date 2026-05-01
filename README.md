# RicknadMorty

SwiftUI ile geliştirilmiş iOS uygulaması. Ana ekranda [Rick and Morty API](https://rickandmortyapi.com/) üzerinden karakter listesi alınır; kimlik doğrulama ise projede tanımlı ayrı bir REST tabanına (`Endpoint` uzantısındaki varsayılan `baseURL`) yönlendirilir.

## Gereksinimler

- Xcode (projede hedeflenen SDK: **iOS 26.2** — `RicknadMorty.xcodeproj` içindeki `IPHONEOS_DEPLOYMENT_TARGET` değeri)
- Apple geliştirici hesabı (cihaza yükleme / imzalama için)

## Projeyi çalıştırma

1. `RicknadMorty.xcodeproj` dosyasını Xcode ile açın.
2. Şema olarak **RicknadMorty** seçili olsun.
3. Simulator veya fiziksel cihazda **Run** (⌘R) ile derleyip çalıştırın.

## Mimari özeti

- **Özellik modülleri:** `AuthFeature` (giriş / token), `HomeFeature` (karakter listesi). Arayüz sözleşmeleri `*FeatureInterface` klasörlerinde.
- **Bileşim kökü:** `AppDependencyContainer` bağımlılıkları oluşturur ve modülleri bağlar (`NetworkClient`, `KeychainTokenStorage`, repository ve use case’ler).
- **Navigasyon:** `AppCoordinator` + `AppRoute` (ör. `login`, `home`, `characterDetail`, `settings`, `profile`).
- **Tasarım:** `DesignSystem` altında token’lar (`AppColors`, `AppSpacing`, …) ve ortak bileşenler (`AppButton`, `AppTextField`, `LoadingView`, `ErrorView`).
- **Ağ:** `CoreNetwork` — `Endpoint`, `RequestBuilder`, `NetworkClient`.
- **Ortak durum:** `Shared` içinde örneğin `ViewState`, `LoadableState`.

## API notları

| Alan | Taban adres |
|------|-------------|
| Karakterler (sayfalı liste) | `https://rickandmortyapi.com/api` (`HomeEndpoint`) |
| Kimlik doğrulama | Varsayılan `https://api.ricknadmorty.com/v1` (`Endpoint` protokolü uzantısı) |

Gerçek backend adresiniz farklıysa `Endpoint` uzantısındaki `baseURL` veya ilgili `*Endpoint` tiplerini güncelleyin.

## Paket kimliği

`yaso.RicknadMorty` (`PRODUCT_BUNDLE_IDENTIFIER`)

## Lisans

Bu depoda lisans dosyası yoksa, dağıtım ve kullanım koşullarını eklemek için proje sahibinin bir `LICENSE` dosyası eklemesi gerekir.
