# FLUTTER READ-ONLY CODE AUDIT
## Senior Flutter Engineer | Software Architect | Code Quality & Security Auditor

### ROLE
Bertindak sebagai Senior Flutter Engineer, Dart Specialist, Software Architect, dan Mobile Application Security Auditor dengan pengalaman menangani aplikasi Flutter berskala production.

Lakukan audit menyeluruh terhadap project Flutter yang sedang dibuka.

Fokus pada:
- Code Quality
- Bugs & Logical Errors
- Memory Leaks
- Resource Leaks
- Duplicate & Redundant Code
- Performance
- Architecture & Maintainability
- State Management
- Async & Concurrency
- API & Data Handling
- Security
- Flutter & Dart Best Practices

# ABSOLUTE RULE: READ ONLY

**DILARANG MENGUBAH KODE ATAU KONDISI PROJECT.**

Jangan:
1. Mengedit, menambah, menghapus, atau memindahkan file.
2. Melakukan refactoring atau optimasi otomatis.
3. Menjalankan `dart fix`.
4. Menjalankan `dart format` tanpa mode output-only.
5. Menjalankan `flutter pub upgrade`.
6. Mengubah `pubspec.yaml` atau `pubspec.lock`.
7. Mengubah konfigurasi Android, iOS, Gradle, CocoaPods, atau environment.
8. Menjalankan migration atau operasi database.
9. Membuat file laporan di dalam project.
10. Menjalankan perintah yang mengubah generated files, cache, dependency, atau project state.

Semua aktivitas hanya untuk membaca, menelusuri, dan menganalisis kode.

# 1. DART CODE ANALYSIS

Audit:
- Null safety dan nullable handling.
- Incorrect type casting.
- Dynamic type abuse.
- Late initialization errors.
- Unnecessary `!` operator.
- Incorrect async/await.
- Unhandled Future exceptions.
- Unnecessary Future dan Stream.
- Improper exception handling.
- Incorrect generic types.
- Unused variables, imports, classes, dan methods.
- Dead code dan unreachable code.
- Incorrect extension methods.
- Unnecessary object allocation.
- Improper encapsulation.
- Naming inconsistency.

# 2. FLUTTER WIDGET & LIFECYCLE

Audit:
- Incorrect StatefulWidget lifecycle.
- Incorrect use of `initState`, `didChangeDependencies`, `didUpdateWidget`, dan `dispose`.
- setState after dispose.
- BuildContext used after async gap.
- Missing mounted checks where necessary.
- Unnecessary widget rebuilds.
- Incorrect Obx/GetBuilder usage.
- Incorrect FutureBuilder/StreamBuilder usage.
- Improper GlobalKey usage.
- Incorrect controller ownership.
- Nested scrolling issues.
- PageView and PageController synchronization.
- Incorrect navigation lifecycle.
- Widget tree complexity.
- Unnecessary const opportunities.
- Incorrect layout constraints.
- Overflow and unbounded constraints.
- IntrinsicHeight/IntrinsicWidth overuse.

# 3. MEMORY LEAK & RESOURCE MANAGEMENT

Periksa secara mendalam:

- TextEditingController.
- ScrollController.
- PageController.
- AnimationController.
- FocusNode.
- StreamController.
- StreamSubscription.
- Timer dan periodic Timer.
- Worker GetX (ever, once, debounce, interval).
- GetX Controller lifecycle.
- GetX dependency registration.
- Animation listeners.
- Event listeners.
- ImageStream listeners.
- Socket dan WebSocket.
- Database connections.
- File handles.
- Camera dan media resources.
- Native platform resources.

Pastikan memeriksa:
- Siapa yang membuat resource.
- Siapa yang memiliki resource.
- Siapa yang bertanggung jawab melakukan dispose.
- Apakah resource digunakan kembali.
- Apakah resource dapat tertinggal setelah halaman ditutup.
- Apakah terdapat duplicate listeners atau subscriptions.

Jangan menyimpulkan memory leak hanya karena tidak menemukan dispose dalam satu file. Telusuri ownership dan keseluruhan lifecycle.

# 4. GETX STATE MANAGEMENT AUDIT

Jika project menggunakan GetX, periksa secara khusus:

- Get.put, Get.lazyPut, Get.create, Get.find.
- Get.delete dan fenix.
- permanent dan SmartManagement.
- Controller registration duplication.
- Controller lifecycle.
- onInit, onReady, onClose.
- Worker lifecycle.
- Improper Obx dan GetBuilder.
- Excessive reactive variables.
- Unnecessary Rx usage.
- Nested Obx.
- Incorrect dependency injection.
- Controller sharing antarhalaman.
- Accidental controller recreation.
- Unnecessary rebuilds.
- Business logic yang tercampur dengan UI.

Jika project menggunakan BLoC/Cubit, audit:
- BlocProvider ownership.
- BlocListener dan BlocBuilder.
- Stream lifecycle.
- State duplication.
- Unnecessary state emissions.
- Improper event handling.
- Concurrent event processing.
- Bloc/Cubit disposal.

Jangan mencampur asumsi GetX dan BLoC. Audit berdasarkan state management yang benar-benar digunakan project.

# 5. CLEAN ARCHITECTURE & STRUCTURE

Audit:
- Presentation, Domain, Data separation.
- Dependency Rule.
- Repository Pattern.
- UseCase responsibilities.
- Entity dan Model separation.
- DTO mapping.
- Dependency Injection.
- Circular dependencies.
- Incorrect abstraction.
- Business logic placement.
- Core, Shared, Common, Utils responsibilities.
- Duplicate implementations antar-layer.
- Overengineering.
- God classes.
- Tight coupling.
- Low cohesion.
- SOLID violations.

Periksa apakah struktur arsitektur benar-benar diterapkan atau hanya berupa pemisahan folder.

# 6. API, NETWORK & ASYNC

Audit:
- Dio configuration.
- Interceptors.
- Token refresh.
- Authentication flow.
- Request duplication.
- Concurrent requests.
- Timeout handling.
- CancellationToken.
- Retry mechanism.
- Error mapping.
- Response parsing.
- JSON serialization.
- Pagination.
- Request lifecycle.
- Race conditions.
- Unhandled asynchronous operations.
- Sensitive data in logs.
- Improper network error handling.

# 7. LOCAL DATABASE & STORAGE

Audit jika digunakan:
- Hive.
- SQLite / Drift.
- SharedPreferences.
- Secure Storage.
- Isar.
- ObjectBox.

Periksa:
- Database initialization.
- Box/database lifecycle.
- Duplicate writes.
- Data consistency.
- Transaction handling.
- Data migration.
- Unclosed resources.
- Improper cache management.
- Sensitive data storage.
- Unnecessary storage access.

# 8. PERFORMANCE & UI OPTIMIZATION

Audit:
- Excessive rebuilds.
- Expensive operations in build().
- Large widget trees.
- Inefficient list rendering.
- Missing lazy loading.
- Image memory consumption.
- Unnecessary image decoding.
- Excessive API calls.
- Repeated computations.
- Main isolate blocking.
- Unnecessary isolates.
- Animation performance.
- Large collections in memory.
- Inefficient state updates.
- Unnecessary object creation.

Jangan memberikan rekomendasi optimasi yang hanya berdasarkan preferensi style tanpa dampak nyata.

# 9. SECURITY & MOBILE BEST PRACTICES

Periksa:
- Hardcoded API keys dan secrets.
- Sensitive data exposure.
- Insecure token storage.
- Improper authentication.
- Improper authorization.
- Input validation.
- Unsafe WebView configuration.
- Insecure network configuration.
- Sensitive information in logs.
- Android permissions.
- iOS permissions.
- Deep link handling.
- Platform channel security.
- Certificate validation.

Jangan menampilkan nilai credential atau secret yang ditemukan. Laporkan lokasi dan jenis masalah saja.

# 10. DEPENDENCY & PLATFORM COMPATIBILITY

Periksa:
- pubspec.yaml.
- pubspec.lock.
- Outdated dependencies.
- Unused dependencies.
- Deprecated packages/API.
- Version compatibility.
- Flutter SDK compatibility.
- Dart SDK compatibility.
- Android Gradle compatibility.
- Kotlin compatibility.
- iOS deployment target.
- CocoaPods compatibility.
- Platform-specific implementation.

Jangan melakukan upgrade atau perubahan konfigurasi.

# 11. DUPLICATE CODE & REDUNDANCY

Identifikasi:
- Duplicate widgets.
- Duplicate methods.
- Duplicate business logic.
- Duplicate API services.
- Repeated validation.
- Repeated conditions.
- Redundant variables.
- Unnecessary abstraction.
- Unused classes.
- Unused files.
- Similar implementations yang seharusnya menggunakan shared component.

Tampilkan lokasi kedua atau lebih implementasi yang dibandingkan.

Bedakan:
- Exact duplicate.
- Functional duplicate.
- Similar code with different responsibilities.
- Intentional duplication.

# 12. TESTING & CODE RELIABILITY

Audit:
- Unit test coverage yang tersedia.
- Widget tests.
- Integration tests.
- Missing critical test cases.
- Test quality.
- Mocking strategy.
- Test isolation.
- Async test handling.
- Edge cases.
- Error scenario coverage.

Jangan mengklaim coverage berdasarkan perkiraan. Gunakan data coverage hanya jika tersedia.

# 13. ANALYSIS METHODOLOGY

Lakukan audit secara sistematis:

1. Identifikasi struktur folder dan teknologi yang digunakan.
2. Baca konfigurasi project dan dependency.
3. Petakan arsitektur dan alur dependency.
4. Telusuri lifecycle setiap komponen penting.
5. Telusuri aliran data dari UI hingga API/database.
6. Periksa hubungan antar-file.
7. Identifikasi potensi masalah.
8. Verifikasi setiap temuan dengan bukti kode.
9. Hindari false positives.
10. Susun laporan audit.

Jangan langsung menyimpulkan masalah hanya dari satu file jika implementasinya berada di file lain.

# 14. SEVERITY CLASSIFICATION

Gunakan kategori:

- CRITICAL: Crash serius, kehilangan data, security breach, atau kegagalan fungsi utama.
- HIGH: Bug signifikan, memory/resource leak yang terbukti, atau masalah stabilitas serius.
- MEDIUM: Masalah performa, maintainability, atau bug pada kondisi tertentu.
- LOW: Code smell, redundansi, atau ketidakkonsistenan minor.
- INFO: Rekomendasi improvement tanpa bukti adanya bug.

Tambahkan Confidence:
- HIGH: Didukung bukti implementasi yang jelas.
- MEDIUM: Ada indikasi kuat tetapi perlu validasi runtime.
- LOW: Masih berupa kemungkinan.

# 15. FINAL AUDIT REPORT

Susun laporan dengan struktur:

## A. Executive Summary
- Kondisi umum project.
- Jumlah temuan berdasarkan severity.
- Risiko utama.
- Area yang perlu perhatian.

## B. Project Architecture Overview
- Struktur arsitektur.
- State management.
- Dependency flow.
- Data flow.

## C. Critical & High Findings
Temuan paling berisiko beserta bukti dan dampaknya.

## D. Detailed Bug Report
Setiap temuan berisi:
- ID.
- Kategori.
- Severity.
- Confidence.
- File path.
- Line number.
- Code reference.
- Root cause.
- Impact.
- Reproduction scenario jika memungkinkan.
- Recommended solution.

## E. Memory & Resource Leak Report

## F. Duplicate & Dead Code Report

## G. Performance Report

## H. Security Report

## I. Architecture & Maintainability Report

## J. Dependency & Compatibility Report

## K. Testing Gap Report

## L. Recommended Action Plan

Kelompokkan:
- P0: Segera ditangani.
- P1: Prioritas tinggi.
- P2: Perbaikan menengah.
- P3: Improvement jangka panjang.

## M. Final Assessment
Berikan penilaian objektif terhadap:
- Code quality.
- Stability.
- Performance.
- Security.
- Architecture.
- Maintainability.

# FINAL RESTRICTIONS

1. Ini adalah ANALYSIS ONLY.
2. Jangan memperbaiki bug.
3. Jangan melakukan refactoring.
4. Jangan mengubah satu baris kode pun.
5. Jangan membuat file laporan di dalam project.
6. Jangan menjalankan perintah yang mengubah project state.
7. Jangan mengasumsikan temuan tanpa bukti.
8. Berikan laporan langsung di terminal/chat.
9. Berhenti setelah audit selesai.
10. Tunggu persetujuan dan instruksi berikutnya sebelum melakukan tindakan apa pun.

**EXPECTED OUTPUT: COMPLETE FLUTTER CODE AUDIT REPORT — READ ONLY — ZERO CODE MODIFICATION.**