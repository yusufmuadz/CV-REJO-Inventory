# cv_rejo

A new Flutter project.

## Jenis-Jenis Push GitHub

Berikut adalah beberapa jenis push yang umum digunakan saat bekerja dengan Git dan GitHub:

### 1. `git push` (Simple Push)

Melakukan push dari branch lokal yang sedang aktif ke branch dengan nama yang sama di remote (biasanya `origin`).

```bash
git push
```

### 2. `git push origin <branch>`

Push branch lokal tertentu ke branch yang sama di remote.

```bash
git push origin main
```

### 3. `git push -u origin <branch>` (Set Upstream)

Push branch baru dan sekaligus menghubungkannya dengan branch remote (upstream). Berguna agar bisa menggunakan `git push` tanpa menyebut nama branch.

```bash
git push -u origin feature/login
```

### 4. `git push --force` atau `git push -f` (Force Push)

Memaksa push untuk menimpa history di remote. **Hati-hati**, bisa menghapus commit orang lain. Umumnya digunakan setelah `rebase` lokal.

```bash
git push --force
```

### 5. `git push --force-with-lease` (Safe Force Push)

Versi aman dari force push. Hanya akan menimpa jika remote masih sesuai dengan yang kita harapkan (tidak ada perubahan baru dari rekan tim).

```bash
git push --force-with-lease
```

### 6. `git push --all`

Push semua branch lokal ke remote sekaligus.

```bash
git push --all
```

### 7. `git push --tags`

Mengirim semua tag yang ada di repo lokal ke remote.

```bash
git push --tags
```

### 8. `git push origin <branch> --delete` (Delete Remote Branch)

Menghapus branch tertentu dari remote.

```bash
git push origin feature/login --delete
```

---

## Conventional Commits

Berikut adalah beberapa prefix yang umum digunakan dalam penulisan commit message sesuai standar [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix     | Kegunaan                                                | Contoh                               |
| ---------- | ------------------------------------------------------- | ------------------------------------ |
| `feat`     | Menambah fitur baru                                     | `feat: add login page`               |
| `fix`      | Memperbaiki bug                                         | `fix: fix controller disposal issue` |
| `refactor` | Mengubah struktur kode tanpa mengubah behavior          | `refactor: simplify auth service`    |
| `style`    | Perubahan tampilan/formatting yang tidak mengubah logic | `style: update button spacing`       |
| `docs`     | Perubahan dokumentasi                                   | `docs: update README`                |
| `test`     | Menambah/memperbaiki testing                            | `test: add login test`               |
| `chore`    | Maintenance/configurasi                                 | `chore: update dependencies`         |
| `perf`     | Optimasi performa                                       | `perf: optimize image loading`       |
| `build`    | Perubahan build/dependency                              | `build: update gradle config`        |
| `ci`       | Perubahan CI/CD                                         | `ci: update github actions`          |
| `revert`   | Membatalkan commit sebelumnya                           | `revert: revert login changes`       |

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
