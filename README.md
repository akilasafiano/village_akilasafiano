# Village Info API – Sistem Informasi Penjadwalan Kegiatan Desa

## Studi Kasus
Dibutuhkan sistem informasi penjadwalan kegiatan desa untuk mendukung **keamanan dan kebersihan**
lingkungan, yaitu menjadwalkan **siskamling (ronda malam)**, **gotong royong / kerja bakti**, dan
**rapat warga**. Sistem ini membutuhkan fitur:

1. Pendataan wilayah RT/RW/dusun dan data warga beserta profilnya.
2. Pengelompokan kegiatan berdasarkan kategori (siskamling, kerja bakti, rapat warga).
3. Penjadwalan kegiatan per wilayah (tanggal, jam, lokasi, status).
4. Pencatatan peserta dan kehadiran warga pada setiap kegiatan.
5. Pengumuman kegiatan dari warga/pengurus kepada warga lain.

## Teknologi
Node.js, Express.js, PostgreSQL (`pg`), dotenv.

## Struktur Database (7 tabel)
| Tabel | Keterangan | Relasi |
|---|---|---|
| `neighborhoods` | Wilayah RT/RW/dusun | 1 – N ke `residents`, 1 – N ke `activities` |
| `residents` | Data warga | N – 1 ke `neighborhoods` |
| `resident_profiles` | Profil detail warga | **1 – 1** dengan `residents` |
| `activity_categories` | Kategori kegiatan | 1 – N ke `activities` |
| `activities` | Jadwal kegiatan | N – 1 ke kategori & wilayah |
| `activity_participants` | Peserta kegiatan | **N – N** `residents` ↔ `activities` |
| `announcements` | Pengumuman | N – 1 ke `residents` & `activities` |

## Cara Menjalankan
```bash
# 1. Install dependency
npm install

# 2. Buat database
psql -U postgres -c "CREATE DATABASE village_info_db;"

# 3. Jalankan skema dan data contoh
psql -U postgres -d village_info_db -f sql/schema.sql
psql -U postgres -d village_info_db -f sql/seed.sql

# 4. Salin .env.example menjadi .env lalu isi password PostgreSQL
cp .env.example .env

# 5. Jalankan server
npm start
```

## Endpoint (tabel `activities`)
| Method | URL | Keterangan |
|---|---|---|
| GET | `/api/activities` | Ambil semua kegiatan |
| GET | `/api/activities/:id` | Ambil kegiatan berdasarkan ID |
| POST | `/api/activities` | Buat kegiatan baru |
| PUT | `/api/activities/:id` | Perbarui kegiatan |
| DELETE | `/api/activities/:id` | Hapus kegiatan |

Contoh body POST/PUT:
```json
{
  "category_id": 2,
  "neighborhood_id": 1,
  "title": "Kerja Bakti Perbaikan Jalan",
  "description": "Menambal jalan berlubang",
  "location": "Jl. Melati",
  "activity_date": "2026-11-22",
  "start_time": "07:00",
  "end_time": "11:00"
}
```

Koleksi Postman ada di `postman/village-info-api.postman_collection.json` (Import di Postman).
