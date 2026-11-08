-- =====================================================================
-- Sistem Informasi Penjadwalan Kegiatan Desa (Siskamling & Gotong Royong)
-- Database: PostgreSQL
-- =====================================================================
-- Relasi:
--   ONE TO ONE   : residents (1) --- (1) resident_profiles
--   ONE TO MANY  : neighborhoods (1) --- (N) residents
--                  neighborhoods (1) --- (N) activities
--                  activity_categories (1) --- (N) activities
--                  residents (1) --- (N) announcements
--                  activities (1) --- (N) announcements
--   MANY TO MANY : residents (N) --- (N) activities
--                  melalui tabel penghubung activity_participants
-- =====================================================================

DROP TABLE IF EXISTS announcements CASCADE;
DROP TABLE IF EXISTS activity_participants CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS activity_categories CASCADE;
DROP TABLE IF EXISTS resident_profiles CASCADE;
DROP TABLE IF EXISTS residents CASCADE;
DROP TABLE IF EXISTS neighborhoods CASCADE;

-- 1. Wilayah RT/RW
CREATE TABLE neighborhoods (
    id           SERIAL PRIMARY KEY,
    rt           VARCHAR(3)   NOT NULL,
    rw           VARCHAR(3)   NOT NULL,
    hamlet_name  VARCHAR(100) NOT NULL,
    UNIQUE (rt, rw, hamlet_name)
);

-- 2. Warga (ONE TO MANY dari neighborhoods)
CREATE TABLE residents (
    id               SERIAL PRIMARY KEY,
    neighborhood_id  INT          NOT NULL REFERENCES neighborhoods(id) ON DELETE RESTRICT,
    nik              CHAR(16)     NOT NULL UNIQUE,
    full_name        VARCHAR(100) NOT NULL,
    phone            VARCHAR(20),
    address          TEXT,
    created_at       TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 3. Profil warga (ONE TO ONE dengan residents)
CREATE TABLE resident_profiles (
    id              SERIAL PRIMARY KEY,
    resident_id     INT         NOT NULL UNIQUE REFERENCES residents(id) ON DELETE CASCADE,
    birth_date      DATE,
    gender          VARCHAR(10) CHECK (gender IN ('laki-laki', 'perempuan')),
    occupation      VARCHAR(100),
    marital_status  VARCHAR(20),
    photo_url       TEXT
);

-- 4. Kategori kegiatan (siskamling, kerja bakti, dll)
CREATE TABLE activity_categories (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(50) NOT NULL UNIQUE,
    description  TEXT
);

-- 5. Kegiatan / jadwal (ONE TO MANY dari activity_categories & neighborhoods)
CREATE TABLE activities (
    id               SERIAL PRIMARY KEY,
    category_id      INT          NOT NULL REFERENCES activity_categories(id) ON DELETE RESTRICT,
    neighborhood_id  INT          NOT NULL REFERENCES neighborhoods(id) ON DELETE RESTRICT,
    title            VARCHAR(150) NOT NULL,
    description      TEXT,
    location         VARCHAR(150),
    activity_date    DATE         NOT NULL,
    start_time       TIME,
    end_time         TIME,
    status           VARCHAR(20)  NOT NULL DEFAULT 'terjadwal'
                     CHECK (status IN ('terjadwal', 'berlangsung', 'selesai', 'dibatalkan')),
    created_at       TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 6. Peserta kegiatan (MANY TO MANY: residents <-> activities)
CREATE TABLE activity_participants (
    activity_id        INT         NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
    resident_id        INT         NOT NULL REFERENCES residents(id)  ON DELETE CASCADE,
    role               VARCHAR(30) NOT NULL DEFAULT 'peserta',
    attendance_status  VARCHAR(20) NOT NULL DEFAULT 'belum_hadir'
                       CHECK (attendance_status IN ('belum_hadir', 'hadir', 'izin', 'alpa')),
    PRIMARY KEY (activity_id, resident_id)
);

-- 7. Pengumuman (ONE TO MANY dari residents sebagai penulis & activities)
CREATE TABLE announcements (
    id            SERIAL PRIMARY KEY,
    author_id     INT          NOT NULL REFERENCES residents(id) ON DELETE CASCADE,
    activity_id   INT          REFERENCES activities(id) ON DELETE SET NULL,
    title         VARCHAR(150) NOT NULL,
    content       TEXT         NOT NULL,
    published_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_residents_neighborhood ON residents(neighborhood_id);
CREATE INDEX idx_activities_date        ON activities(activity_date);
