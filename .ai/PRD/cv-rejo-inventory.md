# PRD — CV Rejo Inventory

**Dokumen ini adalah produk_initialization** — deskripsi produk, arsitektur, dan state aplikasi
yang di-_reconstruct_ dari codebase existing (read-only, tanpa modifikasi kode).

| Atribut                 | Nilai                                                       |
| ----------------------- | ----------------------------------------------------------- |
| Nama produk             | CV Rejo Inventory                                           |
| Package name            | `cv_rejo`                                                   |
| Platform                | Android (utama), iOS, Web, Desktop                          |
| Stack                   | Flutter `^3.8.1` (FVM-managed), Dart 3, GetX `^4.7.3`       |
| Versi aplikasi (UI)     | `9.0.0` (`AppInfo.version`)                                 |
| Label versi (watermark) | `v9.0.0` (`AppInfo.versionLabel`)                           |
| Build                   | `1`                                                         |
| Terakhir update         | `23 Sep 2026` (`AppInfo.updatedAt`)                         |
| Versi runtime           | `pubspec.yaml` → `1.0.0+1` _(drift — lihat §12.1)_          |
| API base URL            | `https://server3.andiglobalsoft.com/cvrejo/api/`            |
| Bahasa UI               | Bahasa Indonesia (nasional), dengan beberapa string Inggris |
| Lisensi                 | Proprietary — internal CV Rejo                              |
| Test coverage           | **0%** — tidak ada direktori `test/`                        |

---

## 1. Ringkasan Produk

**CV Rejo Inventory** adalah aplikasi mobile _field_ untuk operasional **gudang & distribusi
CV Rejo** — perusahaan dystribusi barang (BARANG JADI) yang menjalankan alur warehouse
_suhu ruang_ (tidak refrigerated) dari picking hingga pengantaran ke customer.

Aplikasi ini adalah **aplikasi operasional lapangan (line-of-business tool)**, bukan aplikasi
konsumen. Setiap pengguna adalah satu operator di satu titik proses dalam rantai pasok.
Aplikasi ini **tidakBMS** — ia adalah _front-end_ dari sebuah ERP/administration system yang
sudah ada, dan seluruh otoritas data (validasi stok, harga, authorization akhir) berada di
server.

### Masalah yang diselesaikan

Tanpa aplikasi ini, operasional gudang & armada berjalan di atas kertas/fotokopi WhatsApp:

- **Ruang picking** tidak tahu PO mana yang sudah diambil siapa → duplikasi(up claim) & bottleneck.
- **Checker/loader** tidak bisa bukti Kondisi barang tanpa foto → klaim sengketa tidak bisa dibuktikan.
- **Driver** tidak bisa bukti tiba, unload, serah terima, dan pembayaran → piutang & barang
  hilang tidak punya bukti.
- **Supervisor (loader)** tidak punya visibility real-time posisi driver di jalan.
- Semua pelaporan bergantung pada input manual di akhir hari.

### Solusi

Satu aplikasi yang meng-_digitize_ seluruh rantai proses dari **claim → scan → foto →
serah terima → pembayaran → handover**, dengan **relevans mandatory per tahap** sehingga
proses tidak bisa dilompati, dan seluruh jejak audit tersimpan di server dalam bentuk
foto + koordinat GPS + timestamp.

### Nilai utama

1. **Bukti-ituality-bersifat-wajib.** Hampir semua endpoint multipart mewajibkan minimal satu foto.
   Proses tidak bisa diselesaikan tanpa bukti visual.
2. **Lokasi wajib pada tahap operasional.** `lat`/`long` dikirim pada hampir semua POST driver.
3. **Satu akun = satu peran = satu alur.** Tidak ada menu yang tidak relevan ditampilkan.
4. **Berjalan di jaringan buruk.** Unlock dengan indikator koneksi (`online / weak / offline`)
   dan pesan error berbahasa Indonesia yang bisa dipahami operator.

---

## 2. Pengguna Sasaran & Peran

Sistem memiliki **4 peran operasional** yang menentukan seluruh navigasi dan endpoint.

| Peran API (`access`) | Enum               | Alias kode           | Label UI  | Peran bisnis                                          | Perangkat     |
| -------------------- | ------------------ | -------------------- | --------- | ----------------------------------------------------- | ------------- |
| `picking`            | `UserRole.picking` | `AppRole.isPIC`      | "Picking" | **PIC / tim Picking** —ambil & susun barang di rak    | Handheld / HP |
| `packing`            | `UserRole.packing` | `AppRole.isChecker1` | "Packing" | **Checker 1** —packing/verifikasi isi paket           | Handheld / HP |
| `loader`             | `UserRole.loader`  | `AppRole.isChecker2` | "Loader"  | **Checker 2 / Leader** — muat ke armada + supervisory | HP + tablet   |
| `deliver`            | `UserRole.deliver` | `AppRole.isDriver`   | "Deliver" | **Driver** —angkut, antar, serah terima, pembayaran   | HP            |

### Peran turunan (backend-driven, bukan enum lokal)

| Peran wire      | Kapan aktif                                                 | Alasan                                                     |
| --------------- | ----------------------------------------------------------- | ---------------------------------------------------------- |
| `check2`        | `role == 'loader' && statusChecker2 != 'completed'`         | Loaderuru belum selesai → masih berperan sebagai Checker 2 |
| `delivery`      | `role == 'deliver'` pada endpoint `*/cancel` & `*/complete` | Remap khusus driver                                        |
| `deliverynew/*` | Driver, seluruh endpoint                                    | Namespace API khusus driver                                |

> **Aturan kritis:** `SessionManager._parseRole` memakai
> `orElse: () => UserRole.picking`. Role yang tidak dikenal (termasuk string placeholder `'-'`)
> **diam-diam menjadi `picking`**. Operator dapat melihat halaman yang salah — bukan error.

---

## 3. Alur Utama (Happy Path)

### 3.1 Alur Picking → Packing → Loading

```
Splash → cek token lokal → Home
  └─ Card "Total Pesanan" / routeTo()
       └─ List Order (/list-order)
            ├─ [RIT] pilih RIT  (list_rit_view)
            │     └─ "Pilih RIT" → InputAssistantDialog (assign driver/kenek/kendaraan)
            │           └─ PUT {role}/tugas
            └─ [PO] list PO per RIT (list_order_view)
                  └─ Tap PO → Detail Order (/detail-order)
                        └─ "Mulai" → PUT {role}/claim
                              └─ "Scan Produk" → Scan Product (/scan-product)
                                    ├─ barcode → dialog qty + foto → POST {role}/scan/multiple
                                    └─ (atau pilih manual via checkbox + foto)
                              └─ "Lanjut" → Ending Order (/ending-order)
                                    └─ Keterangan + foto barang → POST {role}/complete
```

### 3.2 Alur Driver (paling kompleks)

```
Home [driver tabs: Home | Retur | Kendala | Pesanan | Profil]
 └─ Ambil RIT (list_order, pageIndex 0) → claim RIT + assign armada
      └─ RIT Information (/rit-information)  — 3 halaman (PageView)
           ├─ page 0: RitView — daftar PO dalam RIT (reorderable)
           │     ├─ "Terima" → acceptRit()  (lokal, tulis GetStorage)
           │     ├─ "Tolak"  → deliverynew/trouble (jenis_trouble = tolak)
           │     └─ tap PO → Detail Order
           │            └─ "Ambil" → POST deliverynew/claiminvoice
           │                 ├─ [Scan] → deliverynew/scan1
           │                 ├─ [Berangkat] → Ending Order → deliverynew/finishscan
           │                 └─ [Sampai] → DriverArrive (2 fase)
           │                      fase 1 → deliverynew/delivery   (foto Armada + Toko)
           │                      fase 2 → deliverynew/unload    (foto semua barang)
           │                              → deliverynew/confirmdelivery (serah terima)
           │                              → deliverynew/payment   (jenis & nominal bayar)
           ├─ page 1: InputImageView — foto keberangkatan
           │     └─ "Simpan" → deliverynew/reporttruck1
           │           (4 sisi kendaraan + KM + tangki/segel + SJ + uangROUGHcash)
           └─ page 2: ArriveAtOffice — handover di kantor
                 └─ "Simpan" → deliverynew/handover
                       (+ nama penerima, bukti transfer, kotak berkas)
```

### 3.3 Alur Retur (Returns)

Dua alur berbeda dengan endpoint berbeda:

| Alur                    | Entry                                    | Invoice       | Endpoint                                                    | Keterangan                                                                 |
| ----------------------- | ---------------------------------------- | ------------- | ----------------------------------------------------------- | -------------------------------------------------------------------------- |
| **Retur vk terkait**    | RIT page → "Retur"                       | Ya (per PO)   | `retur/checktransaction` (GET) + `retur/submitretur` (POST) | Retur per item dengan `data_retur` JSON,\_alasan per barang, foto per item |
| **Retur tidak terkait** | Home tab "Retur" ("Retur Tidak Terkait") | **Tidak ada** | — (tidak ada submit)                                        | ⚠️ Form ada tapi **tidak pernah persist** (lihat §12.6)                    |

---

## 4. Struktur Informasi (Information Architecture)

### 4.1 Peta Route

| Route                | Path                  | Binding                   | Entry                             |
| -------------------- | --------------------- | ------------------------- | --------------------------------- |
| `SPLASH`             | `/splash`             | `SplashBinding`           | `AppPages.INITIAL`                |
| `LOGIN`              | `/login`              | `LoginBinding`            | Dari splash / logout              |
| `HOME`               | `/home`               | `HomeBinding`             | Dari splash (ada token)           |
| `LIST_ORDER`         | `/list-order`         | `ListOrderBinding`        | Dari home / detail                |
| `DETAIL_ORDER`       | `/detail-order`       | `DetailOrderBinding`      | Dari list / RIT                   |
| `SCAN_PRODUCT`       | `/scan-product`       | `ScanProductBinding`      | Dari detail order                 |
| `ENDING_ORDER`       | `/ending-order`       | `EndingOrderBinding`      | Dari detail order                 |
| `LIST_HISTORY_ORDER` | `/list-history-order` | `ListHistoryOrderBinding` | Dari home card "History"          |
| `RIT_INFORMATION`    | `/rit-information`    | `RitBinding`              | Dari list (driver) / ending order |

### 4.2 Bottom Navigation (role-aware)

`CustomButton.bottomBarIcon()` — item list bersifat dinamis:

| #    | Item         | Visibility            |
| ---- | ------------ | --------------------- |
| 0    | **Home**     | semua role            |
| 1    | **Tracking** | `isChecker2` (loader) |
| 1    | **Retur**    | `isDriver`            |
| 2    | **Kendala**  | `isDriver`            |
| 3    | **Pesanan**  | `isDriver`            |
| last | **Profil**   | semua role            |

`HomePage` berisi `PageView` dengan `NeverScrollableScrollPhysics`, daftar anak:
`[HomeView, <role-specific>, …, ProfileView]`. **Index nav_bottom = indeks page.**

### 4.3 Hierarki Fitur (Clean Architecture per feature)

Setiap feature di `lib/features/<name>/` mengikuti 4 layer wajib:

```
lib/features/<name>/
├── data/
│   ├── datasource/     <name>_remote_datasource.dart (+ _impl)
│   ├── models/         response_model_*.dart
│   └── repositories/   <name>_repository_impl.dart
├── domain/
│   ├── entities/       *entity.dart          (plain, extends Equatable-ish)
│   ├── params/         *_param.dart          (request payload objects)
│   ├── repositories/   <name>_repository.dart (abstract)
│   └── usecases/       <name>_usecase.dart
└── presentation/
    ├── bindings/       <name>_binding.dart   (GetX lazyPut)
    ├── controllers/    *_controller.dart     (GetxController, Rx state)
    ├── views/          *_view.dart           (GetView<TController>)
    └── widgets/        buttons/ dialog/ content/ …
```

---

## 5. Arsitektur Teknis

### 5.1 State Management: GetX

`GetMaterialApp` dengan `GetX` sebagai satu-satunya state container.

| Pola                 | Contoh                                                                                           |
| -------------------- | ------------------------------------------------------------------------------------------------ |
| Reactive state       | `final isLoading = false.obs;` (`RxBool`)                                                        |
| Reactive list        | `final orders = <OrderEntity>[].obs;` (`RxList`)                                                 |
| Reactive text        | `final rit = ''.obs;` (`RxString`)                                                               |
| Side-effect          | `Get.toNamed()`, `Get.bottomSheet()`, `Get.dialog()`, `Get.defaultDialog()`, `Get.offAllNamed()` |
| Dependency injection | `Get.lazyPut<T>(() => Impl(Get.find()), fenix: true)`                                            |
| Role access          | `AppRole.isPIC` / `isChecker1` / `isChecker2` / `isDriver` (static facade)                       |
| Navigator            | `Get.find<T>()` — controller bertahan hidup antar route (`fenix: true`)                          |

**Tiga direktori `SessionManager`:**

- `FlutterSecureStorage` → `ACCESS_TOKEN`, `REFRESH_TOKEN` (via `TokenStorage`)
- `GetStorage` key `'user'` → JSON string user
- `GetStorage` key `'user_role'` (enum name) + `'user_name'`

### 5.2 Arsitektur Data: Clean Architecture + Dio

```
Controller (presentation)
    ↓
UseCase (domain)          — tipis: forward ke Repository
    ↓
Repository (domain iface + data impl)
    ↓
RemoteDataSource (data)   — mapping params → endpoint + body
    ↓
DioClient (core)          — base URL, timeout, header, interceptor chain
    ↓
DioInterceptor (core)     — Authorization header, 401 refresh
    ↓
HTTP → https://server3.andiglobalsoft.com/cvrejo/api/
```

**`ResultCustom<Failure, T>`** — sealed result pattern:

```dart
sealed class ResultCustom<Failure, T> { const ResultCustom(); }
class Success<Failure, T>      extends ResultCustom { final T data; final String? failure; }
class ErrorResult<Failure, T>  extends ResultCustom { final String message; final int? statusCode; final bool? isMaxFailure; }
```

Controller melakukan pattern matching:

```dart
switch (result) {
  case Success(:final data):        _handleSuccess(data);
  case ErrorResult(:final message): showError(message);
}
```

> **Catatan:** `Failure` di generic parameter tidak pernah diisi — repo selalu return
> `ErrorResult<Failure, T>(message: String)`. `mapper_exceptions.dart` yang seharusnya
> memetakan Exception → Failure adalah **dead code**.

### 5.3 Dependency Injection Graph

`InitialBinding.dependencies()` menjalankan 4 fase:

```
1. _injectioDefault()   → KoneksiCheck, FlutterSecureStorage, TokenStorage, DioClient,
                          DialogService, ContactService, SessionManager, CameraControllerService
2. injectionUsecase()   → 8 use case
3. injectionDataSource()→ 8 remote data source
4. injectionRepository()→ 8 repository
```

Semua `lazyPut` + `fenix: true` (32 registration), kecuali `KoneksiCheck` yang
`Get.put(..., permanent: true)` (eager). Feature-scoped: `CacheService` + 8 home controller
di-register per-route di `HomeBinding`.

### 5.4 Network Layer

**`DioClient`** — `baseUrl`, timeout 30s, header JSON. Intercept chain:

| #   | Interceptor                 | Fungsi                                                                                  |
| --- | --------------------------- | --------------------------------------------------------------------------------------- |
| 1   | `QueuedInterceptorsWrapper` | Gate offline (`ConnectionStatus.offline` → reject), rewrite error jadi string Indonesia |
| 2   | `DioInterceptor`            | Inject `Authorization: Bearer <token>`, retry logic 401                                 |
| 3   | `LogInterceptor`            | Log request/response body (⚠️ termasuk token)                                           |

**`DioInterceptor` 401 flow (single-flight):**

```
onError (401)
  ├─ sudah refresh? → queue di Completer → tunggu → retry
  ├─ belum + refreshToken == null → _handleLogout (⚠️ no-op, tidak navigasi)
  └─ belum + ada token
       → POST auth/refresh {refresh_token: ...}  (tanpa Authorization lama)
       → simpan access_token + refresh_token baru
       → resolve semua completer
       → dio.fetch(requestOptions) dengan extra["isRetry"] = true
```

**`KoneksiCheck`** — monitor koneksi via `connectivity_plus` + ping ke
`https://1.1.1.1/cdn-cgi/trace` setiap **8 detik** (timer permanen selama app hidup).
Status: `online` (<800ms) / `weak` (≥800ms) / `offline`.

**`ConnectionBanner`** — banner di bawah app: merah `Tidak ada koneksi internet` /
orange `Koneksi lemah / tidak stabil` / hidden saat online.

### 5.5 Multipart Upload

Excension `XFileMultipartExtension.multipart` dan `MultipartHelper.fromNullableXFile` membuat
`MultipartFile.fromFile(path, filename: basename(path))`. Threshold umum: **2 foto**
(`foto1`, `foto2`).

### 5.6 Storage Keys (GetStorage)

| Key                  | Ditulis oleh                            | Dibaca oleh                        |
| -------------------- | --------------------------------------- | ---------------------------------- |
| `user`               | `LoginController`                       | —                                  |
| `user_role`          | `SessionManager`                        | `SessionManager`                   |
| `user_name`          | `SessionManager`                        | `SessionManager`                   |
| `noInvoice`          | `startingPO`, `takeItTransactionDriver` | `routeTo`, splash, logout          |
| `city` (nama RIT)    | `takeItRIT`, `acceptRit`, `changeRit`   | list order, RIT, home              |
| `colorRit`           | `takeItRIT`, `acceptRit`                | list order, RIT, home              |
| `tanggalRit`         | `takeItRIT`, `acceptRit`                | list order, RIT, home              |
| `routeRit`           | `takeItRIT`, `acceptRit`                | list order, RIT, home              |
| `isRitToday`         | `routeTo`, `takeItRIT`, `acceptRit`     | list order, RIT, home              |
| `isAcceptRIT`        | `acceptRit`                             | `rit_page` back logic              |
| `isTakeToTheRoad`    | `ButtonDetailOrderWidget`               | `DetailOrderController.onInit`     |
| `status_driver`      | `ButtonDetailOrderWidget`               | `routeTo`, `DetailOrderController` |
| `status_checker2`    | `startingPO`                            | `routeTo`                          |
| `buttonRIT`          | `acceptRit`, `saveOrder`, `cancelRIT`   | `RitController.onReady`            |
| `buttonEndingDriver` | `saveArriveDriver`                      | `EndingOrderController.onInit`     |
| `resetDate`          | `SplashController`                      | `SplashController`                 |

---

## 6. Desain Sistem (Design System)

### 6.1 Font

- **Flutter `TextTheme`** (via `AppTheme`): `fontFamily: 'Inter'`, `useMaterial3: true`
- **`TextStyles`** (via `GoogleFonts.inter()`): skala lengkap (display → overline)
- **Login view**: `GoogleFonts.plusJakartaSans()`
- Fallback inconsistent di beberapa widget.

### 6.2 Palet Warna Inti

| Token                  | Nilai                                    | Usage                                 |
| ---------------------- | ---------------------------------------- | ------------------------------------- |
| Green success / action | `#2ED471`                                | tombol utama, badge aktif             |
| Green bright           | `#06823f`                                | bottom-nav selected, header text      |
| Green light bg         | `#D1FAE5` / `#E8F7F0`                    | icon container                        |
| Green dark             | `#10B981` / `#28A745`                    | `AppColors.primaryGreen`, icon status |
| Tan/gold (cancel)      | `#C7A16D`                                | tombol sekunder, filter chip selected |
| Brown/accent           | `#D5914D` / `#D68F4D`                    | tombol "Lihat PO", "Kendaraan"        |
| Blue                   | `#255BF0` / `#0056D2`                    | tombol "Lanjut" / "Simpan"            |
| Pink                   | `#FF51BD`                                | FAB search, loading spinner           |
| Red destructive        | `#DC2626` / `#EF4444` / `redAccent[100]` | hapus, logout, batal                  |
| Orange                 | `#EA580C` / `#FA913C`                    | warning, prefix icon                  |
| Border card            | `#D7C3B4`                                | border card PO                        |
| Border form            | `#E2E8F8`                                | border field                          |
| Field fill             | `#F0F3FF`                                | field read-only, info card            |
| Bg home (mint)         | `#F1F8F1`                                | `AppColors.backgroundMint`            |
| Bg home (purple)       | `#F5F0FA`                                | driver / packing                      |
| Bg profile             | `#F7F7F7`                                |                                       |

### 6.3 Komponen Kustom

| Komponen                              | Fungsi                                                                         |
| ------------------------------------- | ------------------------------------------------------------------------------ |
| `CustomButton.basicButton`            | `ElevatedButton` radius 10, 14/w600, white text                                |
| `CustomButton.basicOutlinedButton`    | `OutlinedButton` radius 10                                                     |
| `CustomButton.doubleButton`           | Row 2 tombol (`visible1`, `visible2`, `visibleSpace`)                          |
| `CustomButton.bottomBarStyle`         | Container putih + shadow untuk bottom bar                                      |
| `CustomButton.bottomBarIcon`          | `BottomNavigationBar` role-aware                                               |
| `CustomCardList`                      | Card PO/transaksi dengan status badge, maps, checkbox, nomor RIT               |
| `CustomSearchField`                   | Wrapper `CupertinoSearchTextField`                                             |
| `CustomImage`                         | Upload foto (grid 4 kolom, `DottedBorder` + tile kamera, `maxImage` default 2) |
| `CustomGridImage`                     | `GridView` 4 kolom foto + tombol tambah                                        |
| `CameraScreen`                        | Kamera fullscreen dengan shutter & toggle flash (off ↔ torch)                  |
| `SharedTextField`                     | `TextFormField` wrapper, `autovalidateMode: onUserInteraction`                 |
| `BoxStatus.buildText` / `.buildColor` | Status badge per role                                                          |
| `SharedHeaderPopup`                   | Header bottom sheet dengan tombol close                                        |
| `SortWidget`                          | Bottom sheet filter: tanggal, urut, status, RIT                                |
| `ScannerOverlay`                      | `CustomPainter` overlay lubang scan + border putih                             |
| `LoadingView`                         | `hexagonDots` pink `#FF51BD`                                                   |
| `WatermarkOverlay`                    | Teks versi di tengah bawah (15% opacity)                                       |

### 6.4 Typography Scale (`TextStyles`)

Display 57/45/36, Headline 32/28/24, Title 22/16/14, Body 16/14/12, Label 14/12/11.
`basicTextStyle()` default 13px `w400` `#171717`.

### 6.5 Dark Mode

`AppTheme.dark` **terdefinisi** tapi tidak pernah dipakai — `AppInitializer` return
`ThemeMode.light` hard-coded. Hanya ada 6 slot `TextTheme` yang di-set; sisanya fallback
Flutter default.

---

## 7. Alur Layar Detail

### 7.1 Splash (`/splash`)

- Logo di tengah (216px).
- Delay **2 detik** (`Future.delayed`).
- Cek session: `TokenStorage.getAccessToken()` — lokal saja, tanpa network validation.
- **Daily rollover**: jika `GetStorage('resetDate') != hari ini`, clear 5 key kerja
  (`noInvoice`, `user`, `city`, `colorRit`, `tanggalRit`) tapi **pertahankan user**.
- Ada token → `Get.offAllNamed('/home')`; tidak → clear storage + `Get.offAllNamed('/login')`.

### 7.2 Login (`/login`)

- Logo 150×150, judul "Silakan Masuk" / "Tracking Inventory".
- Field **Username** (validator `^[a-zA-Z0-9_]{3,20}$`, keyboard email) + **Kata Sandi**
  (required, toggle show/hide).
- `POST auth/login` body `{ "username": ..., "password": ... }`.
- Sukses: simpan token (access = refresh = token yang sama), simpan user ke GetStorage,
  set role via `AppRole.loginFromApi`, `Get.offAllNamed('/home')`.

### 7.3 Home (`/home`)

Header bg per role (`bgPickingMan`/`bgPackingMan`/`bgDriver`):
`"Hi, {name} 👋"` + `"Semangat {role} hari ini!"`.

**3 kartu ringkasan:**

| #   | Judul           | Nilai               | Sub              | Action                     |
| --- | --------------- | ------------------- | ---------------- | -------------------------- |
| 1   | Total Pesanan   | `total_row_trans`   | Sedang Berjalan  | `routeTo()`                |
| 2   | Total Pesanan   | `-` (isPast)        | Pesanan Lampau   | `routeTo(ritToday: false)` |
| 3   | History Pesanan | `total_row_history` | Telah dikerjakan | → `/list-history-order`    |

**Tab "Pesanan Dikerjakan"** — ⚠️ **selalu kosong** (`getOrder()` di-comment di
`HomeController._initializeAllData()`), `onTap` → snackbar "Coming Soon".

**Sub-tab (per role):**

- **loader** → `HomeTrackingDriverView` (Tracking Driver, filter/sort/search, infinite scroll, read-only)
- **driver** → `HomeReturDriverView` (Retur Tidak Terkait) / `RitConstraint` (Kendala) / `TakeItOrderView` (Pesanan)

### 7.4 List Order (`/list-order`)

Dua mode dalam satu halaman (`pageIndex`: 0=RIT, 1=PO):

- **Mode RIT** (`list_rit_view`): card RIT dengan `NOMOR RIT`, tanggal, total PO, PO berjalan
  (role-dependent counter), rute. "Lihat PO" (PIC/loader) → `DetailRITDialog` (bottom list
  PO per RIT, paginated). "Pilih RIT" (bottom bar) → `InputAssistantDialog`.
- **Mode PO** (`list_order_view`): `CustomCardList` per PO, search (bukan PIC), filter bottom
  sheet (`sort_widget`), pagination `limit=10` + infinite scroll (threshold 200px).
- **Bottom bar (role-dependent):** `Batal`/`Ambil RIT` (seleksi) | `Pilih RIT` | `Ubah RIT` |
  `Pending RIT` (buka `input_pending_dialog`).

### 7.5 Detail Order (`/detail-order`)

Kartu: **Status Pesanan** (loader) → **ID Transaksi** → **Status Armada** → warning armada
external → **Info Customer** (nama, telepon*, tanggal, kota, alamat*, catatan) →
**Info Order** (tabel produk) → **Foto Semua Produk** (history only).

_\*hanya driver + `statusDriver == 'completed'`_

**Tabel produk (role-dependent kolom):**

| Role     | Kolom 1 | Kolom 2            | Qty             | Checkbox              |
| -------- | ------- | ------------------ | --------------- | --------------------- |
| PIC      | barcode | `Lokasi: {lokasi}` | `pic.qty / qty` | —                     |
| Checker1 | barcode | `Warna: {warna}`   | `checker1.qty`  | —                     |
| Checker2 | barcode | `Warna: {warna}`   | `pic.qty / qty` | ✓ (dengan select-all) |
| Driver   | item    | `Warna: {warna}`   | `pic.qty / qty` | ✓ (dengan select-all) |

Checkbox: one-way (tidak bisa un-tick), hidden jika `status_checker2 == completed` atau
dari history.

**Bottom bar:** single "Ambil"/"Mulai" (status `available`) atau double
["Scan Produk" | "Lanjut"] (status `ongoing`). Driver completed → ["Berangkat" | "Sampai"].

### 7.6 Scan Product (`/scan-product`)

- `MobileScanner` (EAN13/EAN8/UPC-A/UPC-E/Code128, back camera, 1280×720).
- Scan window 350×150px (offset -100 dari tengah), overlay `CustomPainter` dengan lubang.
- AppBar: back, **flash** toggle, **Pesanan** button (≠ loader, buka `open_order_dialog`
  read-only qty list), **FAB search** (≠ loader).
- Barcode detect → stop scanner → `getProduct(barcode)` → `openInputQtyDialog`.
- Dialog qty: nama barang (read-only), **JUMLAH** (read-only dari scan), **Barang** (foto, max 2).
  Tombol: `Batal`/`Tambah` atau `Ulangi`/`Kembali` (post-error) atau
  `Kembali`/`Hubungi Admin` (max failure untuk Checker1).

### 7.7 Ending Order (`/ending-order`)

**Non-driver:** Keterangan (textarea) + Barang (foto, max 2) → `Simpan PO` →
`POST {role}/complete`. `Pending PO` → `POST {role}/cancel` (multipart dengan foto).

**Driver completed → `DriverArrive` (2 fase):**

- Fase 1: **Armada Sampai** (1 foto) + **Toko** (1 foto) → `deliverynew/delivery`.
- Fase 2: **Informasi Item** (foto all item, max 2) + **Serah Terima Invoice/SJ** (dropdown
  Lunas/Belum Lunas, 1 foto) + **Jenis Pembayaran** (dropdown Tunai/Transfer/Giro/Cek/Debit,
  nominal + bukti) → 3 API sequential (`unload` → `confirmdelivery` → `payment`).

### 7.8 RIT Information (`/rit-information`)

3 halaman dalam `PageView(NeverScrollable)`:

| Page | View             | Konten                                                                                                 |
| ---- | ---------------- | ------------------------------------------------------------------------------------------------------ |
| 0    | `RitView`        | daftar PO (reorderable), tombol Terima/Tolak/Keberangkatan/Sampai Kantor/Retur                         |
| 1    | `InputImageView` | foto 4 sisi kendaraan + KM + tangki/segel + SJ + uang cash                                             |
| 2    | `ArriveAtOffice` | nama penerima + KM + kendaraan + tangki + invoice/SJ + bukti transfer + penggunaan uang + kotak berkas |

State machine `buttonRIT` (Enum `EnumButtonRIT`):
`acceptRIT → buttonTakeOff → buttonArriveRIT → buttonSaveDoc` (dan `cancelRIT`).

### 7.9 History Order (`/list-history-order`)

Infinite scroll `transaction/history/get?limit=10&page=N&q=&sort=&district=`.
Card `CustomCardList(isHistory: true)`, tap → Detail Order dengan `isFromHistory = true`
(tambah section "Foto Semua Produk", checkbox & bottom bar hidden).

### 7.10 Profile

- Avatar (logo) + nama + badge role.
- Kartu VERSION (`AppInfo.version`) + UPDATED (`AppInfo.updatedAt`).
- 5 aksi: **Hubungi Admin** (WhatsApp), **Syarat & Ketentuan**, **Kebijakan Privasi**,
  **Hapus Cache** (tampil ukuran cache via `CacheService`), **Logout** (confirm dialog).
- ⚠️ Binding/controller/domain/data profile = **dead code** (lihat §12.2).

---

## 8. Kontrak API (Backend)

### 8.1 Auth

| Method | Endpoint       | Body                   | Response                                                                                 |
| ------ | -------------- | ---------------------- | ---------------------------------------------------------------------------------------- |
| `POST` | `auth/login`   | `{username, password}` | `{code, message, error, data: {user_id, name, username, access, notelp, alamat, token}}` |
| `POST` | `auth/refresh` | `{refresh_token}`      | `{access_token, refresh_token}`                                                          |
| `POST` | `auth/logout`  | —                      | — (⚠️ tidak pernah dipanggil)                                                            |

**Role mapping:** `data.access` → `UserRole` via case-insensitive name match.
`'picking' | 'packing' | 'loader' | 'deliver'`, default `picking`.

### 8.2 Transaction & RIT (umum)

| Method | Endpoint                   | Params                                                      | Response                                                        |
| ------ | -------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------- |
| `GET`  | `main/getinfo`             | —                                                           | `{status, message, data: {total_row_trans, total_row_history}}` |
| `GET`  | `transaction/all`          | `limit, page, q, sort, filter, district, date_rit, courier` | `{data: {content: [OrderEntity]}}`                              |
| `GET`  | `transaction/past`         | `… , daterit` (⚠️ tanpa underscore)                         | idem                                                            |
| `GET`  | `transaction/history/get`  | `limit, page, q, sort, district`                            | `{data: {content: [OrderEntity]}}`                              |
| `GET`  | `transaction/leader/get`   | `…` (loader tracking)                                       | idem                                                            |
| `GET`  | `transaction/get?invoice=` | `invoice`                                                   | `{status, message, data: {DetailOrderEntity}}`                  |
| `GET`  | `rit/getrit`               | `search` (opsional)                                         | `{data: {content: [RitListEntity]}}`                            |
| `GET`  | `rit/pastrit`              | `date`                                                      | idem                                                            |
| `GET`  | `city/getcity`             | —                                                           | `{data: {content: [{city}]}}`                                   |
| `GET`  | `user/getpicking`          | —                                                           | `{data: {content: [UserModel]}}`                                |
| `GET`  | `vehicle/getloader?q=`     | `q`                                                         | `{data: {content: [TransportationEntity]}}`                     |
| `GET`  | `vehicle/gettruck?q=`      | `q`                                                         | idem                                                            |

### 8.3 Endpoint role-generic (claim / complete / scan / cancel)

| Method | Endpoint                   | HTTP                                                                                                        | Guna                                    |
| ------ | -------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `PUT`  | `{role}/claim`             | PUT `{invoice}`                                                                                             | Ambil PO (non-driver)                   |
| `POST` | `deliverynew/claiminvoice` | POST form-urlencoded `{invoice}`                                                                            | Ambil PO (driver)                       |
| `PUT`  | `{role}/claimcoba`         | —                                                                                                           | ⚠️ **didefinisikan tapi tidak dipakai** |
| `PUT`  | `{role}/tugas`             | PUT `{district, id_driver, id_kenek, date_rit, [id_loader \| id_mobil, status_armada]}`                     | Ambil RIT + assign                      |
| `POST` | `{role}/scan/multiple`     | POST multipart `{barcode, invoice, qty, foto1, foto2}`                                                      | Simpan hasil scan                       |
| `POST` | `{role}/complete`          | POST multipart `{invoice, desc, status_armada, driver_external, mobil_external, lat, long, [file3, file4]}` | Selesaikan PO                           |
| `POST` | `{role}/cancel`            | POST multipart `{invoice, desc, foto1, foto2}`                                                              | Pending / batal                         |

### 8.4 Endpoint Driver (`deliverynew/*`)

| Method | Endpoint                      | HTTP | Body (multipart)                                                                                                                                                                                  |
| ------ | ----------------------------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `POST` | `deliverynew/scan1`           | POST | `{barcode, invoice, qty, foto1, foto2}`                                                                                                                                                           |
| `POST` | `deliverynew/reporttruck1`    | POST | `{nama_penerima, rit, tanggal_rit, km, foto_km, foto_truck_depan, foto_truck_kiri, foto_truck_kanan, foto_truck_belakang, foto_truck_overall, foto_truck_tangki, foto_truck_sj, foto_truck_uang}` |
| `POST` | `deliverynew/trouble`         | POST | `{no_rit, tanggal_rit, [invoice], desc, jenis_trouble, lat, long, file1, file2}`                                                                                                                  |
| `POST` | `deliverynew/finishscan`      | POST | `{invoice, desc, status_armada, driver_external, mobil_external, lat, long, gudang, file1, file2}`                                                                                                |
| `POST` | `deliverynew/delivery`        | POST | `{invoice, desc, lat, long, file1, file2}`                                                                                                                                                        |
| `POST` | `deliverynew/unload`          | POST | `{invoice, desc, lat, long, file1, file2}`                                                                                                                                                        |
| `POST` | `deliverynew/confirmdelivery` | POST | `{invoice, desc, lat, long, file1, file2}`                                                                                                                                                        |
| `POST` | `deliverynew/payment`         | POST | `{invoice, desc, lat, long, payment_type, payment_nominal, file1, file2}`                                                                                                                         |
| `POST` | `deliverynew/handover`        | POST | `reporttruck1 fields + foto_bukti_tf, foto_kotak_berkas`                                                                                                                                          |

### 8.5 Endpoint Retur

| Method | Endpoint                          | Body                                                                                                      |
| ------ | --------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `GET`  | `retur/checktransaction?invoice=` | —                                                                                                         |
| `POST` | `retur/submitretur`               | multipart `{invoice, keterangan, data_retur: JSON, foto1, foto2}`                                         |
| —      |                                   | `data_retur[]`: `{idtransaksi_detail, iditem, jumlah_item, harga_satuan, alasan_perbarang, foto1, foto2}` |

### 8.6 Key Response Entities

**`OrderEntity`** — `invoice`, `order_no`, `surat_jalan`, `customer`, `district`, `dates`/`date`,
`courier`, `pic`/`checker1`/`checker2`/`loader`/`driver` (semua `Status?`),
`drop_address`, `phone`, `route`/`router`, `maps`, `jenis_armada`, `isSelected`.

**`Status`** — `status`, `date`, `desc`, `by`, `statusscandriver`, `statusacceptedbycustomer`,
`statusdelivcancel`.

**`RitListEntity`** — `city` (= nomor RIT), `total_po`, `tanggal_rit`, `color`, `route` (`rute`),
`po_pending_*` / `po_done_*` untuk 5 tahap.

**`DetailOrderEntity`** — `invoice`, `order_no`, `surat_jalan`, `route`, `total_tonase`,
`jenis_armada`, `driver_external`, `mobil_external`, `courier`, `customer`, `date`,
`assistant`, `driver`, `order_details[]`.

**`ItemOrderModel`** — `item`, `qty`, `barcode`, `pic`/`checker1` (`StatusItem`),
`checker2`/`loader`/`driver` (`StatusOrder`), `status_checker2`, `status_deliveryscan`,
`status_finishscan`, `status_arrive`, `status_unload`, `status_confirmdelivery`,
`lokasi`, `warna`.

**Response envelopeumum:** `{status: bool, message: string, data: ..., error: {details, ...}}`.
Envelope login berbeda: `{code, message, error, data}`.

---

## 9. Aturan Bisnis

| #     | Aturan                                                            | Implementasi                                                               |
| ----- | ----------------------------------------------------------------- | -------------------------------------------------------------------------- |
| BR-1  | Role menentukan navigasi                                          | `CustomButton.bottomBarIcon`, `HomePage` children                          |
| BR-2  | Role menentukan endpoint                                          | `AppRole.current!.name.toLowerCase()` disisipkan ke path                   |
| BR-3  | Loader = `check2` sampai `statusChecker2 == completed`            | `if (role == 'loader' && statusChecker2 != 'completed') role = 'check2'`   |
| BR-4  | Driver punya 2 fase tiba di customer                              | `EnumButtonEndingOrder.savePO → saveDriverPO`                              |
| BR-5  | Foto wajib minimal 1                                              | Guard `mediaFileList.isEmpty` di hampir semua POST                         |
| BR-6  | Lokasi wajib pada hampir semua POST driver                        | `LocationService.getLatestLocationLightweight()`                           |
| BR-7  | Checkbox produk one-way (tidak bisa un-tick)                      | `if (check) return;` di `_buildCheckBox`                                   |
| BR-8  | Checkbox hidden saat `statusChecker2 == completed`                | `_buildCheckBox` early-return                                              |
| BR-9  | LockPO handling                                                   | Jika pesan error contain `LockPO` → dialog 2-tombol + tombol Hubungi Admin |
| BR-10 | Armada External: inform pengirim per-PO di akhir                  | Warning merah di `InputAssistenWidget` + `FieldInputLoaderWidget`          |
| BR-11 | Maksimal 2 foto per field                                         | `CustomImage` default `maxImage: 2`; `foto1`/`foto2` only                  |
| BR-12 | Maksimal 4 foto kendaraan                                         | `ArriveImageWidget.isTransportation` (depan/kanan/belakang/kiri)           |
| BR-13 | Ambil RIT: PIC atau loader-dengan-0-pending → assign asisten dulu | `takeItOrder` branch                                                       |
| BR-14 | Ambil RIT: selain itu → `takeRIT` langsung                        | `takeItOrder` branch                                                       |
| BR-15 | `Retur tidak terkait` tidak punya invoice                         | Tidak ada `invoice` di form                                                |
| BR-16 | Kendala bulat: `titleTrouble`, `solution`, `nominal` hanya lokal  | `deliverynew/trouble` hanya kirim `desc`                                   |
| BR-17 | Error scanner "max_mistakes" untuk Checker1                       | `isMaxFailureChecker` → tombol Hubungi Admin                               |
| BR-18 | Lock RIT (cancelRIT) hanya lokal + `trouble` API                  | `buttonRIT = cancelRIT`                                                    |
| BR-19 | Reorder PO tidak dipersist ke server                              | `_saveNewOrderToServer()` di-comment                                       |
| BR-20 | Splash daily reset                                                | `resetDate != hariIni` → clear 5 key, user tetap                           |

---

## 10. Error Handling & UX

### 10.1 Error Taxonomy

**Exceptions** (`core/error/exceptions.dart`): `ServerException`, `UnauthorizedException`,
`CacheException`, `NetworkException`, `TimeoutException`, `UnknownException`.

**Failures** (`core/error/failures.dart`): `ServerFailure`, `CacheFailure`, `NetworkFailure`,
`UnauthorizedFailure`, `UserNotFoundFailure`, `UserAlreadyExistsFailure`,
`InvalidCredentialsFailure`, `InvalidEmailFailure`, `InvalidPasswordFailure`,
`TimeoutFailure`, `UnknownFailure`.

**`HandleDioExceptions`** — satu-satunya mapper aktif:

| DioExceptionType                                   | Pesan                                                |
| -------------------------------------------------- | ---------------------------------------------------- |
| `connectionTimeout`/`sendTimeout`/`receiveTimeout` | "Connection timeout. Please check your internet."    |
| `badResponse` 400                                  | `data['message']` atau "Bad request"                 |
| `badResponse` 401                                  | "Unauthorized. Please login again."                  |
| `badResponse` 403                                  | "Forbidden. You don't have permission."              |
| `badResponse` 404                                  | "Resource not found."                                |
| `badResponse` 409/422                              | `data['message']` atau default                       |
| `badResponse` 500                                  | "Internal server error. Please try again later."     |
| `badResponse` 502/503                              | "Service temporarily unavailable. Please try again." |
| `cancel`                                           | "Request was cancelled"                              |
| `connectionError`                                  | "Connection error. Please check your internet."      |
| `badCertificate`                                   | "Bad certificate. Security issue detected."          |
| `unknown`                                          | "Unknown error occurred"                             |

**`DioClient._parseDioError`** — tabel paralel (Bahasa Indonesia, emoji):

| Kondisi           | Pesan                                       |
| ----------------- | ------------------------------------------- |
| timeout           | "⏱️ Request timeout. Periksa koneksi Anda." |
| `connectionError` | "🔌 Tidak dapat terhubung ke server."       |
| `badCertificate`  | "🔒 Sertifikat keamanan tidak valid."       |
| 401               | "🔑 Sesi expired, silakan login ulang."     |
| 403               | "⛔ Akses ditolak."                         |
| 404               | "📍 Data tidak ditemukan."                  |
| ≥500              | "🖥️ Server error, coba beberapa saat lagi." |

### 10.2 Dialog Service (UI feedback)

| Method                          | Bentuk                                                                              |
| ------------------------------- | ----------------------------------------------------------------------------------- |
| `showLoading()`                 | `Get.defaultDialog` spinner (⚠️ `hideLoading()` kosong — harus `Get.back()` manual) |
| `showError(title, message)`     | AlertDialog 1-2 tombol (`Kembali` / `Hubungi Admin`)                                |
| `showConfirmation(title, desc)` | 2 tombol (batal/confirm) — ⚠️ default confirm double-pop                            |
| `showDialogBox(title, desc)`    | Dialog 1 tombol                                                                     |
| `showSuccessSnackbar(msg)`      | Snackbar hijau                                                                      |
| `showErrorSnackbar(msg, title)` | Snackbar merah                                                                      |
| `showComingSoonSnackbar()`      | Snackbar merah "Fitur sedang dalam pengembangan"                                    |
| `defaultDialog(...)`            | AlertDialog dengan `SizedBox(Get.height*height, Get.width*width)`                   |
| `inputDialog(...)`              | `Get.defaultDialog` (sistem visual berbeda)                                         |
| `handleExit()`                  | Confirm exit (⚠️ `exit(0)`, tidak web-safe)                                         |

---

## 11. Persyaratan Non-Fungsional

| Kategori            | Requirement                                         | Status                                                           |
| ------------------- | --------------------------------------------------- | ---------------------------------------------------------------- |
| **Performa**        | Splash delay 2s; scan window 350×150; limit 10/page | ⚠️ `getCacheSize`/`clearAllCache` sync I/O di UI isolate         |
| **Performa**        | Connection ping setiap 8s                           | ⚠️ permanent timer selama app hidup                              |
| **Jaringan**        | Handling `online`/`weak`/`offline`                  | ✅ `KoneksiCheck` + `ConnectionBanner`                           |
| **Jaringan**        | 401 auto-refresh token                              | ✅ single-flight `DioInterceptor`                                |
| **Jaringan**        | Offline pre-flight reject                           | ✅ `QueuedInterceptorsWrapper`                                   |
| **Keamanan**        | Token di `FlutterSecureStorage`                     | ✅                                                               |
| **Keamanan**        | Tidak ada hardcoded secret di client                | ✅ (base URL public, WA number hardcoded)                        |
| **Keamanan**        | HTTPS enforced                                      | ⚠️ `privacyPolicy` masih `http://`                               |
| **Keamanan**        | `LogInterceptor` body logging                       | ⚠️ ⚠️ **log token + kredensial ke console**                      |
| **Aksesibilitas**   | Text scaling                                        | ⚠️ `TextScaler.linear(1.0)` — override preferensi OS             |
| **Aksesibilitas**   | `MediaQuery.viewInsets`                             | ⚠️ manual `didChangeMetrics` + `resizeToAvoidBottomInset: false` |
| **Localisasi**      | Bahasa Indonesia                                    | ✅ dominan                                                       |
| **Testing**         | Unit / widget / integration                         | ❌ **0% — tidak ada `test/`**                                    |
| **CI/CD**           | Lint config                                         | ✅ `flutter_lints ^5.0.0` (default, 0 custom rule)               |
| **Error reporting** | Crash reporting                                     | ❌ tidak ada (hanya `debugPrint`)                                |
| **Analytics**       | Usage tracking                                      | ❌ tidak ada                                                     |
| **Version**         | Single source of truth                              | ❌ 4 sumber versi berbeda                                        |
| **Watermark**       | Prevention screenshot                               | ✅ `WatermarkOverlay` di root                                    |
| **Theme**           | Dark mode                                           | ❌ hard-coded `ThemeMode.light`                                  |

---

## 12. Temuan Teknis (Technical Findings)

> Bagian ini mendokumentasikan kondisi existing yang teridentifikasi saat rekonstruksi.
> **Tidak ada kode yang dimodifikasi** — ini adalah dokumentasi untuk perencanaan refactor.

### 12.1 Version Drift

Empat sumber versi yang tidak sinkron:

| Sumber                                   | Nilai                                 |
| ---------------------------------------- | ------------------------------------- |
| `pubspec.yaml`                           | `1.0.0+1` (yang benar-benar di-build) |
| `AppInfo.version`                        | `9.0.0` (ditampilkan di UI)           |
| `AppInfo.updatedAt`                      | `23 Sep 2026`                         |
| `HomeProfileController.versionApp`       | `8.0.0` (dead)                        |
| `HomeProfileController.updateVersionApp` | `10 Aug 2026` (dead)                  |
| `WatermarkOverlay` default               | `v9.0.0` (hardcoded duplicate)        |

`package_info_plus` terpasang tapi `versionInfo()` tidak pernah dipanggil.

### 12.2 Dead Code (estimasi ~20% dari `lib/`)

| Area                  | Item                                                                                                                                                                                                                                                                                                                                                          |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Profile feature**   | `ProfileController`, `ProfileBinding` (tidak terdaftar), `profile_remote_datasource*.dart` (0 byte), `ProfileRepositoryImpl` (tidak `implements` interface, endpoint `/auth/login` berbeda), 3 widget lama                                                                                                                                                    |
| **Mapper**            | `mapper_exceptions.dart` (`mapExceptionToFailure` — 0 caller)                                                                                                                                                                                                                                                                                                 |
| **DioClient**         | `parseResponse` (0 caller), `testPost` (debug helper 75 baris di production)                                                                                                                                                                                                                                                                                  |
| **Network**           | `connectivity_network.dart` (208 baris 100% di-comment)                                                                                                                                                                                                                                                                                                       |
| **Watermark**         | `Watermark` (single "INVENTORY"), `WatermarkPainter` (tiled diagonal) — hanya `WatermarkOverlay` (versi) yang hidup                                                                                                                                                                                                                                           |
| **Navigation**        | `NavigationService` (tidak di-DI, `navigatorKey` di-comment)                                                                                                                                                                                                                                                                                                  |
| **Mockup**            | `MockupLogin` (semua method `void`, tidak di-caller; `mockLoginAsChecker2` pass `'sealing'` → resolve ke `picking`)                                                                                                                                                                                                                                           |
| **Entity**            | `BasicEntity.fromJson` (0 caller), `GetUserEntity`, `TransactionEntity`, `TransactionModel`, `ListOrderModel`, `HomeModel`, `TakeItTransactionEntity`, `TakeItOrderEntity`, `ParamsTakeIt` (list_order), `ParamsPendingSO` (0 caller), `InfoRit` (hardcoded dummy)                                                                                            |
| **Response model**    | `ResponseModelGetTransaction` (0 caller), `ResponseModelTakeItTransaction` (0 caller), `response_model_ending_order.dart` + `response_model_rit.dart` (100% di-comment)                                                                                                                                                                                       |
| **Controller fields** | `DetailOrderController`: `isLoadingAssistant`, `isTakeIt`, `isCheckedAll`, `statusPostProduct`, `reasonController`; `RitController`: `mediaFileListInvoice`, `mediaFileListAddRetur`, `mediaFileRecipientInvoice`, `mediaFileRecipientMoney`; `ListOrderController`: `listSelected`, `extNopolTransporation`, `pageController`; `HomeController`: `indexPage` |
| **Widget**            | `_popupFilter` (body kosong), `_buildRit` di `home_tracking_driver_view` (0 caller), `retur_header_item_list.dart` (100% di-comment), `buildShippingText` (0 caller), `_buildButtonSave` di `ending_order_view`                                                                                                                                               |
| **Home**              | `HomeTransactionsController.getOrder()` (0 caller → tab "Pesanan Dikerjakan" selalu kosong), `HomeRITController.addTakeIt` (0 caller dari UI), `HomeDialog` `mediaFileList.value = mediaFileList` (self-assignment bug)                                                                                                                                       |
| **Injection**         | `AppInfo.build` (0 caller), `ApiEndpoints.users`, `logout`, `pendingSO`, `addAssistant` (0 caller)                                                                                                                                                                                                                                                            |
| **Result**            | `BaseResponseFailed` (0 caller)                                                                                                                                                                                                                                                                                                                               |

### 12.3 Validation Tidak Dijalankan

| Lokasi                                           | Masalah                                                                                            |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| `LoginController.login()`                        | Tidak pernah memanggil `formKey.currentState!.validate()` → kirim request dengan kredensial kosong |
| `SplashView.build()`                             | Memanggil `controller.onReady()` manual di dalam `build` (violasi lifecycle GetX)                  |
| `FieldInputLoaderWidget`                         | Field ada dalam `Form`, tapi `formKey.currentState.validate()` di-comment di `ending_order_view`   |
| `ArriveAtOffice.recipientName`                   | Validator ada tapi **tidak ada `Form`** pembungkus                                                 |
| `_buildTitleField` di `home_rit_contsraint_view` | Validator ada tapi tidak ada `Form` (validasi manual di `addConstraint`)                           |
| `InputAssistenWidget`                            | Tanpa validasi — hanya gating `isLoadingAssistant`                                                 |
| `ReturItemForm`                                  | Gagal **diam-diam** jika `mediaFileList.isEmpty` (tidak ada snackbar)                              |

### 12.4 Force-Unwrap / Null Safety

| Lokasi                                            | Risiko                                                                                                                                                                             |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GetDetailOrderController._successGetDetailOrder` | `data.assistant!` & `data.driver!` di branch yang jalan untuk **semua** non-driver. API yang tidak mengembalikan `assistant`/`driver` → crash (tertangkap `try` → "Failed" dialog) |
| `ListOrderRepositoryImpl.*`                       | `response.data!` di 6 method                                                                                                                                                       |
| `DetailOrderRepositoryImpl.getListOrders`         | `response.data!`                                                                                                                                                                   |
| `PostDataListController.addAssistant`             | `loader!` (force) — NPE jika tidak ada kendaraan match                                                                                                                             |
| `getAssisten()`                                   | `data.first` (driver/kenek/kendaraan) — `StateError` jika list kosong; `result[1]` unconditionally                                                                                 |
| `CustomCardList`                                  | `int.parse('0xFF$color')` — crash jika `color` null/invalid                                                                                                                        |
| `rit_controller.saveOrder`                        | `mediaFileListKM[0]`, `mediaFileListTangki[0]`, `mediaFileListSJ[0]`, `mediaFileListTransportMoney[0]`                                                                             |
| `ItemOrderReturEntity.toJson`                     | `int.parse(inputQtyItem ?? '0')` — crash jika `''`                                                                                                                                 |
| `ending_order` datasource                         | `params.images![0]` (crash jika list kosong)                                                                                                                                       |
| `rit_remote_datasource`                           | `file1` required (`params.images[0]`) — crash jika kosong                                                                                                                          |

### 12.5 Bug Fungsional Teridentifikasi

| #    | Bug                                                      | Dampak                                                                                                                                    |
| ---- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| B-1  | **Driver tidak bisa buka tab Retur**                     | `HomePageController.changePage`: `if (isDriver && index == 1) → "Coming Soon"`, padahal index 1 untuk driver adalah `HomeReturDriverView` |
| B-2  | **"Pesanan Dikerjakan" selalu kosong**                   | `HomeTransactionsController.getOrder()` di-comment di `HomeController._initializeAllData()`                                               |
| B-3  | **Search non-fungsional di home & tracking**             | `home_remote_datasource_impl` tidak mengirim `q` ke API (seperti `rit_information` yang benar)                                            |
| B-4  | **`HomeDialog` self-assignment**                         | `mediaFileList.value = mediaFileList;` — file passing lost                                                                                |
| B-5  | **Card #2 home selalu tampil `-`**                       | `HomeCardWidget` menerima `value: 0, isPast: true` → render `isPast ? '-' : value`                                                        |
| B-6  | **`splash_view` onReady manual**                         | Double-init pada rebuild                                                                                                                  |
| B-7  | **Qty tidak terkirim dari dialog input**                 | `onPressed2: addProduct(quantity: qty)` — `qty` = parameter function, bukan nilai text-field                                              |
| B-8  | **`removeImage` parameter `files` diabaikan**            | Mutation langsung ke `RxList` internal + manual `.refresh()`                                                                              |
| B-9  | **Login success race**                                   | `AppRole.loginFromApi` tidak di-`await` sebelum `Get.offAllNamed(Routes.HOME)`                                                            |
| B-10 | **Token logout tidak trigger navigasi**                  | `_handleLogout` di `DioInterceptor` = no-op commented                                                                                     |
| B-11 | **Sort filter tidak dikirim ke API**                     | `sortByNew` hanya di state, `dateRit` dikirim raw `DateTime.toString()` (bukan `yyyy-MM-dd`)                                              |
| B-12 | **`HomeBinding` register `HomePageController` 2x**       | Second `lazyPut` override first                                                                                                           |
| B-13 | **`isRitDetail`/`getRit` list tidak dipakai**            | `listRit` di tracking → dead payload                                                                                                      |
| B-14 | **Duplicate map key di `postSaveDataDriver`**            | Saat `isArriveOffice`, `tanggal_rit` ditulis 2x (formatted + raw)                                                                         |
| B-15 | **`overAllTruckImage` = `frontTruckImage`**              | Kirim foto yang sama untuk overall & depan                                                                                                |
| B-16 | **Card #2 "Total Pesanan Lampau" tidak pernah di-fetch** | Tidak ada request untuk nilai riil                                                                                                        |

### 12.6 Fitur Half-Finished

| Fitur                                       | Status                                                                                                                                                            |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Retur Tidak Terkait** (home tab)          | Form lengkap (nama customer, toko, alamat, item dialog) tapi **"Simpan" hanya validasi form lokal** — tidak ada API call, tidak persist, item list tidak di-clear |
| **Kendala / Ambil RIT** (home)              | Data hanya di memory (`ritConstraints`, `listTakeItTransaction`) — hilang saat restart; endpoint read tidak ada                                                   |
| **Ambil RIT dari take_it_order_view**       | Tombol "+" → snackbar "Coming Soon"; `addTakeIt` tidak punya caller dari UI                                                                                       |
| **Loader "Scan PO"**                        | `visible1 = false` + tap → "Coming Soon"                                                                                                                          |
| **Retur per-PO dari detail order**          | `RitDialog.inputRetur` ada, tapi dialog list item menampilkan `'-'` (data tidak di-load)                                                                          |
| **Ubah urutan PO**                          | `_buildButtonChangePO` & `_buildButtonConfirmChangePO` ada tapi call site di-comment                                                                              |
| **Simpan dokumen RIT** (`buttonSaveRitDoc`) | Enum ada, tidak ada transisi ke state ini                                                                                                                         |
| **"Semua" PO di scan dialog**               | `isPast: true` card #2 hardcoded `0`                                                                                                                              |

### 12.7 Keamanan

| Temuan                                                            | Dampak                                                                   |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `LogInterceptor(requestBody: true, responseBody: true)`           | **Log kredensial + Bearer token** ke console (Android logcat)            |
| `TokenStorage.saveToken(accessToken: token, refreshToken: token)` | Access = Refresh (jerat refresh token jadi tidak berguna)                |
| `ApiEndpoints.privacyPolicy` = `http://`                          | Mixed content — diblokir Android API 28+                                 |
| `DioClient` `throw e.error ?? e`                                  | Rethrow `String`, bukan exception → `on DioException` tidak pernah match |
| `handleExit()` = `exit(0)`                                        | Tidak kompatibel web                                                     |
| `api3.andiglobalsoft.com` hardcoded                               | Tidak ada environment switch (dev/staging/prod)                          |
| Tidak ada certificate pinning                                     | Rentan MITM pada jaringan publik                                         |
| `wa.me/628112936865` hardcoded                                    | Nomor WA admin personal                                                  |

### 12.8 Duplikasi

| Duplikat                                      | Lokasi                                                                              |
| --------------------------------------------- | ----------------------------------------------------------------------------------- |
| `CustomGridImage`                             | `lib/shared/images/` (aktif) + `lib/core/images/` (dead, tapi wrap `Obx`)           |
| `SortWidget`                                  | `lib/shared/order/` (props) + `lib/features/list_order/widgets/` (controller)       |
| `Watermark`                                   | 3 implementasi (`Watermark`, `WatermarkOverlay`, `WatermarkPainter`)                |
| `ResponseModelBasic`                          | 2 varian lama di-comment di `response_model_basic.dart`                             |
| `ConnectionStatus` enum                       | `koneksi_check.dart` (aktif) + `connectivity_network.dart` (dead)                   |
| `TimeoutException`                            | `dart:async` + `core/error/exceptions.dart`                                         |
| `RitConstraintEntity`                         | Dipakai untuk 2 tipe data (kendala + ambil RIT)                                     |
| `ThousandSeparatorInputFormatter`             | `,` (input) vs `formatNumber` `de_DE` → `.` (display)                               |
| `Data` class                                  | 3 response model punya top-level `class Data` → nama bentrok bila di-import bersama |
| `MultipartHelper` + `XFileMultipartExtension` | 2 util untuk 1 job                                                                  |

### 12.9 Naming & Code Smell

| Item                                                            | Detail                                                                                   |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `get_emtpy_post_retur`                                          | Typo: "emtpy" → "empty"                                                                  |
| `Pengunaan`                                                     | Typo: "pengunaan" → "penggunaan"                                                         |
| `statatusDriver`                                                | Typo: "statatus" → "status"                                                              |
| `home_rit_contsraint_view.dart`                                 | Typo filename: "contsraint" → "constraint"                                               |
| `response_model_get_transporation.dart`                         | Typo: "transporation" → "transportation"                                                 |
| `ResponseModelGetTransactionAll.transaction` vs `.transactions` | Inkonsistensi nama field                                                                 |
| `Gudang: 'BARANG JADI'`                                         | Hardcoded di datasource (`postEndingOrder`)                                              |
| `ListOrderController.listSelected`                              | `<dynamic>[]` — tipe tidak aman                                                          |
| `ScannerOverlay` `errorBuilder`                                 | commented-out `throw error`                                                              |
| `scanner_error_widget.dart`                                     | Case clause tanpa `break` — ⚠️ **risiko compile error Dart 3**                           |
| `didChangeAppLifecycleState`                                    | `resumed` case tanpa `break`/`return`                                                    |
| `HomeCardWidget`                                                | `isPast: true` render `'0'` jadi `'-'`                                                   |
| `formKey.currentState!.validate()`                              | Dipanggil tanpa null check di banyak tempat                                              |
| `TextEditingController`                                         | Tidak di-dispose di banyak controller (`searchController`, `extNopolTransporation`, dll) |

### 12.10 Inconsistency Architectural

| Item                                     | Detail                                                                         |
| ---------------------------------------- | ------------------------------------------------------------------------------ |
| `HomeController.searchController`        | Dibagikan 3 widget (home, kendala, ambil-RIT) — ketik di satu = ketik di semua |
| `ListOrderController.isDistrictSelected` | Actually = RIT number (bukan district) — ada komentar DIUBAH JADI RIT          |
| `RitController.isDistrictSelected`       | Sama — RIT number                                                              |
| `OrderEntity.lat`/`long`                 | Dideklarasikan tapi **tidak pernah di-parse** dari JSON                        |
| `Data` class di 3 response model         | Nama bentrok global                                                            |
| `Failures` hierarchy                     | 12 class, 0 dipakai                                                            |
| `BasicResponse` model                    | Tidak ada di sebagian besar feature                                            |
| Response envelope                        | Auth: `{code, ...}`. Lainnya: `{status, ...}` — 2 format berbeda               |
| Tanggal param                            | `date_rit` (today) vs `daterit` (past) — beda 1 underscore                     |
| `isMaxFailure`                           | Hanya Checker1 yang punya UI untuk itu; PIC/Checker2/Driver tidak              |

---

## 13. Roadmap & Rekomendasi

> **Rekomendasi bersifat strategic, tidak mengubah kode existing.**

### 13.1 Prioritas Tinggi (Quick Win)

| #   | Item                                                                   | Dampak                            |
| --- | ---------------------------------------------------------------------- | --------------------------------- |
| 1   | Single source of truth untuk versi (pubspec → CI inject ke `AppInfo`)  | Hilang 4 sumber versi             |
| 2   | Matikan `LogInterceptor` di release build                              | Cegah log token/kredensial        |
| 3   | Fix `HomePageController.changePage` guard agar Retur bisa dibuka (B-1) | Fitur Retur kembali bisa dipakai  |
| 4   | Kirim `q` di `home_remote_datasource_impl.fetchTransaction` (B-3)      | Search home & tracking berfungsi  |
| 5   | `await` `AppRole.loginFromApi` sebelum navigasi (B-9)                  | Hilang race condition tab         |
| 6   | Panggil `validate()` di `LoginController.login()`                      | Validasi form benar-benar bekerja |
| 7   | Ubah `privacyPolicy` ke `https://`                                     | Mixed content                     |
| 8   | Navigasi ke `/login` di `_handleLogout` (B-10)                         | 401 tidak lagi strand user        |

### 13.2 Prioritas Sedang (Refactor)

| #   | Item                                                                                                        |
| --- | ----------------------------------------------------------------------------------------------------------- |
| 9   | Hapus seluruh dead code (§12.2) — estimasi mengurangi 20% baris                                             |
| 10  | Ganti `List<OrderEntity>[]` + manual `refresh()` dengan immutable list                                      |
| 11  | Extends `GetStorage` key ke `StorageKeys` constant (14 string literal tersebar)                             |
| 12  | Ganti force-unwrap `data.assistant!` dengan null-check + fallback                                           |
| 13  | Aktifkan `HandleDioExceptions` pesan Bahasa Indonesia (ganti `dio_exceptions.dart` dengan `_parseDioError`) |
| 14  | Buat `ApiResponse<T>` generik — hapus duplikasi `ResponseModel*` per feature                                |
| 15  | Pisahkan `SessionManager` dari `HomeController` (terr cycle Get.find berantakan)                            |
| 16  | Environment switch untuk base URL (dev/staging/prod via `--dart-define`)                                    |
| 17  | Hapus 2 dari 3 implementasi watermark, pilih satu (tiled lebih informatif)                                  |
| 18  | Hapus `HomeController.searchController` — pisahkan per-tab                                                  |
| 19  | Rename typo file/class: `contsraint`, `transporation`, `_emtpy`, `statatusDriver`                           |
| 20  | Standardisasi `formatNumber` & `ThousandsSeparatorInputFormatter` (keduanya `,`)                            |

### 13.3 Prioritas Rendah (Nice-to-Have)

| #   | Item                                                                               |
| --- | ---------------------------------------------------------------------------------- |
| 21  | Environment switch + flavor build (dev/staging/prod)                               |
| 22  | Dark mode dari `GetStorage('theme_mode')` (sudah di-stub di `AppInitializer`)      |
| 23  | Restore `TextScaler` — hapus `TextScaler.linear(1.0)` override                     |
| 24  | `handleExit()` — ganti `exit(0)` dengan `SystemNavigator.pop()`                    |
| 25  | Hapus `cacheSize` sync I/O — jalankan di isolate terpisah                          |
| 26  | Ganti `KoneksiCheck` 8s timer dengan connectivity event-driven + debounce          |
| 27  | Certificate pinning untuk `andiglobalsoft.com`                                     |
| 28  | Crash reporting (Firebase Crashlytics / Sentry)                                    |
| 29  | Basic analytics (track `startingPO`, `saveOrder`, `saveArriveDriver` success rate) |
| 30  | `isMaxFailure` gating seragam di semua role, bukan hanya Checker1                  |

### 13.4 Inisiasi Test

| #   | Item                                                                      |
| --- | ------------------------------------------------------------------------- |
| 31  | Setup `test/` + `flutter_test` base                                       |
| 32  | Unit test `SessionManager._parseRole` (termasuk kasus role tidak dikenal) |
| 33  | Unit test `FormValidator` semua method                                    |
| 34  | Unit test `BoxStatus.buildText`/`.buildColor` per role                    |
| 35  | Unit test `handleApiResponse` (claim/complete/scan) payload shape         |
| 36  | Widget test `LoginView` — validasi form                                   |
| 37  | Widget test `CustomCardList` per role                                     |
| 38  | Integration test happy path picking (mock Dio adapter)                    |
| 39  | Integration test happy path driver 10 langkah (mock Dio adapter)          |
| 40  | Golden test login + home                                                  |

---

## 14. Glossary

| Istilah                 | Definisi                                                                     |
| ----------------------- | ---------------------------------------------------------------------------- |
| **PO**                  | Purchase Order / pesanan pembelian — unit kerja utama yang diproses          |
| **RIT**                 | Rute Illuminate/Tray — unit kerja rute yang berisi banyak PO untuk satu hari |
| **SJ**                  | Surat Jalan — dokumen accompanying barang                                    |
| **Invoice**             | `invoice` — ID unik transaksi di sistem                                      |
| **PIC**                 | Personnel In Charge — pemangku kerja di tim picking                          |
| **Checker 1**           | Verifikasi packing (isyarat isi paket benar)                                 |
| **Checker 2 / Loader**  | Verifikasi muat + supervisory                                                |
| **Kenek**               | Assistant driver — orang kedua di kendaraan                                  |
| **Armada**              | Kendaraan                                                                    |
| **Armada External**     | Kendaraan milik pihak ketiga, bukan armada perusahaan                        |
| **Barang Jadi**         | Kategori produk (vs barang baku)                                             |
| **Gudang**              | Warehouse                                                                    |
| **Retur**               | Return — pengembalian barang                                                 |
| **Retur Terkait**       | Retur yang terkait dengan PO/invoice tertentu                                |
| **Retur Tidak Terkait** | Retur tanpa PO — standalone                                                  |
| **Kendala**             | Problem/trouble selama pengiriman                                            |
| **Handover**            | Serah terima (barang, berkas, atau uang)                                     |
| **Sangu**               | Uang cash untukmransportasi selama perjalanan                                |
| **Selesai**             | Status badge default (`status = 'SELESAI'`) untuk kendala                    |
| **Scan window**         | Area aktif pembacaan barcode di layar scanner                                |
| **Max failure**         | Batas maksimum kesalahan scan sebelum di-lock                                |
| **LockPO**              | Flag error dari server saat PO sudah dikunci oleh user lain                  |
| **Fenix**               | GetX `lazyPut` flag: re-create dependencies setelah `Get.delete`             |
| **Sealed class**        | Dart 3 pattern: exhaustive `switch` tanpa `default`                          |
| **Watermark**           | Overlay teks versi di layar untuk mencegah screenshot                        |

---

## 15. Referensi

### 15.1 File Penting

| File                                                                              | Responsibility                                            |
| --------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `lib/main.dart`                                                                   | Entry point, `GetMaterialApp`, watermark + banner wrapper |
| `lib/routes/app_pages.dart`                                                       | Route table + bindings                                    |
| `lib/routes/app_routes.dart`                                                      | Generated route constants                                 |
| `lib/core/middlewares/session_manager.dart`                                       | `UserRole` enum, `SessionManager`                         |
| `lib/core/middlewares/app_role.dart`                                              | Static role facade                                        |
| `lib/core/network/api_endpoints.dart`                                             | Semua endpoint constants                                  |
| `lib/core/network/dio_client.dart`                                                | HTTP client + interceptor chain                           |
| `lib/core/network/dio_interceptor.dart`                                           | Auth header + 401 refresh                                 |
| `lib/core/network/koneksi_check.dart`                                             | Connection monitor (online/weak/offline)                  |
| `lib/core/result/result_custom.dart`                                              | Sealed result type                                        |
| `lib/core/initializer/app_initializer.dart`                                       | Boot sequence                                             |
| `lib/core/constants/app_info.dart`                                                | Version constants                                         |
| `lib/injection/initial_binding.dart`                                              | DI entry point                                            |
| `lib/features/home/presentation/controllers/home_controller.dart`                 | Home orchestrator (6 sub-controller)                      |
| `lib/features/list_order/presentation/controllers/list_order_controller.dart`     | RIT/PO list orchestrator                                  |
| `lib/features/detail_order/presentation/controllers/detail_order_controller.dart` | Detail order master                                       |
| `lib/features/rit_information/presentation/controllers/rit_controller.dart`       | RIT orchestrator (3 halaman)                              |
| `lib/features/ending_order/presentation/controllers/ending_order_controller.dart` | Ending order + driver 2-fase                              |
| `lib/features/scan_product/presentation/controllers/scan_product_controller.dart` | Barcode scanner                                           |
| `lib/shared/box/box_status.dart`                                                  | Status badge per role                                     |

### 15.2 Dependency

| Package                    | Versi        | Usage                      |
| -------------------------- | ------------ | -------------------------- |
| `flutter`                  | SDK `^3.8.1` | Framework                  |
| `get`                      | `^4.7.3`     | State, DI, routing, dialog |
| `dio`                      | `^5.9.2`     | HTTP client                |
| `get_storage`              | `^2.1.1`     | Key-value persistence      |
| `flutter_secure_storage`   | `^10.0.0`    | Token storage              |
| `mobile_scanner`           | `^7.1.4`     | Barcode scanning           |
| `camera`                   | `^0.12.0+1`  | Foto capture               |
| `permission_handler`       | `^12.0.1`    | Camera permission          |
| `geolocator`               | `^14.0.2`    | GPS                        |
| `connectivity_plus`        | `^7.1.1`     | Network status             |
| `http`                     | `^1.6.0`     | Ping untuk `KoneksiCheck`  |
| `google_fonts`             | `^6.3.2`     | Inter / Plus Jakarta Sans  |
| `ionicons`                 | `^0.2.2`     | Icon set                   |
| `intl`                     | `^0.20.2`    | Date/number format         |
| `dotted_border`            | `^3.1.0`     | Dashed border upload tile  |
| `loading_animation_widget` | `^1.3.0`     | Spinner                    |
| `url_launcher`             | `^6.3.2`     | WhatsApp, maps, legal URL  |
| `package_info_plus`        | `^9.0.1`     | ⚠️ tidak dipakai           |
| `path_provider`            | `^2.1.6`     | Cache directory            |
| `http_parser`              | `^4.1.2`     | Multipart                  |
| `cupertino_icons`          | `^1.0.8`     | Cupertino icons            |

### 15.3 Platform

**Target:** Android (utama). Desktop & web juga dikonfigurasi tapi `handleExit()`
(`exit(0)`) dan `MapUtils` (`url_launcher`) membuatnya **tidak web-friendly**.

**Min SDK:** TBD (lihat `android/app/build.gradle`). **`geolocator` 14** requires min
SDK 21+; **`camera` 0.12** requires min SDK 21+.

---

## 16. Metadata Dokumen

| Field           | Value                                                                                                                               |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Jenis           | Product Requirements Document (PRD) — rekonstruksi dari codebase                                                                    |
| Sumber          | Read-only analysis, 100% existing code                                                                                              |
| Modifikasi kode | **Tidak ada**                                                                                                                       |
| Commit baseline | `2775d6d` — "update: fixing retur & fixing bug" (2026-09-24)                                                                        |
| Total commit    | 61                                                                                                                                  |
| Metode analisis | Static analysis manual: baca seluruh `lib/`, petakan dependency, cross-reference endpoint                                           |
| Jangkauan       | `lib/core/`, `lib/features/`, `lib/injection/`, `lib/routes/`, `lib/shared/`, `lib/utils/`, `pubspec.yaml`, `analysis_options.yaml` |
| Di luar scope   | `android/`, `ios/`, `web/`, `build/`, `*.log`                                                                                       |
