# 🎓 Aplikasi Pencatatan Poin Siswa (SIPOIN)

Aplikasi berbasis *mobile* yang dikembangkan menggunakan **Flutter** untuk memudahkan sekolah (Guru & Siswa) dalam mencatat, melacak, dan mengelola poin kedisiplinan dan prestasi siswa secara terpadu.

---

## ✨ Fitur Utama

Aplikasi ini memiliki sistem otentikasi dengan dua jenis peran (*Role-based Access Control*):

### 👨‍🏫 Fitur Guru (Admin)
- **Manajemen Data Siswa:** Menambahkan, mengedit, dan menghapus profil siswa.
- **Input Catatan Poin:** Memberikan poin pelanggaran atau poin prestasi langsung kepada siswa beserta rincian catatannya.
- **Manajemen Jenis Catatan:** Mengatur daftar jenis pelanggaran dan prestasi beserta bobot poin masing-masing.
- **Riwayat Aktivitas:** Melihat aktivitas terakhir terkait pencatatan poin yang masuk.

### 👨‍🎓 Fitur Siswa
- **Dashboard Poin:** Melihat secara real-time akumulasi total poin Prestasi dan Pelanggaran yang dimiliki.
- **Detail Riwayat Poin:** Melihat rincian kapan dan mengapa suatu poin pelanggaran atau prestasi diberikan.

---

## 🛠️ Teknologi yang Digunakan

- **Frontend:** Flutter & Dart (Provider untuk *State Management*)
- **Backend API:** Node.js (Express.js)
- **Database:** MySQL / PostgreSQL *(disesuaikan dengan skema)*
- **Desain UI:** Modern UI dengan gaya *Glassmorphism* dan *Card-based layout*.

---

## 🚀 Cara Instalasi & Menjalankan Aplikasi

### 1. Persiapan Backend (API Server)
1. Buka folder `API/` di terminal Anda.
2. Jalankan perintah instalasi dependensi:
   ```bash
   npm install
   ```
3. Sesuaikan konfigurasi database Anda di dalam file konfigurasi server.
4. Jalankan server:
   ```bash
   node app.js
   ```
   *Server secara default akan berjalan di port `3000`.*

### 2. Persiapan Frontend (Flutter)
1. Pastikan Anda sudah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Buka folder utama proyek ini (`crud/`) di terminal.
3. Unduh semua *packages* yang dibutuhkan:
   ```bash
   flutter pub get
   ```
4. **PENTING:** Konfigurasi koneksi API.
   Buka file `lib/service/config.dart`.
   - Jika Anda menjalankan via **HP Fisik**, ubah `baseUrl` dengan IP Address WiFi komputer Anda (Contoh: `http://192.168.1.10:3000`).
   - Jika menggunakan **Emulator Android**, gunakan `http://10.0.2.2:3000`.
5. Jalankan aplikasi ke perangkat yang terhubung:
   ```bash
   flutter run
   ```

---

*Dikembangkan untuk kemudahan manajemen kedisiplinan sekolah yang lebih modern dan transparan.*
