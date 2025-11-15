--Saya akan buatkan dummy database lengkap untuk sistem Dashboard Santri. Berikut SQL lengkapnya:

-- 1. SQL Schema Lengkap


-- Table untuk data santri
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_lengkap VARCHAR(255) NOT NULL,
    kelas VARCHAR(100) NOT NULL,
    asal VARCHAR(255) NOT NULL,
    umur INTEGER NOT NULL,
    tanggal_masuk DATE NOT NULL,
    nama_wali VARCHAR(255) NOT NULL,
    poin_kesantrian INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk absensi
CREATE TABLE absensi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('hadir', 'sakit', 'ijin', 'pulang')),
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk hafalan
CREATE TABLE hafalan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    halaman_awal INTEGER NOT NULL,
    halaman_akhir INTEGER NOT NULL,
    catatan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk kesantrian
CREATE TABLE kesantrian (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    sikap VARCHAR(50) NOT NULL CHECK (sikap IN ('baik', 'cukup', 'kurang')),
    disiplin VARCHAR(50) NOT NULL CHECK (disiplin IN ('baik', 'cukup', 'kurang')),
    kebersihan VARCHAR(50) NOT NULL CHECK (kebersihan IN ('baik', 'cukup', 'kurang')),
    pelanggaran VARCHAR(255),
    catatan TEXT,
    pengurangan_poin INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk kasus
CREATE TABLE kasus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    deskripsi_kasus TEXT NOT NULL,
    penanganan TEXT NOT NULL,
    pengurangan_poin INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk kategorisasi pelanggaran
CREATE TABLE kategori_pelanggaran (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bab VARCHAR(100) NOT NULL,
    nama_bab VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk jenis pelanggaran
CREATE TABLE jenis_pelanggaran (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    kategori_id UUID REFERENCES kategori_pelanggaran(id),
    kode VARCHAR(10) NOT NULL,
    deskripsi TEXT NOT NULL,
    pengurangan_point INTEGER NOT NULL,
    sanksi_fisik TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk pencatatan pelanggaran
CREATE TABLE pelanggaran (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    jenis_pelanggaran_id UUID REFERENCES jenis_pelanggaran(id),
    tanggal DATE NOT NULL,
    deskripsi TEXT,
    sanksi_fisik_diberikan TEXT,
    point_sebelum INTEGER,
    point_sesudah INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table untuk sanksi khusus
CREATE TABLE sanksi_khusus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_sanksi VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    min_point INTEGER,
    max_point INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index untuk performa
CREATE INDEX idx_absensi_santri_id ON absensi(santri_id);
CREATE INDEX idx_absensi_tanggal ON absensi(tanggal);
CREATE INDEX idx_hafalan_santri_id ON hafalan(santri_id);
CREATE INDEX idx_hafalan_tanggal ON hafalan(tanggal);
CREATE INDEX idx_kesantrian_santri_id ON kesantrian(santri_id);
CREATE INDEX idx_kasus_santri_id ON kasus(santri_id);
CREATE INDEX idx_pelanggaran_santri_id ON pelanggaran(santri_id);
CREATE INDEX idx_pelanggaran_tanggal ON pelanggaran(tanggal);

-- Fungsi untuk update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger untuk update updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON profiles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 2. SQL Dummy Data Lengkap
-- 1. Insert data santri (20 santri)
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
('Rudi Hermawan', '9A', 'Banjarmasin', 16, '2022-12-15', 'Hermawan Jaya', 79),
('Salsa Bila', '8A', 'Jakarta', 15, '2023-05-01', 'Bila Santoso', 86),
('Rizky Fadilah', '7B', 'Bogor', 14, '2023-04-20', 'Fadilah Rahman', 93),
('Anisa Putri', '9A', 'Depok', 16, '2022-10-30', 'Putra Wijaya', 77),
('Fahri Ramadhan', '8B', 'Tangerang', 15, '2023-03-10', 'Ramadhan Hidayat', 84),
('Dian Pertiwi', '7A', 'Bekasi', 14, '2023-02-05', 'Pertiwi Sari', 98);

-- 2. Insert data absensi (30 hari terakhir)
INSERT INTO absensi (santri_id, tanggal, status, keterangan) VALUES
-- Hari ini
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE, 'sakit', 'Demam tinggi'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE, 'ijin', 'Pulang kampung'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Aisyah Lestari'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Ibrahim Khalid'), CURRENT_DATE, 'sakit', 'Flu'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Nurul Hikmah'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), CURRENT_DATE, 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Dewi Sartika'), CURRENT_DATE, 'ijin', 'Keperluan keluarga'),

-- Kemarin
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE - INTERVAL '1 day', 'sakit', 'Masuk angin'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), CURRENT_DATE - INTERVAL '1 day', 'hadir', NULL),

-- 3 hari lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE - INTERVAL '3 days', 'sakit', 'Demam'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE - INTERVAL '3 days', 'hadir', NULL),

-- 1 minggu lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '7 days', 'ijin', 'Acara keluarga'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fajar Nugroho'), CURRENT_DATE - INTERVAL '7 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Maya Sari'), CURRENT_DATE - INTERVAL '7 days', 'sakit', 'Batuk pilek'),

-- 2 minggu lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Nurul Hikmah'), CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Dewi Sartika'), CURRENT_DATE - INTERVAL '14 days', 'pulang', 'Libur semester'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fajar Nugroho'), CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL),
((SELECT id FROM profiles WHERE nama_lengkap = 'Maya Sari'), CURRENT_DATE - INTERVAL '14 days', 'hadir', NULL);

-- 3. Insert data hafalan
INSERT INTO hafalan (santri_id, tanggal, halaman_awal, halaman_akhir, catatan) VALUES
-- Hafalan terbaru (hari ini dan kemarin)
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE, 1, 5, 'Hafalan lancar dan tajwid baik'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '1 day', 6, 10, 'Perlu memperbaiki makhroj huruf'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE, 11, 15, 'Hafalan sangat baik'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE - INTERVAL '2 days', 16, 20, 'Sedikit terbata-bata'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), CURRENT_DATE - INTERVAL '1 day', 21, 25, 'Hafalan konsisten'),

-- Hafalan 1 minggu terakhir
((SELECT id FROM profiles WHERE nama_lengkap = 'Aisyah Lestari'), CURRENT_DATE - INTERVAL '3 days', 26, 30, 'Tajwid perlu ditingkatkan'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Ibrahim Khalid'), CURRENT_DATE - INTERVAL '4 days', 31, 35, 'Hafalan cepat dan tepat'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Nurul Hikmah'), CURRENT_DATE - INTERVAL '5 days', 36, 40, 'Perlu pengulangan'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), CURRENT_DATE - INTERVAL '6 days', 41, 45, 'Hafalan memuaskan'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Dewi Sartika'), CURRENT_DATE - INTERVAL '7 days', 46, 50, 'Sedikit lupa di akhir'),

-- Hafalan 2 minggu terakhir
((SELECT id FROM profiles WHERE nama_lengkap = 'Fajar Nugroho'), CURRENT_DATE - INTERVAL '8 days', 51, 55, 'Hafalan semakin baik'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Maya Sari'), CURRENT_DATE - INTERVAL '9 days', 56, 60, 'Konsistensi bagus'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Hasan Basri'), CURRENT_DATE - INTERVAL '10 days', 61, 65, 'Perlu evaluasi makhroj'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Lina Marlina'), CURRENT_DATE - INTERVAL '11 days', 66, 70, 'Hafalan excellent'),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rudi Hermawan'), CURRENT_DATE - INTERVAL '12 days', 71, 75, 'Sedikit terbata-bata');

-- 4. Insert data kesantrian
INSERT INTO kesantrian (santri_id, tanggal, sikap, disiplin, kebersihan, pelanggaran, catatan, pengurangan_poin) VALUES
-- Penilaian terbaru
((SELECT id FROM profiles WHERE nama_lengkap = 'Ahmad Fauzi'), CURRENT_DATE, 'baik', 'baik', 'baik', NULL, 'Santri teladan, sikap sangat baik', 0),
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '1 day', 'cukup', 'baik', 'cukup', 'Terlambat sholat', 'Perlu meningkatkan kedisiplinan waktu', 4),
((SELECT id FROM profiles WHERE nama_lengkap = 'Muhammad Ali'), CURRENT_DATE, 'baik', 'baik', 'baik', NULL, 'Konsisten dalam semua aspek', 0),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE - INTERVAL '2 days', 'kurang', 'cukup', 'kurang', 'Kamar tidak rapi', 'Perlu perhatian khusus dalam kebersihan', 10),
((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), CURRENT_DATE - INTERVAL '1 day', 'baik', 'cukup', 'baik', NULL, 'Sikap baik tapi perlu disiplin', 2),

-- Penilaian 1 minggu lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Aisyah Lestari'), CURRENT_DATE - INTERVAL '5 days', 'baik', 'baik', 'baik', NULL, 'Performance sangat memuaskan', 0),
((SELECT id FROM profiles WHERE nama_lengkap = 'Ibrahim Khalid'), CURRENT_DATE - INTERVAL '6 days', 'cukup', 'cukup', 'baik', 'Tidak mengerjakan piket', 'Kurang bertanggung jawab', 4),
((SELECT id FROM profiles WHERE nama_lengkap = 'Nurul Hikmah'), CURRENT_DATE - INTERVAL '7 days', 'baik', 'baik', 'cukup', NULL, 'Hanya perlu perbaikan kebersihan', 2),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), CURRENT_DATE - INTERVAL '4 days', 'kurang', 'kurang', 'kurang', 'Berkelahi dengan teman', 'Perlu pembinaan intensif', 15),
((SELECT id FROM profiles WHERE nama_lengkap = 'Dewi Sartika'), CURRENT_DATE - INTERVAL '3 days', 'baik', 'baik', 'baik', NULL, 'Santri berprestasi', 0);

-- 5. Insert data kasus
INSERT INTO kasus (santri_id, tanggal, deskripsi_kasus, penanganan, pengurangan_poin) VALUES
-- Kasus terbaru
((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), CURRENT_DATE - INTERVAL '2 days', 'Melakukan bullying terhadap santri junior', 'Pembinaan intensif dan permintaan maaf formal', 15),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), CURRENT_DATE - INTERVAL '4 days', 'Berkelahi dengan teman sekamar', 'Mediasi dan sanksi tidak boleh keluar asrama 1 minggu', 20),
((SELECT id FROM profiles WHERE nama_lengkap = 'Ibrahim Khalid'), CURRENT_DATE - INTERVAL '6 days', 'Kabur dari pesantren tanpa ijin', 'Pemanggilan orang tua dan evaluasi motivasi', 25),

-- Kasus 2 minggu lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Maya Sari'), CURRENT_DATE - INTERVAL '11 days', 'Membawa smartphone ke pesantren', 'Penyitaan dan pembinaan tentang aturan', 10),
((SELECT id FROM profiles WHERE nama_lengkap = 'Rudi Hermawan'), CURRENT_DATE - INTERVAL '14 days', 'Tidak sholat berjamaah berulang kali', 'Pembinaan spiritual dan monitoring ketat', 15),

-- Kasus 1 bulan lalu
((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), CURRENT_DATE - INTERVAL '20 days', 'Mencontek saat ujian', 'Pembinaan kejujuran dan mengulang ujian', 10),
((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), CURRENT_DATE - INTERVAL '25 days', 'Merusak fasilitas pesantren', 'Ganti rugi dan kerja bakti', 15),
((SELECT id FROM profiles WHERE nama_lengkap = 'Fajar Nugroho'), CURRENT_DATE - INTERVAL '30 days', 'Tidur saat kegiatan belajar', 'Konseling dan evaluasi jam tidur', 5);

-- 6. Insert kategori pelanggaran
INSERT INTO kategori_pelanggaran (bab, nama_bab) VALUES
('I', 'BAB AQIDAH'),
('II', 'BAB IBADAH'),
('III', 'BAB AKHLAQ'),
('IV', 'BAB HALAQAH QURAN DAN MAPEL'),
('V', 'BAB KEBERSIHAN DAN KEINDAHAN'),
('VI', 'BAB OLAH RAGA DAN KESEHATAN'),
('VII', 'BAB KEAMANAN'),
('VIII', 'BAB PINJAM MEMINJAM'),
('IX', 'BAB MENELEPON'),
('X', 'BAB PENCURIAN'),
('XI', 'BAB KEORGANISASIAN');

-- 7. Insert jenis pelanggaran berdasarkan dokumen
INSERT INTO jenis_pelanggaran (kategori_id, kode, deskripsi, pengurangan_point, sanksi_fisik) VALUES
-- BAB AQIDAH
((SELECT id FROM kategori_pelanggaran WHERE bab = 'I'), 'I.1', 'Menolak aqidah yang benar', 100, 'Dipulangkan'),

-- BAB IBADAH
((SELECT id FROM kategori_pelanggaran WHERE bab = 'II'), 'II.1', 'Bermain-main di dalam masjid', 10, 'Push up 20x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'II'), 'II.2', 'Meninggalkan jamaah fardhu di masjid', 10, 'Sholat sunnah 10 rakaat'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'II'), 'II.3', 'Meninggalkan qiyam ramadhan', 10, 'Qiyamul lail tambahan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'II'), 'II.4', 'Meninggalkan shaum ramadhan tanpa alasan syar-i', 60, 'Puasa qadha + kaffarah'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'II'), 'II.5', 'Meninggalkan shalat wajib dengan sengaja', 60, 'Pembinaan intensif'),

-- BAB AKHLAQ - Berpakaian
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.1', 'Tidak menutup aurat', 30, 'Push up 30x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.2', 'Tidak menggunakan seragam yang sesuai', 10, 'Teguran dan peringatan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.3', 'Menggunakan pakaian ketat', 10, 'Ganti pakaian'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.4', 'Menggunakan pakaian berbahan denim', 10, 'Ganti pakaian'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.5', 'Gaya rambut qoza', 10, 'Cukur rambut'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.6', 'Berhias yang berlebihan', 10, 'Membersihkan kamar mandi'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.A.7', 'Memakai aksesoris: gelang, cincin, kalung dll', 10, 'Penyitaan barang'),

-- BAB AKHLAQ - Makan Minum
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.B.1', 'Membeli makanan dan minuman di luar Pesantren', 10, 'Push up 20x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.B.2', 'Tidak menjaga adab makan dan minum', 5, 'Membersihkan dapur'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.B.3', 'Memasak di dapur', 25, 'Membersihkan seluruh dapur'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.B.4', 'Membawa dan Merokok', 50, 'Pembinaan khusus + kerja bakti'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.B.5', 'Membawa dan meminum minuman keras', 60, 'Pemanggilan orang tua'),

-- BAB AKHLAQ - Tidur
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.C.1', 'Masuk/Tidur di kamar orang lain', 10, 'Push up 15x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.C.2', 'Tidur di ranjang orang lain', 10, 'Membersihkan asrama'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.C.3', 'Keluar asrama pada jam tidur', 10, 'Tidak boleh keluar asrama 3 hari'),

-- BAB AKHLAQ - Berbicara
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.1', 'Berteriak-teriak', 5, 'Membersihkan masjid'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.2', 'Berdusta', 50, 'Pembinaan kejujuran'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.3', 'Merendahkan, melecehkan', 10, 'Meminta maaf + push up 20x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.4', 'Berkata kotor, kasar dan Bahasa daerah', 10, 'Menghafal adab berbicara'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.5', 'Melagukan senandung yang haram', 10, 'Menghafal ayat Quran'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.D.6', 'Berkhalwat', 10, 'Pembatasan pergaulan'),

-- BAB AKHLAQ - Bergaul
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.1', 'Tidak menjaga akhlaqul karimah', 10, 'Pembinaan akhlak'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.2', 'Menantang guru atau orang tua', 60, 'Pemanggilan orang tua'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.3', 'Menyukai sesama jenis', 50, 'Konseling intensif'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.4', 'Berkelahi', 50, 'Push up 50x + mediasi'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.5', 'Menyakiti dengan sengaja', 30, 'Push up 30x + meminta maaf'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.6', 'Berhubungan dengan lawan jenis bukan mahrom', 60, 'Pembatasan pergaulan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.E.7', 'Berhubungan sesama jenis', 100, 'Dipulangkan'),

-- BAB AKHLAQ - Kunjungan Orang Tua
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.F.1', 'Memasukkan/membawa orang tua ke kamar', 15, 'Membersihkan kamar mandi'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.F.2', 'Meminta Orang tua berkunjung bukan pada jadwal', 10, 'Teguran'),

-- BAB AKHLAQ - Keluar komplek/ berpergian
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.G.1', 'Terlambat datang ke Pondok', 20, 'Push up 30x'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'III'), 'III.G.2', 'Keluar Pondok tanpa izin', 30, 'Tidak boleh keluar 1 bulan'),

-- BAB HALAQAH QURAN DAN MAPEL
((SELECT id FROM kategori_pelanggaran WHERE bab = 'IV'), 'IV.1', 'Mengganggu ketertiban, kenyamanan', 10, 'Membersihkan kelas'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'IV'), 'IV.2', 'Absen tanpa alasan yang dibenarkan', 20, 'Menghafal tambahan'),

-- BAB KEBERSIHAN DAN KEINDAHAN
((SELECT id FROM kategori_pelanggaran WHERE bab = 'V'), 'V.1', 'Meninggalkan barang pribadi ditempat umum', 5, 'Membersihkan tempat umum'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'V'), 'V.2', 'Meninggalkan tugas piket kebersihan', 10, 'Piket tambahan 3 hari'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'V'), 'V.3', 'Membuang sampah di sembarang tempat', 20, 'Membersihkan seluruh area'),

-- BAB OLAH RAGA DAN KESEHATAN
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VI'), 'VI.1', 'Tidak Mengikuti jadwal olahraga', 10, 'Lari keliling lapangan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VI'), 'VI.2', 'Mengambil peralatan olahraga tanpa izin', 10, 'Tidak boleh olahraga 1 minggu'),

-- BAB KEAMANAN
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VII'), 'VII.1', 'Tidak mau ditunjuk sebagai petugas jaga', 25, 'Jaga malam tambahan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VII'), 'VII.2', 'Membawa MP3/4, Game Watch, HP, Walkman dan barang elektronik lainnya', 50, 'Penyitaan barang'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VII'), 'VII.3', 'Mempengaruhi orang lain untuk melanggar tata tertib', 10, 'Pembinaan khusus'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VII'), 'VII.4', 'Membawa peralatan yang dilarang lainnya (sajam, senjata dll)', 50, 'Penyitaan + pemanggilan orang tua'),

-- BAB PINJAM MEMINJAM
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VIII'), 'VIII.1', 'Memakai barang orang lain tanpa izin', 20, 'Meminta maaf + mengembalikan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'VIII'), 'VIII.2', 'Tidak amanah terhadap barang pinjaman', 10, 'Ganti rugi'),

-- BAB MENELEPON
((SELECT id FROM kategori_pelanggaran WHERE bab = 'IX'), 'IX.1', 'Menggunakan hp untuk keperluan lain', 10, 'Penyitaan HP'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'IX'), 'IX.2', 'Menelepon bukan pada waktunya', 20, 'Tidak boleh telepon 2 minggu'),

-- BAB PENCURIAN
((SELECT id FROM kategori_pelanggaran WHERE bab = 'X'), 'X.1', 'Tidak melaporkan saat kehilangan', 10, 'Teguran'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'X'), 'X.2', 'Kerjasama dalam pencurian', 30, 'Pemanggilan orang tua'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'X'), 'X.3', 'Mencuri', 50, 'Pemulangan sementara'),

-- BAB KEORGANISASIAN
((SELECT id FROM kategori_pelanggaran WHERE bab = 'XI'), 'XI.1', 'Tidak bersedia bila ditunjuk sebagai pengurus', 25, 'Tugas tambahan'),
((SELECT id FROM kategori_pelanggaran WHERE bab = 'XI'), 'XI.2', 'Tidak mentaati aturan organisasi', 10, 'Pembinaan organisasi');

-- 8. Insert data pelanggaran
INSERT INTO pelanggaran (santri_id, jenis_pelanggaran_id, tanggal, deskripsi, sanksi_fisik_diberikan, point_sebelum, point_sesudah) VALUES
((SELECT id FROM profiles WHERE nama_lengkap = 'Rizki Pratama'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'III.E.4'), 
 CURRENT_DATE - INTERVAL '4 days', 
 'Berkelahi dengan teman sekamar karena berebut remote TV', 
 'Push up 50x dan membersihkan kamar mandi selama 3 hari', 89, 39),

((SELECT id FROM profiles WHERE nama_lengkap = 'Fatimah Zahra'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'III.D.3'), 
 CURRENT_DATE - INTERVAL '2 days', 
 'Melecehkan penampilan teman sekelas', 
 'Meminta maaf secara formal dan push up 20x', 93, 83),

((SELECT id FROM profiles WHERE nama_lengkap = 'Ibrahim Khalid'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'VII.2'), 
 CURRENT_DATE - INTERVAL '6 days', 
 'Membawa smartphone dan menyembunyikannya di bawah kasur', 
 'Penyitaan HP dan tidak boleh keluar asrama 1 minggu', 87, 37),

((SELECT id FROM profiles WHERE nama_lengkap = 'Maya Sari'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'V.2'), 
 CURRENT_DATE - INTERVAL '11 days', 
 'Tidak mengerjakan piket kebersihan kamar mandi', 
 'Piket tambahan 3 hari berturut-turut', 92, 82),

((SELECT id FROM profiles WHERE nama_lengkap = 'Siti Rahma'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'IV.2'), 
 CURRENT_DATE - INTERVAL '20 days', 
 'Tidak masuk halaqah tanpa alasan yang jelas', 
 'Menghafal 2 halaman tambahan', 98, 78),

((SELECT id FROM profiles WHERE nama_lengkap = 'Abdullah Rahman'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'III.B.1'), 
 CURRENT_DATE - INTERVAL '25 days', 
 'Membeli jajanan di luar pesantren secara diam-diam', 
 'Push up 20x dan membersihkan dapur', 100, 90),

((SELECT id FROM profiles WHERE nama_lengkap = 'Fajar Nugroho'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'III.D.4'), 
 CURRENT_DATE - INTERVAL '30 days', 
 'Berkata kasar kepada pengurus asrama', 
 'Menghafal adab berbicara dan meminta maaf', 96, 86),

((SELECT id FROM profiles WHERE nama_lengkap = 'Rudi Hermawan'), 
 (SELECT id FROM jenis_pelanggaran WHERE kode = 'II.2'), 
 CURRENT_DATE - INTERVAL '14 days', 
 'Meninggalkan sholat jamaah dengan sengaja', 
 'Sholat sunnah 10 rakaat', 94, 84);

-- 9. Insert sanksi khusus
INSERT INTO sanksi_khusus (nama_sanksi, deskripsi, min_point, max_point) VALUES
('Hukuman fisik, Teguran, Pembinaan', 'Sanksi untuk point 86-100', 86, 100),
('Hukuman fisik, Pemanggilan orang tua, surat pernyataan', 'Sanksi untuk point 76-85', 76, 85),
('Hukuman fisik, Surat Peringatan Pertama', 'Sanksi untuk point 56-75', 56, 75),
('Hukuman fisik, Surat Peringatan kedua dan skorsing', 'Sanksi untuk point 26-55', 26, 55),
('Surat Peringatan ketiga dan dikembalikan kepada orang tua', 'Sanksi untuk point 1-25', 1, 25);


-- 3. SQL untuk Update Poin Santri


-- Update poin santri berdasarkan pengurangan dari kesantrian, kasus, dan pelanggaran
UPDATE profiles 
SET poin_kesantrian = 100 - COALESCE((
    SELECT SUM(pengurangan_poin) 
    FROM kesantrian 
    WHERE kesantrian.santri_id = profiles.id
), 0) - COALESCE((
    SELECT SUM(pengurangan_poin) 
    FROM kasus 
    WHERE kasus.santri_id = profiles.id
), 0) - COALESCE((
    SELECT SUM(jp.pengurangan_point) 
    FROM pelanggaran p
    JOIN jenis_pelanggaran jp ON p.jenis_pelanggaran_id = jp.id
    WHERE p.santri_id = profiles.id
), 0)
WHERE poin_kesantrian > 0;


-- 4. SQL untuk Testing Data

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

-- Cek pelanggaran
SELECT p.nama_lengkap, jp.kode, jp.deskripsi, jp.pengurangan_point
FROM pelanggaran pg
JOIN profiles p ON pg.santri_id = p.id
JOIN jenis_pelanggaran jp ON pg.jenis_pelanggaran_id = jp.id
ORDER BY pg.tanggal DESC;

-- Cek statistik dashboard
SELECT 
    (SELECT COUNT(*) FROM profiles) as total_santri,
    (SELECT COUNT(*) FROM absensi WHERE tanggal = CURRENT_DATE AND status = 'hadir') as hadir_hari_ini,
    (SELECT COALESCE(SUM(halaman_akhir - halaman_awal + 1), 0) FROM hafalan) as total_halaman,
    (SELECT COUNT(*) FROM pelanggaran) as total_pelanggaran;

