INSERT INTO neighborhoods (rt, rw, hamlet_name) VALUES
('01', '01', 'Dusun Krajan'),
('02', '01', 'Dusun Krajan'),
('01', '02', 'Dusun Karangrejo');

INSERT INTO residents (neighborhood_id, nik, full_name, phone, address) VALUES
(1, '3578010101900001', 'Budi Santoso',  '081234560001', 'Jl. Mawar No. 1'),
(1, '3578010202910002', 'Siti Aminah',   '081234560002', 'Jl. Mawar No. 5'),
(2, '3578010303920003', 'Agus Pratama',  '081234560003', 'Jl. Melati No. 3'),
(3, '3578010404930004', 'Dewi Lestari',  '081234560004', 'Jl. Kenanga No. 8');

INSERT INTO resident_profiles (resident_id, birth_date, gender, occupation, marital_status) VALUES
(1, '1990-01-01', 'laki-laki', 'Petani',  'menikah'),
(2, '1991-02-02', 'perempuan', 'Guru',    'menikah'),
(3, '1992-03-03', 'laki-laki', 'Pedagang','belum menikah'),
(4, '1993-04-04', 'perempuan', 'Bidan',   'menikah');

INSERT INTO activity_categories (name, description) VALUES
('Siskamling',   'Ronda malam menjaga keamanan lingkungan'),
('Kerja Bakti',  'Gotong royong membersihkan lingkungan desa'),
('Rapat Warga',  'Musyawarah dan rapat warga');

INSERT INTO activities (category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time) VALUES
(1, 1, 'Ronda Malam RT 01', 'Jadwal ronda malam Sabtu', 'Pos Kamling RT 01', '2026-11-14', '22:00', '04:00'),
(2, 1, 'Kerja Bakti Bersih Selokan', 'Membersihkan selokan utama', 'Jl. Mawar', '2026-11-15', '07:00', '10:00'),
(3, 2, 'Rapat Warga RT 02', 'Bahas iuran kebersihan', 'Balai Desa', '2026-11-20', '19:30', '21:00');

INSERT INTO activity_participants (activity_id, resident_id, role, attendance_status) VALUES
(1, 1, 'ketua regu', 'belum_hadir'),
(1, 2, 'peserta',    'belum_hadir'),
(2, 1, 'koordinator','belum_hadir'),
(2, 3, 'peserta',    'belum_hadir'),
(3, 4, 'peserta',    'belum_hadir');

INSERT INTO announcements (author_id, activity_id, title, content) VALUES
(1, 2, 'Kerja Bakti Minggu Pagi', 'Mohon warga membawa cangkul dan sapu masing-masing.'),
(2, 3, 'Undangan Rapat Warga',    'Rapat dimulai pukul 19.30 WIB di Balai Desa.');
