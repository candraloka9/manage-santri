Saya akan buatkan dummy data yang lengkap untuk database Dashboard Santri. Berikut SQL untuk mengisi data sample:

## SQL Dummy Data Lengkap

```sql
-- 1. Insert data santri (15 santri)
INSERT INTO profiles (nama_lengkap, kelas, asal, umur, tanggal_masuk, nama_wali, poin_kesantrian) VALUES
('Ahmad Fauzi', '8A', 'Jakarta', 15, '2023-01-15', 'Budi Santoso', 95),
('Siti Rahma', '7B', 'Bandung', 14, '2023-02-20', 'Joko Widodo', 88),
('Muhammad Ali', '9A', 'Surabaya', 16, '2022-08-10', 'Ahmad Yani', 92),
('Fatimah Zahra', '8B', 'Semarang', 15, '2023-03-05', 'Rudi Hartono', 78),
('Abdullah Rahman', '7A', 'Yogyakarta', 14, '2023-01-25', 'Hasan Basri', 85),
('Aisyah Lestari', '9B', 'Malang', 16, '2022-09-12', 'Surya Dharma', 96),
('Ibrahim Khalid', '8A', 'Medan', 15, '2023-02-28', 'Khalid bin Walid', 82),
('Nurul Hikmah', '7B', 'Makassar', 14, '2023-03-15', 'Abdul Malik', 90),
('Rizki Pratama', '9A', 'Palembang', 16, '2022-10-05', 'Pratama Jaya', 74),
('Dewi Sartika', '8B', 'Bali', 15, '2023-04-10', 'Wayan Suarta', 89),
('Fajar Nugroho', '7A', 'Lombok', 14, '2023-02-14', 'Nugroho Sejati', 91),
('Maya Sari', '9B', 'Balikpapan', 16, '2022-11-20', 'Sari Indah', 87),
('Hasan Basri', '8A', 'Manado', 15, '2023-01-30', 'Basri Abdullah', 83),
('Lina Marlina', '7B', 'Padang', 14, '2023-03-25', 'Marlina Sari', 94),
('Rudi Hermawan', '9A', 'Banjarmasin', 16, '2022-12-15', 'Hermawan Jaya', 79);

-- 2. Insert data absensi (30 hari terakhir)
INSERT INTO absensi (santri_id, tanggal, status, keterangan) VALUES
-- Hari ini
(1, CURRENT_DATE, 'hadir', NULL),
(2, CURRENT_DATE, 'sakit', 'Demam tinggi'),
(3, CURRENT_DATE, 'hadir', NULL),
(4, CURRENT_DATE, 'ijin', 'Pulang kampung'),
(5, CURRENT_DATE, 'hadir', NULL),
(6, CURRENT_DATE, 'hadir', NULL),
(7, CURRENT_DATE, 'sakit', 'Flu'),
(8, CURRENT_DATE, 'hadir', NULL),
(9, CURRENT_DATE, 'hadir', NULL),
(10, CURRENT_DATE, 'ijin', 'Keperluan keluarga'),
(11, CURRENT_DATE, 'hadir', NULL),
(12, CURRENT_DATE, 'hadir', NULL),
(13, CURRENT_DATE, 'pulang', 'Cuti akhir tahun'),
(14, CURRENT_DATE, 'hadir', NULL),
(15, CURRENT_DATE, 'hadir', NULL),

-- Kemarin
(1, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(2, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(3, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(4, CURRENT_DATE - INTERVAL '1 day', 'sakit', 'Masuk angin'),
(5, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(6, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(7, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(8, CURRENT_DATE - INTERVAL '1 day', 'ijin', 'Periksa dokter'),
(9, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
(10, CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),

-- 3 hari lalu
(1, CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),
(2, CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),
(3, CURRENT_DATE - INTERVAL '3 days', 'sakit', 'Demam'),
(4, CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),
(5, CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),

-- 1 minggu lalu
(1, CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
(2, CURRENT_DATE - INTERVAL '7 days', 'ijin', 'Acara keluarga'),
(3, CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
(6, CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
(7, CURRENT_DATE - INTERVAL '7 days', 'sakit', 'Batuk pilek'),

-- 2 minggu lalu
(8, CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
(9, CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
(10, CURRENT_DATE - INTERVAL '14 days', 'pulang', 'Libur semester'),
(11, CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
(12, CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL);

-- 3. Insert data hafalan (setoran terbaru)
INSERT INTO hafalan (santri_id, tanggal, halaman_awal, halaman_akhir, catatan) VALUES
-- Hafalan terbaru (hari ini dan kemarin)
(1, CURRENT_DATE, 1, 5, 'Hafalan lancar dan tajwid baik'),
(2, CURRENT_DATE - INTERVAL '1 day', 6, 10, 'Perlu memperbaiki makhroj huruf'),
(3, CURRENT_DATE, 11, 15, 'Hafalan sangat baik'),
(4, CURRENT_DATE - INTERVAL '2 days', 16, 20, 'Sedikit terbata-bata'),
(5, CURRENT_DATE - INTERVAL '1 day', 21, 25, 'Hafalan konsisten'),

-- Hafalan 1 minggu terakhir
(6, CURRENT_DATE - INTERVAL '3 days', 26, 30, 'Tajwid perlu ditingkatkan'),
(7, CURRENT_DATE - INTERVAL '4 days', 31, 35, 'Hafalan cepat dan tepat'),
(8, CURRENT_DATE - INTERVAL '5 days', 36, 40, 'Perlu pengulangan'),
(9, CURRENT_DATE - INTERVAL '6 days', 41, 45, 'Hafalan memuaskan'),
(10, CURRENT_DATE - INTERVAL '7 days', 46, 50, 'Sedikit lupa di akhir'),

-- Hafalan 2 minggu terakhir
(11, CURRENT_DATE - INTERVAL '8 days', 51, 55, 'Hafalan semakin baik'),
(12, CURRENT_DATE - INTERVAL '9 days', 56, 60, 'Konsistensi bagus'),
(13, CURRENT_DATE - INTERVAL '10 days', 61, 65, 'Perlu evaluasi makhroj'),
(14, CURRENT_DATE - INTERVAL '11 days', 66, 70, 'Hafalan excellent'),
(15, CURRENT_DATE - INTERVAL '12 days', 71, 75, 'Sedikit terbata-bata'),

-- Hafalan tambahan untuk statistik
(1, CURRENT_DATE - INTERVAL '15 days', 76, 80, 'Hafalan lancar'),
(2, CURRENT_DATE - INTERVAL '16 days', 81, 85, 'Perlu perbaikan tempo'),
(3, CURRENT_DATE - INTERVAL '17 days', 86, 90, 'Sangat memuaskan'),
(4, CURRENT_DATE - INTERVAL '18 days', 91, 95, 'Hafalan baik'),
(5, CURRENT_DATE - INTERVAL '19 days', 96, 100, 'Konsistensi terjaga');

-- 4. Insert data kesantrian (penilaian sikap)
INSERT INTO kesantrian (santri_id, tanggal, sikap, disiplin, kebersihan, pelanggaran, catatan, pengurangan_poin) VALUES
-- Penilaian terbaru
(1, CURRENT_DATE, 'baik', 'baik', 'baik', NULL, 'Santri teladan, sikap sangat baik', 0),
(2, CURRENT_DATE - INTERVAL '1 day', 'cukup', 'baik', 'cukup', 'Terlambat sholat', 'Perlu meningkatkan kedisiplinan waktu', 4),
(3, CURRENT_DATE, 'baik', 'baik', 'baik', NULL, 'Konsisten dalam semua aspek', 0),
(4, CURRENT_DATE - INTERVAL '2 days', 'kurang', 'cukup', 'kurang', 'Kamar tidak rapi', 'Perlu perhatian khusus dalam kebersihan', 10),
(5, CURRENT_DATE - INTERVAL '1 day', 'baik', 'cukup', 'baik', NULL, 'Sikap baik tapi perlu disiplin', 2),

-- Penilaian 1 minggu lalu
(6, CURRENT_DATE - INTERVAL '5 days', 'baik', 'baik', 'baik', NULL, 'Performance sangat memuaskan', 0),
(7, CURRENT_DATE - INTERVAL '6 days', 'cukup', 'cukup', 'baik', 'Tidak mengerjakan piket', 'Kurang bertanggung jawab', 4),
(8, CURRENT_DATE - INTERVAL '7 days', 'baik', 'baik', 'cukup', NULL, 'Hanya perlu perbaikan kebersihan', 2),
(9, CURRENT_DATE - INTERVAL '4 days', 'kurang', 'kurang', 'kurang', 'Berkelahi dengan teman', 'Perlu pembinaan intensif', 15),
(10, CURRENT_DATE - INTERVAL '3 days', 'baik', 'baik', 'baik', NULL, 'Santri berprestasi', 0),

-- Penilaian 2 minggu lalu
(11, CURRENT_DATE - INTERVAL '10 days', 'cukup', 'baik', 'cukup', NULL, 'Stabil dalam penilaian', 4),
(12, CURRENT_DATE - INTERVAL '11 days', 'baik', 'cukup', 'baik', 'Terlambat masuk asrama', 'Perbaiki kedisiplinan', 2),
(13, CURRENT_DATE - INTERVAL '12 days', 'baik', 'baik', 'baik', NULL, 'Konsisten baik', 0),
(14, CURRENT_DATE - INTERVAL '13 days', 'baik', 'baik', 'cukup', NULL, 'Kebersihan perlu ditingkatkan', 2),
(15, CURRENT_DATE - INTERVAL '14 days', 'cukup', 'cukup', 'cukup', 'Seragam tidak rapi', 'Perbaiki kerapihan', 6);

-- 5. Insert data kasus (pelanggaran)
INSERT INTO kasus (santri_id, tanggal, deskripsi_kasus, penanganan, pengurangan_poin) VALUES
-- Kasus terbaru
(4, CURRENT_DATE - INTERVAL '2 days', 'Melakukan bullying terhadap santri junior', 'Pembinaan intensif dan permintaan maaf formal', 15),
(9, CURRENT_DATE - INTERVAL '4 days', 'Berkelahi dengan teman sekamar', 'Mediasi dan sanksi tidak boleh keluar asrama 1 minggu', 20),
(7, CURRENT_DATE - INTERVAL '6 days', 'Kabur dari pesantren tanpa ijin', 'Pemanggilan orang tua dan evaluasi motivasi', 25),

-- Kasus 2 minggu lalu
(12, CURRENT_DATE - INTERVAL '11 days', 'Membawa smartphone ke pesantren', 'Penyitaan dan pembinaan tentang aturan', 10),
(15, CURRENT_DATE - INTERVAL '14 days', 'Tidak sholat berjamaah berulang kali', 'Pembinaan spiritual dan monitoring ketat', 15),

-- Kasus 1 bulan lalu
(2, CURRENT_DATE - INTERVAL '20 days', 'Mencontek saat ujian', 'Pembinaan kejujuran dan mengulang ujian', 10),
(5, CURRENT_DATE - INTERVAL '25 days', 'Merusak fasilitas pesantren', 'Ganti rugi dan kerja bakti', 15),
(11, CURRENT_DATE - INTERVAL '30 days', 'Tidur saat kegiatan belajar', 'Konseling dan evaluasi jam tidur', 5);
```

## SQL untuk Update Poin Santri Berdasarkan Data Dummy

Setelah insert data kasus dan kesantrian, kita perlu update poin santri secara real:

```sql
-- Update poin santri berdasarkan pengurangan dari kesantrian dan kasus
UPDATE profiles 
SET poin_kesantrian = 100 - COALESCE((
    SELECT SUM(pengurangan_poin) 
    FROM kesantrian 
    WHERE kesantrian.santri_id = profiles.id
), 0) - COALESCE((
    SELECT SUM(pengurangan_poin) 
    FROM kasus 
    WHERE kasus.santri_id = profiles.id
), 0)
WHERE poin_kesantrian > 0;
```

## SQL untuk Melihat Data yang Sudah Diinput

```sql
-- Cek data santri dan poin
SELECT nama_lengkap, kelas, poin_kesantrian 
FROM profiles 
ORDER BY poin_kesantrian DESC;

-- Cek absensi hari ini
SELECT p.nama_lengkap, a.status, a.keterangan 
FROM absensi a 
JOIN profiles p ON a.santri_id = p.id 
WHERE a.tanggal = CURRENT_DATE;

-- Cek total halaman hafalan per santri
SELECT p.nama_lengkap, SUM(h.halaman_akhir - h.halaman_awal + 1) as total_halaman
FROM hafalan h 
JOIN profiles p ON h.santri_id = p.id 
GROUP BY p.nama_lengkap 
ORDER BY total_halaman DESC;

-- Cek kasus
SELECT p.nama_lengkap, k.deskripsi_kasus, k.pengurangan_poin 
FROM kasus k 
JOIN profiles p ON k.santri_id = p.id 
ORDER BY k.tanggal DESC;
```

## Cara Menjalankan Dummy Data:

1. Buka **SQL Editor** di Supabase
2. Copy dan paste SQL dummy data di atas
3. Run query secara bertahap:
   - Pertama: Insert data santri
   - Kedua: Insert data absensi
   - Ketiga: Insert data hafalan
   - Keempat: Insert data kesantrian
   - Kelima: Insert data kasus
   - Terakhir: Update poin santri

## Data yang Akan Tersedia:

- **15 Santri** dengan berbagai tingkat poin kesantrian
- **Data absensi** 30 hari terakhir
- **Data hafalan** dengan progres berbeda-beda
- **Penilaian kesantrian** dengan berbagai kategori
- **Kasus pelanggaran** dengan penanganan

Dengan data dummy ini, aplikasi Dashboard Santri Anda akan memiliki data yang realistis untuk diuji dan dikembangkan lebih lanjut!
