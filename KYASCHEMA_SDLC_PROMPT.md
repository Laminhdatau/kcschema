# KYASCHEMA — Prompt SDLC Lengkap (untuk AI Coding Agent)

> Salin seluruh isi dokumen ini sebagai satu prompt awal ke Cursor / Claude Code / Windsurf / Gemini CLI untuk memulai development aplikasi.

---

## 1. Latar Belakang & Tujuan

Saya seorang **teknisi service HP** yang mengelola KYACODETECH SOLUTION (repair + software development). Saya sering menemukan file **skematik (schematic) PDF** untuk berbagai merk & tipe HP (contoh: Redmi Note 8, Samsung A03, dll), tapi file-file ini tersebar tidak terorganisir di laptop.

Saya tidak mampu membeli software premium seperti **Borneo Schematic Hardware Solution** yang berbayar mahal. Maka saya ingin membangun aplikasi desktop sendiri: **KYASCHEMA** — sebuah tool **manajemen folder + viewer PDF** khusus untuk menyimpan, mengorganisir, dan membuka skematik HP secara cepat saat sedang bongkar unit di meja service.

**Tujuan utama:** saat menemukan skematik baru, saya bisa import PDF → sistem otomatis (atau manual) mengelompokkan ke `Merk > Tipe HP > Kategori Blok Rangkaian` (misalnya Charging, LCD Display, Audio, dll) → saat butuh saya tinggal cari & klik, PDF langsung terbuka di dalam aplikasi (bukan buka aplikasi PDF reader terpisah).

---

## 2. Target Pengguna

- Single-user, dipakai sendiri di meja service.
- Offline-first — tidak butuh internet, tidak butuh akun/login.
- Data disimpan 100% lokal di PC/laptop teknisi.

---

## 3. Tech Stack

- **Framework:** Flutter Desktop (target Windows utama, opsional build Linux/macOS di kemudian hari)
- **State management:** Riverpod
- **Routing:** GoRouter
- **Database lokal:** SQLite via Drift (metadata: merk, tipe, kategori, tag, path file)
- **PDF rendering:** `pdfrx` atau `syncfusion_flutter_pdfviewer` (pilih yang mendukung zoom halus + render cepat untuk file skematik beresolusi tinggi/besar)
- **File system access:** `file_picker`, `path_provider`, `watcher` (opsional, untuk deteksi file baru di folder watch)
- **Tidak ada backend server** — murni local desktop app.

---

## 4. Konsep Struktur Data

Hierarki logis (bukan berarti harus 1:1 dengan struktur folder fisik — database yang jadi sumber kebenaran, folder fisik hanya lokasi penyimpanan file):

```
Merk (Brand)
 └── Tipe HP (Model)
      └── Kategori Blok Rangkaian (Category)
           └── File Skematik (PDF)
```

**Kategori default yang perlu di-seed di awal** (bisa ditambah/edit manual oleh user nanti):
- Charging / Data (Charging Ways)
- LCD / Display
- Touchscreen
- Power Amplifier (PA) / Sinyal
- Audio (Mic, Speaker, Earpiece)
- Camera
- WiFi / Bluetooth
- Power / PMIC / EFUSE
- Baseband / IMEI
- Fingerprint
- Full Schematic (skema lengkap 1 board)
- Lainnya (custom, bisa tambah kategori baru)

Satu file PDF bisa punya **lebih dari satu tag kategori** (misalnya file skema lengkap yang mencakup Charging + Audio sekaligus).

---

## 5. Fitur Utama (Functional Requirements)

### 5.1 Manajemen Folder/Data
- Tambah Merk baru (contoh: Xiaomi, Samsung, Oppo, Vivo, Infinix, dll) — bisa custom.
- Tambah Tipe HP di bawah Merk (contoh: Redmi Note 8, Redmi Note 8 Pro).
- Import file PDF ke Tipe HP tertentu, lalu assign 1 atau lebih Kategori (tag) ke file tersebut.
- Saat import: file **disalin (copy)** ke folder data internal aplikasi yang terstruktur otomatis, contoh:
  ```
  KyaSchemaData/
    Xiaomi/
      Redmi Note 8/
        Charging/
          redmi_note_8_charging_ways.pdf
        LCD/
          redmi_note_8_display.pdf
  ```
  (User tidak perlu mengatur folder fisik manual — cukup pilih Merk/Tipe/Kategori dari UI, aplikasi yang mengatur path di belakang layar.)
- Rename, pindah kategori, hapus file (dengan konfirmasi, soft delete ke folder `_trash` dulu supaya tidak hilang permanen secara tidak sengaja).
- Bulk import: pilih banyak PDF sekaligus, assign Merk/Tipe/Kategori yang sama secara massal.

### 5.2 PDF Viewer Terintegrasi
- Klik file di list → langsung terbuka di panel viewer dalam aplikasi (tidak keluar ke app lain).
- Zoom in/out (pinch/scroll), pan/geser, fit-to-width, fit-to-page.
- Rotate halaman (skematik kadang di-scan miring).
- Navigasi multi-halaman (thumbnail sidebar untuk skema yang punya banyak halaman/blok).
- Tombol "buka di aplikasi PDF eksternal" sebagai fallback opsional.

### 5.3 Pencarian & Navigasi
- Search bar global: cari berdasarkan nama Tipe HP, nama file, atau tag kategori.
- Filter kombinasi: pilih Merk → otomatis tampil daftar Tipe HP → pilih Kategori → tampil file yang relevan.
- **Recent Files**: daftar file yang terakhir dibuka (misal 10 terakhir), untuk akses cepat berulang.
- **Favorit/Bookmark**: tandai bintang pada Tipe HP atau file yang sering dipakai.

### 5.4 Tagging Tambahan (opsional tapi berguna)
- Tag bebas (custom label) di luar kategori default, misal: "sering rusak", "butuh jumper", "cek lagi".
- Catatan/notes teks pendek per file (misal: "titik ukur tegangan ada di pin 3, hasil pengukuran normal 4.2V").

### 5.5 Backup & Restore
- Export seluruh database + folder data (`KyaSchemaData`) jadi satu file `.zip` untuk backup/pindah PC.
- Import kembali dari file backup `.zip`.

### 5.6 Statistik Ringan (opsional, nice-to-have)
- Total jumlah skema tersimpan.
- Merk/Tipe dengan jumlah skema terbanyak.

---

## 6. Struktur Database (Drift/SQLite)

```
Table: brands
  id (PK), name, created_at

Table: models
  id (PK), brand_id (FK), name, is_favorite, created_at

Table: categories
  id (PK), name, is_default (bool), icon_key

Table: schematics
  id (PK), model_id (FK), file_name, file_path (relatif ke folder data),
  original_file_name, notes (text, nullable), is_favorite,
  imported_at, last_opened_at

Table: schematic_categories  (many-to-many)
  schematic_id (FK), category_id (FK)

Table: schematic_tags  (tag bebas, many-to-many)
  schematic_id (FK), tag_id (FK)

Table: tags
  id (PK), name
```

---

## 7. UI/UX Layout

**Layout 3 panel (desktop, resizable panes):**

1. **Panel kiri (sidebar tree)**
   - Tree navigasi: Merk → Tipe HP → Kategori.
   - Search bar di paling atas.
   - Section "⭐ Favorit" dan "🕓 Recent Files" pinned di atas tree.

2. **Panel tengah (list file)**
   - Menampilkan daftar file skematik sesuai filter yang aktif di sidebar.
   - Tampilan grid/list toggle, thumbnail preview mini PDF (halaman pertama).
   - Info singkat: nama file, tanggal import, kategori/tag.

3. **Panel kanan (PDF viewer)**
   - Terbuka otomatis saat file diklik.
   - Toolbar: zoom, rotate, fit-page, halaman berikut/sebelumnya, tombol close viewer.

**Tema visual:** Dark mode dengan aksen neon green/glassmorphism (konsisten dengan brand KYACODETECH), karena dipakai di ruangan kerja teknisi yang sering low-light.

**Bahasa UI:** Bahasa Indonesia penuh.

---

## 8. Non-Functional Requirements

- **Performa:** Harus tetap responsif walau database berisi ratusan/ribuan file PDF (gunakan lazy-loading/pagination pada list, jangan render semua thumbnail sekaligus).
- **Offline-only:** Tidak ada dependency ke internet/API eksternal.
- **Single executable:** Hasil akhir berupa installer Windows (.exe/.msix) yang mudah dijalankan tanpa setup rumit.
- **Data safety:** Semua operasi hapus file harus soft-delete dulu (folder `_trash` internal), agar tidak ada risiko kehilangan skema langka secara permanen.
- **Portabilitas:** Folder `KyaSchemaData` + file database harus bisa dipindah ke PC lain dan langsung terbaca ulang (self-contained, tidak ada path absolut yang di-hardcode).

---

## 9. Instruksi untuk AI Coding Agent

1. Setup project Flutter Desktop (Windows target) dengan struktur folder standar: `lib/features/{brands,models,categories,schematics,viewer,backup}`, `lib/core/{database,theme,router}`.
2. Implementasikan skema database Drift sesuai bagian 6 di atas, lengkap dengan migration awal (seed kategori default dari bagian 4).
3. Bangun state management dengan Riverpod (provider per fitur: brandListProvider, modelListProvider, schematicListProvider, dst).
4. Implementasikan UI 3-panel sesuai bagian 7, responsive terhadap resize window.
5. Implementasikan flow import file: pilih PDF → dialog assign Merk (buat baru atau pilih existing) → Tipe HP → Kategori (multi-select) → copy file ke folder terstruktur → simpan metadata ke database.
6. Integrasikan PDF viewer dengan kontrol zoom/pan/rotate/navigasi halaman.
7. Implementasikan search & filter, recent files, favorit.
8. Implementasikan backup/restore ke `.zip`.
9. Build installer Windows di akhir.

Kerjakan bertahap: mulai dari setup project + database schema + seed kategori dulu, baru lanjut ke UI tree navigasi, baru fitur import, baru PDF viewer, baru search/favorit/backup — supaya bisa saya review tiap tahap.
