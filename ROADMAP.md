# UIKit Senior Pattern Roadmap — Vaultly (örnek mini banka app'i)

## Proje Fikri
Gerçekçi bir mini banka/finans uygulaması: hesap listesi → işlem detayı → para transferi akışı.
Her faz, aynı uygulamaya bir senior-level pattern ekler. Sonunda elinde tek, tutarlı,
portfolyoda gösterilebilir bir app kalır — dağınık "demo repo"lar yerine.

Örnek proje adı: **Vaultly** (istersen değiştir, önemli olan gerçek bir ürün gibi görünmesi).

## Repo Stratejisi: Tek Repo, Faz Başına Branch/PR

**Neden tek repo:**
- Ayrı repo'lar ("UIKit-Coordinator", "UIKit-DI" vs.) GitHub profilinde dağınık durur,
  her biri izole bir egzersiz gibi görünür — pattern'lerin birlikte nasıl çalıştığını göstermez.
- Tek repo + branch/PR geçmişi, "bu pattern'i şu commit'te, şu sebeple ekledim" hikayesini
  doğrudan gösterir. Mülakatta ekrana git log açıp anlatmak çok daha etkili.
- Sonunda elinde tek, cilalı bir app kalır (CV/LinkedIn'de tek link paylaşırsın).

**Repo adı:** `Vaultly-iOS`

**Branch isimlendirme:** `pattern/<kebab-case>`
- `pattern/programmatic-ui`
- `pattern/diffable-datasource`
- `pattern/mvvm`
- `pattern/dependency-injection`
- `pattern/coordinator`
- `pattern/async-networking`
- `pattern/custom-transition`
- `pattern/unit-tests`

**PR başlık formatı:** `[Pattern] <İsim>: <kısa açıklama>`
Örnek: `[Pattern] Coordinator: Navigasyonu ViewController'lardan ayır`

PR açıklamasına 2-3 cümlelik bir **trade-off notu** ekle — "neden bu pattern, alternatifi neydi,
neden basit çözüm yetmedi/yetti". Bu notlar mülakatta doğrudan kullanılacak malzeme.

**Tag'ler (her faz bitince):** `v0.1-programmatic-ui`, `v0.2-diffable-datasource`, ...
`v1.0-final`. İstersen mülakatta "şu noktada sadece şu pattern'ler vardı" diye
belirli bir tag'e referans verebilirsin.

**main branch:** her zaman derlenen, çalışan bir durumda olsun. Her PR main'e merge
edilmeden önce app'in bozulmadığından emin ol.

## Kod Yorumu Kuralı
Kod içi yorumlar **Türkçe ve kısa** olsun (tek satır, "ne" değil "neden" odaklı) —
GitHub'da portfolyo olarak duracağı için endüstri standardına uysun. Roadmap ve PR
açıklamaları Türkçe kalabilir, bunlar senin çalışma notların.

---

## Fazlar

### Faz 1 — Programatik UI + Auto Layout
- **Branch:** `pattern/programmatic-ui`
- **Hedef:** Storyboard kullanmadan, hesap/işlem listesi ekranını NSLayoutConstraint ile kur.
- **Kabul kriterleri:** Tek ekran, statik/mock veriyle liste görünüyor, tüm layout kod ile.
- **Süre:** Kısa (1-2 oturum)

### Faz 2 — Compositional Layout + Diffable Data Source
- **Branch:** `pattern/diffable-datasource`
- **Hedef:** Listeyi `UICollectionViewCompositionalLayout` + `UICollectionViewDiffableDataSource` ile yeniden kur.
- **Kabul kriterleri:** Veri güncellemesi diffable snapshot ile animasyonlu çalışıyor.
- **Süre:** Orta (2-3 oturum)

### Faz 3 — MVVM'e Ayırma
- **Branch:** `pattern/mvvm`
- **Hedef:** İş mantığını ViewModel'e taşı, VC sadece binding yapsın (closure veya Combine).
- **Kabul kriterleri:** ViewController içinde iş mantığı/veri işleme kodu kalmamış olmalı.
- **Süre:** Kısa (1-2 oturum)

### Faz 4 — Protokol Tabanlı Dependency Injection
- **Branch:** `pattern/dependency-injection`
- **Hedef:** `TransactionServicing` protokolü tanımla, gerçek/mock implementasyonu initializer ile inject et.
- **Kabul kriterleri:** ViewModel, somut network sınıfını değil protokolü biliyor.
- **Süre:** Kısa (1 oturum)

### Faz 5 — Coordinator Pattern
- **Branch:** `pattern/coordinator`
- **Hedef:** Liste → detay → transfer onayı akışını `AppCoordinator`/`TransferCoordinator` yönetsin.
- **Kabul kriterleri:** ViewController'larda `present`/`push` çağrısı kalmamış, hepsi Coordinator'da.
- **Süre:** Orta (2-3 oturum)

### Faz 6 — Async/Await Networking + Durum Yönetimi
- **Branch:** `pattern/async-networking`
- **Hedef:** Mock servisi gerçek async/await networking ile değiştir, loading/error/empty state'leri ekle.
- **Kabul kriterleri:** Ağ hatası, boş liste ve yükleniyor durumları UI'da ayrı ayrı görünüyor.
- **Süre:** Orta (2-3 oturum)

### Faz 7 — Custom Transition
- **Branch:** `pattern/custom-transition`
- **Hedef:** Transfer onay ekranına geçişte `UIViewControllerAnimatedTransitioning` ile özel animasyon.
- **Kabul kriterleri:** Geçiş, standart push/present yerine özel bir animasyonla çalışıyor.
- **Süre:** Orta (2 oturum)

### Faz 8 — ViewModel Unit Testleri
- **Branch:** `pattern/unit-tests`
- **Hedef:** Faz 4'teki protokol sayesinde mock servisle ViewModel'i XCTest'te izole test et.
- **Kabul kriterleri:** En az 3-4 anlamlı test case (başarılı, hata, boş veri senaryoları).
- **Süre:** Kısa (1-2 oturum)

---

## Sonraki Adım
1. GitHub'da `Vaultly-iOS` reposunu oluştur, boş bir Xcode projesiyle main'e ilk commit'i at.
2. `pattern/programmatic-ui` branch'ini aç, Faz 1'i bitirince main'e PR aç.
3. README.md'ye bu fazların tablosunu koy, her satırı ilgili PR/tag'e linkle — bu sayfa
   mülakatta doğrudan gösterilecek sayfa olacak.
