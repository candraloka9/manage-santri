-- 1. SQL Schema Lengkap YANG SESUAI dengan Kode Frontend

-- Table untuk data santri
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_lengkap VARCHAR(255) NOT NULL,
    kelas VARCHAR(100) NOT NULL,
    asal VARCHAR(255) NOT NULL,
    umur INTEGER NOT NULL,
    tanggal_masuk DATE NOT NULL,
    nama_wali VARCHAR(255) NOT NULL,
    telepon_wali VARCHAR(20),
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

-- Table untuk pencatatan pelanggaran - SESUAI KODE FRONTEND
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
CREATE INDEX idx_pelanggaran_santri_id ON pelanggaran(santri_id);
CREATE INDEX idx_pelanggaran_tanggal ON pelanggaran(tanggal);
CREATE INDEX idx_jenis_pelanggaran_kategori ON jenis_pelanggaran(kategori_id);

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

-- 2. SQL Dummy Data Lengkap dengan Data Real Pondok Pesantren Al-Maa

-- Insert data santri REAL dari Pondok Pesantren Al-Maa
INSERT INTO profiles (nama_lengkap, kelas, asal, umur, tanggal_masuk, nama_wali, telepon_wali, poin_kesantrian) VALUES
('AHMAD ZAIDAN PUTRA RAHMANI', '8A', 'TANGERANG', 15, '2023-01-15', 'OMAN ABDURRAHMAN', '08825905703', 95),
('ALISA ADRIANA PUTRI', '7B', 'BOGOR', 14, '2023-02-20', 'SRI YANTO', '087784643892', 88),
('AQILA GHAIDA NAZYWAH', '9A', 'CILEGON BANTEN', 16, '2022-08-10', 'MUHAIMIN', '081939462393', 92),
('AQUILA KHOIRUNNISA', '8B', 'TANGERANG', 15, '2023-03-05', 'SUNTORO', '089675476492', 78),
('ARGYAN MUHAMMAD GHIFARY', '7A', 'PARUNG BOGOR', 14, '2023-01-25', 'NURLAELA', '081323595306', 85),
('ASHIRA ISMAYLOV', '9B', 'BEKASI', 16, '2022-09-12', 'HENDRA SYAMBASRI', '085876677647', 96),
('ASTRID REVALINA', '8A', 'JAKARTA', 15, '2023-02-28', 'RESTI ELIZA', '-', 82),
('AUFA AULIA', '7B', 'JAKARTA PUSAT', 14, '2023-03-15', 'JAMHURI', '081294828574', 90),
('AYESHA NAILATURROHMAH', '9A', 'JAKARTA', 16, '2022-10-05', 'AMI AMANATILLAH', '081398545378', 74),
('AYU WULAN KINASIH', '8B', 'BOGOR', 15, '2023-04-10', 'ABDULLAH MANSUR', '083897610009', 89),
('CAMEELA MAULYDA', '7A', 'CILEUNGSI BOGOR', 14, '2023-02-14', 'M AMIRUDIN', '083131217026', 91),
('AZUMA ZAYAN FAQIHA', '9B', 'TIDAK DIKETAHUI', 16, '2022-11-20', 'TIDAK DIKETAHUI', '-', 87),
('DIAN TRI WAHYUNI', '8A', 'PARUNG BOGOR', 15, '2023-01-30', 'DEDE ABDUL MANAN', '085776190091', 83),
('DEVA AULIA', '7B', 'CIAMIS', 14, '2023-03-25', 'YENI', '085217724889', 94),
('FAWWAZ IBATULLAH', '9A', 'DEPOK', 16, '2022-12-15', 'MOCH NURDIN', '08980638499', 79),
('FELYCIA NADYA KURNIATI', '8A', 'JAKARTA', 15, '2023-05-01', 'SURYONO', '081280345949', 86),
('KHANSA AYLATUS SALMA', '7B', 'BREBES', 14, '2023-04-20', 'MUH GHOZALI', '-', 93),
('KHANSA RAMADHANI', '9A', 'TIDAK DIKETAHUI', 16, '2022-10-30', 'TIDAK DIKETAHUI', '-', 77),
('KIRANA QANIA RAMADHANI', '8B', 'BOGOR', 15, '2023-03-10', 'TIDAK DIKETAHUI', '081292100189', 84),
('LUKMAN HAKIM', '7A', 'BOGOR', 14, '2023-02-05', 'KHOIRI', '081946789225', 98),
('M DAMARUDIN DAHLAN', '9B', 'TIDAK DIKETAHUI', 16, '2022-11-25', 'TIDAK DIKETAHUI', '-', 88),
('M DESTA PRATAMA', '8A', 'JAKARTA BARAT', 15, '2023-01-18', 'HERLIPAH', '-', 82),
('M RAMADANI', '7B', 'BOGOR', 14, '2023-03-08', 'WARSIH', '085880016980', 90),
('M YUSUF RAMADHAN', '9A', 'JAKARTA BARAT', 16, '2022-10-12', 'PUTRI SOLEHA', '089513750782', 85),
('M MALIK AQIL', '8B', 'PARUNG BOGOR', 15, '2023-04-05', 'TIDAK DIKETAHUI', '-', 79),
('MEISYA DWI FERNITA', '7A', 'BOGOR', 14, '2023-02-28', 'TIDAK DIKETAHUI', '-', 87),
('MEYDA HUMAIRA', '9B', 'BOGOR', 16, '2022-09-18', 'OJI FAHRUROJI', '087720008100', 92),
('M FARIS FARADAY', '8A', 'BOGOR', 15, '2023-01-22', 'ABDUL GOFAR', '087898505211', 81),
('MUHAMMAD NAWAWI', '7B', 'JAKARTA', 14, '2023-03-30', 'BAHRUM MISUNANDAR', '081908891189', 89),
('MUHAMMAD ALHAFIZ', '9A', 'JAKARTA', 16, '2022-08-25', 'INDRIYANI', '085717221234', 94);

-- Insert data absensi (30 hari terakhir)
INSERT INTO absensi (santri_id, tanggal, status, keterangan) 
SELECT 
    p.id,
    CURRENT_DATE - (random() * 30)::integer,
    CASE (random() * 3)::integer 
        WHEN 0 THEN 'hadir' 
        WHEN 1 THEN 'sakit' 
        WHEN 2 THEN 'ijin' 
        ELSE 'pulang' 
    END,
    CASE 
        WHEN random() > 0.7 THEN 'Keterangan: ' || CASE (random() * 4)::integer
            WHEN 0 THEN 'Demam'
            WHEN 1 THEN 'Pulang kampung'
            WHEN 2 THEN 'Keperluan keluarga'
            WHEN 3 THEN 'Acara penting'
            ELSE 'Ijin pribadi'
        END
        ELSE NULL 
    END
FROM profiles p
CROSS JOIN generate_series(1, 3) -- 3 data absensi per santri
WHERE random() > 0.2; -- 80% santri memiliki data absensi

-- Pastikan ada data absensi hari ini
INSERT INTO absensi (santri_id, tanggal, status, keterangan) 
SELECT 
    id,
    CURRENT_DATE,
    CASE (random() * 4)::integer 
        WHEN 0 THEN 'hadir' 
        WHEN 1 THEN 'sakit' 
        WHEN 2 THEN 'ijin' 
        ELSE 'pulang' 
    END,
    CASE WHEN random() > 0.8 THEN 'Keterangan khusus' ELSE NULL END
FROM profiles 
WHERE random() > 0.3
LIMIT 15;

-- Insert data hafalan
INSERT INTO hafalan (santri_id, tanggal, halaman_awal, halaman_akhir, catatan) 
SELECT 
    p.id,
    CURRENT_DATE - (random() * 60)::integer,
    (random() * 50)::integer + 1,
    (random() * 50)::integer + 51,
    CASE (random() * 5)::integer
        WHEN 0 THEN 'Hafalan lancar dan tajwid baik'
        WHEN 1 THEN 'Perlu memperbaiki makhroj huruf'
        WHEN 2 THEN 'Hafalan sangat baik'
        WHEN 3 THEN 'Sedikit terbata-bata'
        WHEN 4 THEN 'Hafalan konsisten'
        ELSE 'Tajwid perlu ditingkatkan'
    END
FROM profiles p
CROSS JOIN generate_series(1, 5) -- 5 data hafalan per santri
WHERE random() > 0.1; -- 90% santri memiliki data hafalan

-- Insert data kesantrian
INSERT INTO kesantrian (santri_id, tanggal, sikap, disiplin, kebersihan, pelanggaran, catatan, pengurangan_poin) 
SELECT 
    p.id,
    CURRENT_DATE - (random() * 90)::integer,
    CASE (random() * 3)::integer WHEN 0 THEN 'baik' WHEN 1 THEN 'cukup' ELSE 'kurang' END,
    CASE (random() * 3)::integer WHEN 0 THEN 'baik' WHEN 1 THEN 'cukup' ELSE 'kurang' END,
    CASE (random() * 3)::integer WHEN 0 THEN 'baik' WHEN 1 THEN 'cukup' ELSE 'kurang' END,
    CASE WHEN random() > 0.7 THEN 
        CASE (random() * 5)::integer
            WHEN 0 THEN 'Terlambat sholat'
            WHEN 1 THEN 'Kamar tidak rapi'
            WHEN 2 THEN 'Tidak mengerjakan piket'
            WHEN 3 THEN 'Berkelahi dengan teman'
            WHEN 4 THEN 'Tidak menjaga kebersihan'
            ELSE 'Pelanggaran ringan'
        END
    ELSE NULL END,
    CASE (random() * 4)::integer
        WHEN 0 THEN 'Santri teladan, sikap sangat baik'
        WHEN 1 THEN 'Perlu meningkatkan kedisiplinan'
        WHEN 2 THEN 'Konsisten dalam semua aspek'
        WHEN 3 THEN 'Perlu perhatian khusus dalam kebersihan'
        ELSE 'Performance memuaskan'
    END,
    CASE 
        WHEN random() > 0.8 THEN (random() * 15)::integer + 5
        WHEN random() > 0.5 THEN (random() * 10)::integer
        ELSE 0
    END
FROM profiles p
CROSS JOIN generate_series(1, 3) -- 3 data kesantrian per santri
WHERE random() > 0.15; -- 85% santri memiliki data kesantrian

-- Insert kategori pelanggaran
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

-- Insert jenis pelanggaran berdasarkan dokumen
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

-- Insert data pelanggaran contoh
INSERT INTO pelanggaran (santri_id, jenis_pelanggaran_id, tanggal, deskripsi, sanksi_fisik_diberikan, point_sebelum, point_sesudah) 
SELECT 
    p.id,
    jp.id,
    CURRENT_DATE - (random() * 30)::integer,
    'Pelanggaran: ' || jp.deskripsi,
    jp.sanksi_fisik,
    p.poin_kesantrian + jp.pengurangan_point,
    p.poin_kesantrian
FROM profiles p
CROSS JOIN jenis_pelanggaran jp
WHERE random() > 0.95 -- 5% santri memiliki pelanggaran
LIMIT 20;

-- Insert sanksi khusus
INSERT INTO sanksi_khusus (nama_sanksi, deskripsi, min_point, max_point) VALUES
('Hukuman fisik, Teguran, Pembinaan', 'Sanksi untuk point 86-100', 86, 100),
('Hukuman fisik, Pemanggilan orang tua, surat perningatan pertama', 'Sanksi untuk point 76-85', 76, 85),
('Hukuman fisik, Surat Peringatan Pertama', 'Sanksi untuk point 56-75', 56, 75),
('Hukuman fisik, Surat Peringatan kedua dan skorsing', 'Sanksi untuk point 26-55', 26, 55),
('Surat Peringatan ketiga dan dikembalikan kepada orang tua', 'Sanksi untuk point 1-25', 1, 25);

-- 3. Update poin santri berdasarkan data yang sudah diinput
UPDATE profiles 
SET poin_kesantrian = GREATEST(0, 100 - COALESCE((
    SELECT SUM(k.pengurangan_poin) 
    FROM kesantrian k 
    WHERE k.santri_id = profiles.id
), 0) - COALESCE((
    SELECT SUM(jp.pengurangan_point) 
    FROM pelanggaran p
    JOIN jenis_pelanggaran jp ON p.jenis_pelanggaran_id = jp.id
    WHERE p.santri_id = profiles.id
), 0));

-- 4. SQL untuk Testing Data

-- Cek data santri dan poin
SELECT nama_lengkap, kelas, asal, poin_kesantrian 
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
SELECT p.nama_lengkap, jp.kode, jp.deskripsi, jp.pengurangan_point, pg.tanggal
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
