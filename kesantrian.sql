-- =============================================
-- Database Schema untuk Sistem Manajemen Pesantren Al-Hikmah
-- =============================================

-- Tabel untuk users (pengguna sistem)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'admin' CHECK (role IN ('admin', 'pengajar', 'staff')),
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk kelas
CREATE TABLE kelas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama VARCHAR(100) NOT NULL,
    tingkat VARCHAR(50), -- SD, SMP, SMA, dll
    jurusan VARCHAR(50), -- IPA, IPS, dll
    wali_kelas VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk santri
CREATE TABLE santri (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nis VARCHAR(20) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(255) NOT NULL,
    tempat_lahir VARCHAR(100),
    tanggal_lahir DATE,
    kelas_id UUID REFERENCES kelas(id) ON DELETE SET NULL,
    alamat TEXT,
    nama_ortu VARCHAR(255),
    hp_ortu VARCHAR(20),
    status VARCHAR(20) DEFAULT 'aktif' CHECK (status IN ('aktif', 'tidak_aktif')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk guru/pengajar
CREATE TABLE guru (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nip VARCHAR(20) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(255) NOT NULL,
    mata_pelajaran VARCHAR(100),
    no_hp VARCHAR(20),
    email VARCHAR(100),
    alamat TEXT,
    status VARCHAR(20) DEFAULT 'aktif' CHECK (status IN ('aktif', 'tidak_aktif')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk kegiatan
CREATE TABLE kegiatan (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama VARCHAR(255) NOT NULL,
    tanggal DATE NOT NULL,
    waktu TIME,
    lokasi VARCHAR(255),
    penanggung_jawab VARCHAR(255),
    status VARCHAR(30) DEFAULT 'dalam_proses' CHECK (status IN ('dalam_proses', 'selesai', 'dibatalkan')),
    deskripsi TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk fasilitas
CREATE TABLE fasilitas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama VARCHAR(255) NOT NULL,
    kapasitas VARCHAR(50),
    kondisi VARCHAR(50) CHECK (kondisi IN ('baik', 'sedang', 'rusak')),
    penanggung_jawab VARCHAR(255),
    status VARCHAR(30) DEFAULT 'tersedia' CHECK (status IN ('tersedia', 'tidak_tersedia')),
    deskripsi TEXT,
    pemeriksaan_terakhir DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk absensi harian santri
CREATE TABLE absensi (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    santri_id UUID NOT NULL REFERENCES santri(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('hadir', 'sakit', 'pulang', 'mangkir')),
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(santri_id, tanggal)
);

-- Tabel untuk absensi halaqoh guru
CREATE TABLE absensi_guru (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guru_id UUID NOT NULL REFERENCES guru(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    sesi VARCHAR(20) NOT NULL CHECK (sesi IN ('pagi', 'sore', 'malam')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('hadir', 'tidak_hadir', 'izin')),
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guru_id, tanggal, sesi)
);

-- Tabel untuk absensi halaqoh santri
CREATE TABLE absensi_santri (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    santri_id UUID NOT NULL REFERENCES santri(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    sesi VARCHAR(20) NOT NULL CHECK (sesi IN ('pagi', 'sore', 'malam')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('hadir', 'tidak_hadir', 'izin')),
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(santri_id, tanggal, sesi)
);

-- Tabel untuk kasus disiplin santri
CREATE TABLE kasus (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    judul VARCHAR(255) NOT NULL,
    santri_id UUID NOT NULL REFERENCES santri(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    jenis VARCHAR(50), -- akademik, disiplin, sosial, kebersihan, ibadah, lainnya
    prioritas VARCHAR(20) NOT NULL CHECK (prioritas IN ('tinggi', 'sedang', 'rendah')),
    status VARCHAR(30) NOT NULL DEFAULT 'terbuka' CHECK (status IN ('terbuka', 'dalam-proses', 'menunggu-konfirmasi', 'selesai')),
    deskripsi TEXT NOT NULL,
    saksi TEXT,
    tindakan TEXT,
    penanggung_jawab VARCHAR(255) NOT NULL,
    tindak_lanjut TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk lampiran kasus
CREATE TABLE kasus_lampiran (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kasus_id UUID NOT NULL REFERENCES kasus(id) ON DELETE CASCADE,
    nama_file VARCHAR(255) NOT NULL,
    tipe_file VARCHAR(50),
    url_file TEXT,
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk riwayat penanganan kasus
CREATE TABLE kasus_riwayat (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kasus_id UUID NOT NULL REFERENCES kasus(id) ON DELETE CASCADE,
    tanggal TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    penangan VARCHAR(255) NOT NULL,
    tindakan TEXT NOT NULL,
    hasil TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk penilaian karakter/akhlak santri
CREATE TABLE karakter (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    santri_id UUID NOT NULL REFERENCES santri(id) ON DELETE CASCADE,
    periode VARCHAR(50) NOT NULL, -- minggu-1, bulan-1, semester-1, tahunan, dll
    tanggal DATE NOT NULL,
    sikap INTEGER CHECK (sikap >= 0 AND sikap <= 100),
    komunikasi INTEGER CHECK (komunikasi >= 0 AND komunikasi <= 100),
    etos_kerja INTEGER CHECK (etos_kerja >= 0 AND etos_kerja <= 100),
    disiplin INTEGER CHECK (disiplin >= 0 AND disiplin <= 100),
    sikap_keterangan TEXT,
    komunikasi_keterangan TEXT,
    etos_kerja_keterangan TEXT,
    disiplin_keterangan TEXT,
    catatan TEXT,
    penilai VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(santri_id, periode, tanggal)
);

-- Tabel untuk aspek penilaian karakter
CREATE TABLE karakter_aspek (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    bobot INTEGER DEFAULT 1, -- bobot untuk perhitungan nilai akhir
    aktif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk detail penilaian karakter per aspek
CREATE TABLE karakter_detail (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    karakter_id UUID NOT NULL REFERENCES karakter(id) ON DELETE CASCADE,
    aspek_id UUID NOT NULL REFERENCES karakter_aspek(id) ON DELETE CASCADE,
    nilai INTEGER CHECK (nilai >= 0 AND nilai <= 100),
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel untuk pengaturan sistem
CREATE TABLE pengaturan (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    deskripsi TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- Trigger untuk update timestamp
-- =============================================

-- Fungsi untuk update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$ BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
 $$ language 'plpgsql';

-- Trigger untuk tabel yang memiliki field updated_at
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_santri_updated_at 
    BEFORE UPDATE ON santri 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guru_updated_at 
    BEFORE UPDATE ON guru 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_kegiatan_updated_at 
    BEFORE UPDATE ON kegiatan 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_fasilitas_updated_at 
    BEFORE UPDATE ON fasilitas 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_absensi_updated_at 
    BEFORE UPDATE ON absensi 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_absensi_guru_updated_at 
    BEFORE UPDATE ON absensi_guru 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_absensi_santri_updated_at 
    BEFORE UPDATE ON absensi_santri 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_kasus_updated_at 
    BEFORE UPDATE ON kasus 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_karakter_updated_at 
    BEFORE UPDATE ON karakter 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pengaturan_updated_at 
    BEFORE UPDATE ON pengaturan 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- View untuk laporan yang sering dibutuhkan
-- =============================================

-- View untuk laporan kasus per santri
CREATE VIEW laporan_kasus_santri AS
SELECT 
    s.id as santri_id,
    s.nis,
    s.nama_lengkap,
    k.nama as kelas,
    COUNT(kas.id) as total_kasus,
    COUNT(CASE WHEN kas.prioritas = 'tinggi' THEN 1 END) as kasus_prioritas_tinggi,
    COUNT(CASE WHEN kas.prioritas = 'sedang' THEN 1 END) as kasus_prioritas_sedang,
    COUNT(CASE WHEN kas.prioritas = 'rendah' THEN 1 END) as kasus_prioritas_rendah,
    COUNT(CASE WHEN kas.status = 'selesai' THEN 1 END) as kasus_selesai,
    COUNT(CASE WHEN kas.status IN ('terbuka', 'dalam-proses', 'menunggu-konfirmasi') THEN 1 END) as kasus_aktif,
    MAX(kas.tanggal) as kasus_terakhir
FROM santri s
LEFT JOIN kelas k ON s.kelas_id = k.id
LEFT JOIN kasus kas ON s.id = kas.santri_id
GROUP BY s.id, s.nis, s.nama_lengkap, k.nama;

-- View untuk laporan perkembangan karakter santri
CREATE VIEW laporan_perkembangan_karakter AS
SELECT 
    s.id as santri_id,
    s.nis,
    s.nama_lengkap,
    k.nama as kelas,
    kar.periode,
    kar.tanggal,
    kar.sikap,
    kar.komunikasi,
    kar.etos_kerja,
    kar.disiplin,
    (kar.sikap + kar.komunikasi + kar.etos_kerja + kar.disiplin) / 4 as rata_rata,
    kar.penilai
FROM santri s
LEFT JOIN kelas k ON s.kelas_id = k.id
JOIN karakter kar ON s.id = kar.santri_id
ORDER BY s.nama_lengkap, kar.tanggal DESC;

-- View untuk statistik dashboard
CREATE VIEW dashboard_statistics AS
SELECT 
    (SELECT COUNT(*) FROM santri WHERE status = 'aktif') as total_santri,
    (SELECT COUNT(*) FROM guru WHERE status = 'aktif') as total_guru,
    (SELECT COUNT(*) FROM kegiatan WHERE DATE_TRUNC('month', tanggal) = DATE_TRUNC('month', CURRENT_DATE)) as total_kegiatan_bulan_ini,
    (SELECT COUNT(*) FROM fasilitas WHERE status = 'tersedia') as total_fasilitas,
    (SELECT COUNT(*) FROM kasus WHERE status IN ('terbuka', 'dalam-proses', 'menunggu-konfirmasi')) as total_kasus_aktif,
    (SELECT AVG((sikap + komunikasi + etos_kerja + disiplin) / 4) FROM karakter WHERE DATE_TRUNC('month', tanggal) = DATE_TRUNC('month', CURRENT_DATE)) as rata_rata_akhlak_bulan_ini;

-- =============================================
-- Fungsi untuk query yang sering digunakan
-- =============================================

-- Fungsi untuk mendapatkan statistik kasus per bulan
CREATE OR REPLACE FUNCTION get_statistik_kasus(bulan DATE)
RETURNS TABLE(
    total_kasus BIGINT,
    kasus_aktif BIGINT,
    kasus_selesai BIGINT,
    kasus_prioritas_tinggi BIGINT,
    kasus_prioritas_sedang BIGINT,
    kasus_prioritas_rendah BIGINT
) AS $$ BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_kasus,
        COUNT(CASE WHEN status IN ('terbuka', 'dalam-proses', 'menunggu-konfirmasi') THEN 1 END) as kasus_aktif,
        COUNT(CASE WHEN status = 'selesai' THEN 1 END) as kasus_selesai,
        COUNT(CASE WHEN prioritas = 'tinggi' THEN 1 END) as kasus_prioritas_tinggi,
        COUNT(CASE WHEN prioritas = 'sedang' THEN 1 END) as kasus_prioritas_sedang,
        COUNT(CASE WHEN prioritas = 'rendah' THEN 1 END) as kasus_prioritas_rendah
    FROM kasus
    WHERE DATE_TRUNC('month', tanggal) = DATE_TRUNC('month', bulan);
END;
 $$ LANGUAGE plpgsql;

-- Fungsi untuk mendapatkan rata-rata nilai karakter per santri
CREATE OR REPLACE FUNCTION get_rata_rata_karakter(santri_id_param UUID, periode_param VARCHAR)
RETURNS TABLE(
    sikap INTEGER,
    komunikasi INTEGER,
    etos_kerja INTEGER,
    disiplin INTEGER,
    rata_rata NUMERIC
) AS $$ BEGIN
    RETURN QUERY
    SELECT 
        AVG(sikap)::INTEGER as sikap,
        AVG(komunikasi)::INTEGER as komunikasi,
        AVG(etos_kerja)::INTEGER as etos_kerja,
        AVG(disiplin)::INTEGER as disiplin,
        (AVG(sikap) + AVG(komunikasi) + AVG(etos_kerja) + AVG(disiplin)) / 4 as rata_rata
    FROM karakter
    WHERE santri_id = santri_id_param AND periode = periode_param;
END;
 $$ LANGUAGE plpgsql;

-- Fungsi untuk mendapatkan rekap absensi per periode
CREATE OR REPLACE FUNCTION get_rekap_absensi(tanggal_mulai DATE, tanggal_selesai DATE, kelas_id_param UUID DEFAULT NULL)
RETURNS TABLE(
    santri_id UUID,
    nis VARCHAR,
    nama_lengkap VARCHAR,
    kelas VARCHAR,
    total_hadir INTEGER,
    total_sakit INTEGER,
    total_pulang INTEGER,
    total_mangkir INTEGER,
    persentasi_hadir NUMERIC
) AS $$ BEGIN
    RETURN QUERY
    SELECT 
        s.id as santri_id,
        s.nis,
        s.nama_lengkap,
        k.nama as kelas,
        COUNT(CASE WHEN a.status = 'hadir' THEN 1 END) as total_hadir,
        COUNT(CASE WHEN a.status = 'sakit' THEN 1 END) as total_sakit,
        COUNT(CASE WHEN a.status = 'pulang' THEN 1 END) as total_pulang,
        COUNT(CASE WHEN a.status = 'mangkir' THEN 1 END) as total_mangkir,
        (COUNT(CASE WHEN a.status = 'hadir' THEN 1 END) * 100.0 / COUNT(a.id)) as persentasi_hadir
    FROM santri s
    LEFT JOIN kelas k ON s.kelas_id = k.id
    LEFT JOIN absensi a ON s.id = a.santri_id AND a.tanggal BETWEEN tanggal_mulai AND tanggal_selesai
    WHERE (kelas_id_param IS NULL OR s.kelas_id = kelas_id_param)
    GROUP BY s.id, s.nis, s.nama_lengkap, k.nama
    ORDER BY k.nama, s.nama_lengkap;
END;
 $$ LANGUAGE plpgsql;

-- =============================================
-- Data awal untuk pengujian
-- =============================================

-- Data pengaturan awal
INSERT INTO pengaturan (key, value, deskripsi) VALUES
('nama_pesantren', 'Pesantren Al-Hikmah', 'Nama resmi pesantren'),
('alamat_pesantren', 'Jl. Pesantren No. 123, Jakarta', 'Alamat pesantren'),
('telepon_pesantren', '+62-21-1234567', 'Nomor telepon pesantren'),
('email_pesantren', 'info@alhikmah.sch.id', 'Email pesantren'),
('tahun_ajaran', '2023/2024', 'Tahun ajaran aktif'),
('semester', 'Genap', 'Semester aktif');

-- Data kelas awal
INSERT INTO kelas (nama, tingkat, jurusan, wali_kelas) VALUES
('1A', 'SD', NULL, 'Ustadz Ahmad'),
('1B', 'SD', NULL, 'Ustadzah Sarah'),
('2A', 'SD', NULL, 'Ustadz Budi'),
('2B', 'SD', NULL, 'Ustadzah Fatimah'),
('3A', 'SD', NULL, 'Ustadz Rahman'),
('3B', 'SD', NULL, 'Ustadzah Aisha'),
('4A', 'SMP', NULL, 'Ustadz Hasan'),
('4B', 'SMP', NULL, 'Ustadzah Khadijah'),
('5A', 'SMP', 'IPA', 'Ustadz Ali'),
('5B', 'SMP', 'IPS', 'Ustadzah Hafsah'),
('6A', 'SMA', 'IPA', 'Ustadz Umar'),
('6B', 'SMA', 'IPS', 'Ustadzah Zainab');

-- Data guru awal
INSERT INTO guru (nip, nama_lengkap, mata_pelajaran, no_hp, email, alamat) VALUES
('198001011234567001', 'Ustadz Ahmad, S.Pd.I', 'Al-Quran Hadis', '08123456789', 'ahmad@alhikmah.sch.id', 'Jl. Guru No. 1, Jakarta'),
('198502021234567002', 'Ustadzah Sarah, S.Pd.I', 'Aqidah Akhlak', '08123456790', 'sarah@alhikmah.sch.id', 'Jl. Guru No. 2, Jakarta'),
('198203031234567003', 'Ustadz Budi, S.Pd.I', 'Fiqh', '08123456791', 'budi@alhikmah.sch.id', 'Jl. Guru No. 3, Jakarta'),
('198704041234567004', 'Ustadzah Fatimah, S.Pd.I', 'Sejarah Islam', '08123456792', 'fatimah@alhikmah.sch.id', 'Jl. Guru No. 4, Jakarta'),
('199005051234567005', 'Ustadz Rahman, S.Pd', 'Bahasa Arab', '08123456793', 'rahman@alhikmah.sch.id', 'Jl. Guru No. 5, Jakarta'),
('199206061234567006', 'Ustadzah Aisha, S.Pd', 'Matematika', '08123456794', 'aisha@alhikmah.sch.id', 'Jl. Guru No. 6, Jakarta'),
('198807071234567007', 'Ustadz Hasan, S.Pd', 'Bahasa Indonesia', '08123456795', 'hasan@alhikmah.sch.id', 'Jl. Guru No. 7, Jakarta'),
('199108081234567008', 'Ustadzah Khadijah, S.Pd', 'Bahasa Inggris', '08123456796', 'khadijah@alhikmah.sch.id', 'Jl. Guru No. 8, Jakarta'),
('198909091234567009', 'Ustadz Ali, S.Pd', 'IPA', '08123456797', 'ali@alhikmah.sch.id', 'Jl. Guru No. 9, Jakarta'),
('199110101234567010', 'Ustadzah Hafsah, S.Pd', 'IPS', '08123456798', 'hafsah@alhikmah.sch.id', 'Jl. Guru No. 10, Jakarta'),
('199211111234567011', 'Ustadz Umar, M.Pd', 'Kimia', '08123456799', 'umar@alhikmah.sch.id', 'Jl. Guru No. 11, Jakarta'),
('199312121234567012', 'Ustadzah Zainab, M.Pd', 'Biologi', '08123456800', 'zainab@alhikmah.sch.id', 'Jl. Guru No. 12, Jakarta');

-- Data santri awal
INSERT INTO santri (nis, nama_lengkap, tempat_lahir, tanggal_lahir, kelas_id, alamat, nama_ortu, hp_ortu) VALUES
('20230001', 'Ahmad Rizki', 'Jakarta', '2015-01-15', (SELECT id FROM kelas WHERE nama = '1A'), 'Jl. Santri No. 1, Jakarta', 'Bapak Ahmad', '08123456801'),
('20230002', 'Sarah Putri', 'Bandung', '2015-02-20', (SELECT id FROM kelas WHERE nama = '1A'), 'Jl. Santri No. 2, Bandung', 'Bapak Budi', '08123456802'),
('20230003', 'Muhammad Fadli', 'Surabaya', '2015-03-10', (SELECT id FROM kelas WHERE nama = '1B'), 'Jl. Santri No. 3, Surabaya', 'Bapak Muhammad', '08123456803'),
('20230004', 'Aisyah Nur', 'Medan', '2015-04-05', (SELECT id FROM kelas WHERE nama = '1B'), 'Jl. Santri No. 4, Medan', 'Bapak Aisyah', '08123456804'),
('20230005', 'Abdullah Rahman', 'Yogyakarta', '2015-05-12', (SELECT id FROM kelas WHERE nama = '2A'), 'Jl. Santri No. 5, Yogyakarta', 'Bapak Abdullah', '08123456805'),
('20230006', 'Fatimah Zahra', 'Semarang', '2015-06-18', (SELECT id FROM kelas WHERE nama = '2A'), 'Jl. Santri No. 6, Semarang', 'Bapak Fatimah', '08123456806'),
('20230007', 'Umar bin Khattab', 'Palembang', '2015-07-22', (SELECT id FROM kelas WHERE nama = '2B'), 'Jl. Santri No. 7, Palembang', 'Bapak Umar', '08123456807'),
('20230008', 'Khadijah Aminah', 'Makassar', '2015-08-08', (SELECT id FROM kelas WHERE nama = '2B'), 'Jl. Santri No. 8, Makassar', 'Bapak Khadijah', '08123456808'),
('20230009', 'Ali bin Abi Thalib', 'Balikpapan', '2015-09-14', (SELECT id FROM kelas WHERE nama = '3A'), 'Jl. Santri No. 9, Balikpapan', 'Bapak Ali', '08123456809'),
('20230010', 'Zainab binti Khuzaimah', 'Denpasar', '2015-10-25', (SELECT id FROM kelas WHERE nama = '3A'), 'Jl. Santri No. 10, Denpasar', 'Bapak Zainab', '08123456810'),
('20230011', 'Hasan bin Ali', 'Manado', '2015-11-30', (SELECT id FROM kelas WHERE nama = '3B'), 'Jl. Santri No. 11, Manado', 'Bapak Hasan', '08123456811'),
('20230012', 'Husain bin Ali', 'Pontianak', '2015-12-05', (SELECT id FROM kelas WHERE nama = '3B'), 'Jl. Santri No. 12, Pontianak', 'Bapak Husain', '08123456812'),
('20220013', 'Abu Bakar Ash-Shiddiq', 'Jakarta', '2014-01-20', (SELECT id FROM kelas WHERE nama = '4A'), 'Jl. Santri No. 13, Jakarta', 'Bapak Abu Bakar', '08123456813'),
('20220014', 'Umar bin Khattab', 'Bandung', '2014-02-15', (SELECT id FROM kelas WHERE nama = '4A'), 'Jl. Santri No. 14, Bandung', 'Bapak Umar', '08123456814'),
('20220015', 'Uthman bin Affan', 'Surabaya', '2014-03-10', (SELECT id FROM kelas WHERE nama = '4B'), 'Jl. Santri No. 15, Surabaya', 'Bapak Uthman', '08123456815'),
('20220016', 'Ali bin Abi Thalib', 'Medan', '2014-04-25', (SELECT id FROM kelas WHERE nama = '4B'), 'Jl. Santri No. 16, Medan', 'Bapak Ali', '08123456816'),
('20220017', 'Aisyah binti Abu Bakar', 'Yogyakarta', '2014-05-30', (SELECT id FROM kelas WHERE nama = '5A'), 'Jl. Santri No. 17, Yogyakarta', 'Bapak Aisyah', '08123456817'),
('20220018', 'Hafshah binti Umar', 'Semarang', '2014-06-12', (SELECT id FROM kelas WHERE nama = '5A'), 'Jl. Santri No. 18, Semarang', 'Bapak Hafshah', '08123456818'),
('20220019', 'Fatimah binti Muhammad', 'Palembang', '2014-07-18', (SELECT id FROM kelas WHERE nama = '5B'), 'Jl. Santri No. 19, Palembang', 'Bapak Fatimah', '08123456819'),
('20220020', 'Zainab binti Khuzaimah', 'Makassar', '2014-08-22', (SELECT id FROM kelas WHERE nama = '5B'), 'Jl. Santri No. 20, Makassar', 'Bapak Zainab', '08123456820'),
('20210021', 'Abdullah ibn Abbas', 'Balikpapan', '2013-01-25', (SELECT id FROM kelas WHERE nama = '6A'), 'Jl. Santri No. 21, Balikpapan', 'Bapak Abdullah', '08123456821'),
('20210022', 'Abdullah ibn Umar', 'Denpasar', '2013-02-28', (SELECT id FROM kelas WHERE nama = '6A'), 'Jl. Santri No. 22, Denpasar', 'Bapak Abdullah', '08123456822'),
('20210023', 'Abu Hurairah', 'Manado', '2013-03-15', (SELECT id FROM kelas WHERE nama = '6B'), 'Jl. Santri No. 23, Manado', 'Bapak Abu Hurairah', '08123456823'),
('20210024', 'Anas bin Malik', 'Pontianak', '2013-04-10', (SELECT id FROM kelas WHERE nama = '6B'), 'Jl. Santri No. 24, Pontianak', 'Bapak Anas', '08123456824');

-- Data kegiatan awal
INSERT INTO kegiatan (nama, tanggal, waktu, lokasi, penanggung_jawab, status, deskripsi) VALUES
('Pesantren Kilat Ramadhan', '2023-03-15', '08:00', 'Masjid Pesantren', 'Ustadz Ahmad', 'selesai', 'Kegiatan intensif selama bulan Ramadhan untuk meningkatkan keimanan dan takwa'),
('Peringatan Isra Miraj', '2023-02-17', '19:00', 'Aula Pesantren', 'Ustadzah Sarah', 'selesai', 'Peringatan peristiwa Isra Miraj dengan ceramah dan lomba'),
('Lomba Tartil Quran', '2023-04-20', '08:00', 'Masjid Pesantren', 'Ustadz Budi', 'dalam_proses', 'Lomba tartil Quran antar kelas untuk meningkatkan kemampuan membaca Quran'),
('Bakti Sosial', '2023-05-10', '07:00', 'Desa Sekitar Pesantren', 'Ustadzah Fatimah', 'dalam_proses', 'Kegiatan bakti sosial kepada masyarakat sekitar pesantren'),
('Wisuda Santri', '2023-06-25', '09:00', 'Aula Pesantren', 'Ustadz Rahman', 'dalam_proses', 'Wisuda santri yang telah menyelesaikan pendidikan'),
('Rapat Orang Tua Wali', '2023-07-15', '13:00', 'Aula Pesantren', 'Ustadzah Aisha', 'dalam_proses', 'Rapat rutin dengan orang tua/wali santri untuk membahas perkembangan santri'),
('Perkemahan Pramuka', '2023-08-10', '07:00', 'Area Perkemahan Pesantren', 'Ustadz Hasan', 'dalam_proses', 'Kegiatan perkemahan pramuka untuk melatih kemandirian dan kepemimpinan'),
('Maulid Nabi Muhammad', '2023-09-15', '19:00', 'Masjid Pesantren', 'Ustadzah Khadijah', 'dalam_proses', 'Peringatan Maulid Nabi Muhammad dengan ceramah dan pawai'),
('Olimpiade Sains', '2023-10-20', '08:00', 'Lab Komputer', 'Ustadz Ali', 'dalam_proses', 'Olimpiade sains antar kelas untuk meningkatkan minat belajar sains'),
('Hari Santri Nasional', '2023-11-22', '08:00', 'Lapangan Pesantren', 'Ustadzah Hafsah', 'dalam_proses', 'Peringatan Hari Santri Nasional dengan berbagai lomba dan kegiatan');

-- Data fasilitas awal
INSERT INTO fasilitas (nama, kapasitas, kondisi, penanggung_jawab, status, deskripsi, pemeriksaan_terakhir) VALUES
('Masjid Jami', '500', 'baik', 'Ustadz Ahmad', 'tersedia', 'Masjid utama untuk shalat berjamaah dan kegiatan keagamaan', '2023-06-01'),
('Aula Serbaguna', '300', 'baik', 'Ustadzah Sarah', 'tersedia', 'Aula untuk acara besar seperti seminar, wisuda, dll', '2023-06-05'),
('Perpustakaan', '100', 'baik', 'Ustadz Budi', 'tersedia', 'Perpustakaan dengan koleksi buku agama dan umum', '2023-06-10'),
('Lab Komputer', '40', 'baik', 'Ustadzah Fatimah', 'tersedia', 'Laboratorium komputer untuk pembelajaran teknologi', '2023-06-12'),
('Lab Sains', '30', 'sedang', 'Ustadz Rahman', 'tersedia', 'Laboratorium sains untuk praktikum IPA', '2023-05-28'),
('Lapangan Olahraga', '200', 'baik', 'Ustadzah Aisha', 'tersedia', 'Lapangan untuk kegiatan olahraga dan outbound', '2023-06-08'),
('Kantin', '150', 'baik', 'Ustadz Hasan', 'tersedia', 'Kantin untuk menyediakan makanan dan minuman santri', '2023-06-15'),
('Asrama Putra', '200', 'baik', 'Ustadzah Khadijah', 'tersedia', 'Asrama untuk santri putra', '2023-06-01'),
('Asrama Putri', '200', 'baik', 'Ustadz Ali', 'tersedia', 'Asrama untuk santri putri', '2023-06-01'),
('Ruang Kelas 1A', '30', 'baik', 'Ustadz Ahmad', 'tersedia', 'Ruang kelas untuk kelas 1A', '2023-06-01'),
('Ruang Kelas 1B', '30', 'baik', 'Ustadzah Sarah', 'tersedia', 'Ruang kelas untuk kelas 1B', '2023-06-01'),
('Ruang Kelas 2A', '30', 'baik', 'Ustadz Budi', 'tersedia', 'Ruang kelas untuk kelas 2A', '2023-06-01'),
('Ruang Kelas 2B', '30', 'baik', 'Ustadzah Fatimah', 'tersedia', 'Ruang kelas untuk kelas 2B', '2023-06-01'),
('Ruang Kelas 3A', '30', 'baik', 'Ustadz Rahman', 'tersedia', 'Ruang kelas untuk kelas 3A', '2023-06-01'),
('Ruang Kelas 3B', '30', 'baik', 'Ustadzah Aisha', 'tersedia', 'Ruang kelas untuk kelas 3B', '2023-06-01'),
('Ruang Kelas 4A', '30', 'baik', 'Ustadz Hasan', 'tersedia', 'Ruang kelas untuk kelas 4A', '2023-06-01'),
('Ruang Kelas 4B', '30', 'baik', 'Ustadzah Khadijah', 'tersedia', 'Ruang kelas untuk kelas 4B', '2023-06-01'),
('Ruang Kelas 5A', '30', 'baik', 'Ustadz Ali', 'tersedia', 'Ruang kelas untuk kelas 5A', '2023-06-01'),
('Ruang Kelas 5B', '30', 'baik', 'Ustadzah Umar', 'tersedia', 'Ruang kelas untuk kelas 5B', '2023-06-01'),
('Ruang Kelas 6A', '30', 'baik', 'Ustadzah Zainab', 'tersedia', 'Ruang kelas untuk kelas 6A', '2023-06-01'),
('Ruang Kelas 6B', '30', 'baik', 'Ustadz Ahmad', 'tersedia', 'Ruang kelas untuk kelas 6B', '2023-06-01'),
('Klinik Kesehatan', '20', 'baik', 'Ustadzah Sarah', 'tersedia', 'Klinik untuk pelayanan kesehatan dasar santri', '2023-06-10'),
('Laundry', '50', 'sedang', 'Ustadz Budi', 'tersedia', 'Fasilitas laundry untuk mencuci pakaian santri', '2023-05-25');

-- Data aspek penilaian karakter
INSERT INTO karakter_aspek (nama, deskripsi, bobot) VALUES
('Sikap', 'Menilai perilaku dan sikap santri dalam kehidupan sehari-hari', 1),
('Komunikasi', 'Menilai kemampuan berkomunikasi dengan teman dan guru', 1),
('Etos Kerja', 'Menilai semangat dan dedikasi dalam menyelesaikan tugas', 1),
('Disiplin', 'Menilai kedisiplinan dalam mengikuti aturan dan jadwal', 1),
('Kejujuran', 'Menilai kejujuran dalam berbagai situasi', 1),
('Tanggung Jawab', 'Menilai kemampuan bertanggung jawab atas tugas dan peran', 1),
('Sosial', 'Menilai kemampuan bersosialisasi dengan lingkungan sekitar', 1),
('Leadership', 'Menilai kemampuan memimpin dan mengorganisir', 1);

-- Data contoh untuk tabel kasus
INSERT INTO kasus (judul, santri_id, tanggal, jenis, prioritas, status, deskripsi, saksi, tindakan, penanggung_jawab, tindak_lanjut) VALUES
('Terlambat Shalat Subuh', (SELECT id FROM santri WHERE nis = '20230001'), '2023-06-15', 'ibadah', 'sedang', 'terbuka', 'Santri terlambat mengikuti shalat subuh berjamaah selama 3 hari berturut-turut', 'Ustadz Ahmad', 'Diberi nasihat dan pengingat untuk bangun lebih awal', 'Ustadz Ahmad', 'Pemantauan selama 1 minggu ke depan'),
('Tidak Mengerjakan PR', (SELECT id FROM santri WHERE nis = '20230002'), '2023-06-14', 'akademik', 'rendah', 'dalam-proses', 'Santri tidak mengerjakan PR Matematika yang diberikan minggu lalu', 'Ustadzah Sarah', 'Diberi kesempatan untuk mengerjakan dengan pengurangan nilai', 'Ustadzah Sarah', 'Pemantauan rutin pengerjaan PR'),
('Berkata Kasar kepada Teman', (SELECT id FROM santri WHERE nis = '20230003'), '2023-06-13', 'sosial', 'tinggi', 'menunggu-konfirmasi', 'Santri menggunakan kata-kata kasar saat bertengkar dengan teman satu kamar', 'Santri lain di kamar', 'Diberi nasihat dan diminta meminta maaf kepada temannya', 'Ustadz Budi', 'Menunggu konfirmasi dari orang tua'),
('Membuang Sampah Sembarangan', (SELECT id FROM santri WHERE nis = '20230004'), '2023-06-12', 'kebersihan', 'sedang', 'selesai', 'Santri kedapatan membuang sampah di area asrama', 'Ustadzah Fatimah', 'Diberi tugas membersihkan area asrama selama 1 minggu', 'Ustadzah Fatimah', 'Pemantauan kebiasaan membuang sampah'),
('Bolos Kelas', (SELECT id FROM santri WHERE nis = '20230005'), '2023-06-11', 'disiplin', 'tinggi', 'dalam-proses', 'Santri tidak mengikuti pelajaran Fiqih tanpa alasan yang jelas', 'Wali kelas', 'Diberi sanksi tambahan tugas dan pemanggilan orang tua', 'Ustadz Rahman', 'Menunggu kedatangan orang tua untuk diskusi lebih lanjut'),
('Menggunakan HP di Jam Belajar', (SELECT id FROM santri WHERE nis = '20230006'), '2023-06-10', 'disiplin', 'sedang', 'terbuka', 'Santri kedapatan menggunakan HP saat jam pelajaran berlangsung', 'Ustadzah Aisha', 'HP disita dan akan dikembalikan setelah 1 minggu', 'Ustadzah Aisha', 'Pemantauan penggunaan gadget selama jam belajar');

-- Data contoh untuk tabel karakter
INSERT INTO karakter (santri_id, periode, tanggal, sikap, komunikasi, etos_kerja, disiplin, sikap_keterangan, komunikasi_keterangan, etos_kerja_keterangan, disiplin_keterangan, catatan, penilai) VALUES
((SELECT id FROM santri WHERE nis = '20230001'), 'bulan-6', '2023-06-15', 75, 80, 70, 85, 'Sopan kepada guru dan teman, namun kadang masih lupa salam', 'Aktif dalam diskusi kelas, mampu menyampaikan pendapat dengan baik', 'Semangat belajar tinggi, namun kadang menunda-nunda tugas', 'Selalu tepat waktu dalam mengikuti jadwal kegiatan', 'Perlu ditingkatkan lagi dalam hal kedisiplinan mengerjakan tugas', 'Ustadz Ahmad'),
((SELECT id FROM santri WHERE nis = '20230002'), 'bulan-6', '2023-06-15', 85, 75, 80, 70, 'Sangat sopan dan ramah kepada semua orang', 'Cukup baik dalam berkomunikasi, namun terkadang malu-malu saat presentasi', 'Memiliki etos kerja yang baik, selalu mengerjakan tugas tepat waktu', 'Kadang terlambat bangun untuk shalat subuh', 'Perlu bimbingan lebih dalam untuk meningkatkan keberanian berbicara di depan umum', 'Ustadzah Sarah'),
((SELECT id FROM santri WHERE nis = '20230003'), 'bulan-6', '2023-06-15', 70, 85, 75, 80, 'Sopan namun kadang masih perlu diingatkan untuk bersikap adil', 'Sangat baik dalam berkomunikasi, aktif dalam diskusi kelompok', 'Cukup baik dalam mengerjakan tugas, namun kadang perlu diingatkan', 'Baik dalam mengikuti jadwal, namun kadang lupa membawa buku pelajaran', 'Perlu lebih mandiri dalam mengingat jadwal dan tugas', 'Ustadz Budi'),
((SELECT id FROM santri WHERE nis = '20230004'), 'bulan-6', '2023-06-15', 80, 70, 85, 75, 'Sangat sopan dan perhatian kepada teman yang kesulitan', 'Cukup baik, namun kadang masih ragu-ragu saat menyampaikan pendapat', 'Memiliki semangat belajar yang tinggi, selalu antusias dalam mengerjakan tugas', 'Baik dalam mengikuti jadwal, namun kadang terlambat dalam berkumpul', 'Perlu lebih percaya diri dalam menyampaikan pendapat', 'Ustadzah Fatimah'),
((SELECT id FROM santri WHERE nis = '20230005'), 'bulan-6', '2023-06-15', 90, 80, 75, 85, 'Sangat sopan dan menjadi panutan bagi teman-temannya', 'Baik dalam berkomunikasi, mampu menyampaikan ide dengan jelas', 'Cukup baik dalam mengerjakan tugas, namun kadang kurang teliti', 'Sangat baik dalam mengikuti jadwal, selalu tepat waktu', 'Perlu lebih teliti dalam mengerjakan tugas', 'Ustadz Rahman'),
((SELECT id FROM santri WHERE nis = '20230006'), 'bulan-6', '2023-06-15', 75, 90, 80, 70, 'Sopan namun kadang masih egois saat berdiskusi', 'Sangat baik dalam berkomunikasi, aktif dalam presentasi', 'Memiliki etos kerja yang baik, namun kadang terlalu perfeksionis', 'Kadang terlambat dalam mengikuti kegiatan ekstrakurikuler', 'Perlu belajar untuk lebih fleksibel dan tidak terlalu perfeksionis', 'Ustadzah Aisha');

-- Data contoh untuk tabel absensi
INSERT INTO absensi (santri_id, tanggal, status, keterangan) VALUES
((SELECT id FROM santri WHERE nis = '20230001'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230002'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230003'), '2023-06-15', 'sakit', 'Demam'),
((SELECT id FROM santri WHERE nis = '20230004'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230005'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230006'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230007'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230008'), '2023-06-15', 'pulang', 'Izin orang tua'),
((SELECT id FROM santri WHERE nis = '20230009'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230010'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230011'), '2023-06-15', 'mangkir', NULL),
((SELECT id FROM santri WHERE nis = '20230012'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220013'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220014'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220015'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220016'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220017'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220018'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220019'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220020'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210021'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210022'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210023'), '2023-06-15', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210024'), '2023-06-15', 'hadir', NULL);

-- Data contoh untuk tabel absensi_guru
INSERT INTO absensi_guru (guru_id, tanggal, sesi, status, keterangan) VALUES
((SELECT id FROM guru WHERE nip = '198001011234567001'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198502021234567002'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198203031234567003'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198704041234567004'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199005051234567005'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199206061234567006'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198807071234567007'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199108081234567008'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198909091234567009'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199110101234567010'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199211111234567011'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199312121234567012'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198001011234567001'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198502021234567002'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198203031234567003'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198704041234567004'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199005051234567005'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199206061234567006'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198807071234567007'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199108081234567008'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '198909091234567009'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199110101234567010'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199211111234567011'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM guru WHERE nip = '199312121234567012'), '2023-06-15', 'sore', 'hadir', NULL);

-- Data contoh untuk tabel absensi_santri
INSERT INTO absensi_santri (santri_id, tanggal, sesi, status, keterangan) VALUES
((SELECT id FROM santri WHERE nis = '20230001'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230002'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230003'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230004'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230005'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230006'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230007'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230008'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230009'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230010'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230011'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230012'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220013'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220014'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220015'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220016'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220017'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220018'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220019'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220020'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210021'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210022'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210023'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210024'), '2023-06-15', 'pagi', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230001'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230002'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230003'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230004'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230005'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230006'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230007'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230008'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230009'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230010'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230011'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230012'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220013'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220014'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220015'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220016'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220017'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220018'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220019'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220020'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210021'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210022'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210023'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210024'), '2023-06-15', 'sore', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230001'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230002'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230003'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230004'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230005'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230006'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230007'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230008'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230009'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230010'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230011'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20230012'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220013'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220014'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220015'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220016'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220017'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220018'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220019'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20220020'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210021'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210022'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210023'), '2023-06-15', 'malam', 'hadir', NULL),
((SELECT id FROM santri WHERE nis = '20210024'), '2023-06-15', 'malam', 'hadir', NULL);

-- Data contoh untuk tabel kasus_riwayat
INSERT INTO kasus_riwayat (kasus_id, tanggal, penangan, tindakan, hasil) VALUES
((SELECT id FROM kasus WHERE judul = 'Terlambat Shalat Subuh'), '2023-06-15 10:00:00', 'Ustadz Ahmad', 'Memberikan nasihat tentang pentingnya shalat subuh berjamaah', 'Santri menyadari kesalahannya dan berjanji akan bangun lebih awal'),
((SELECT id FROM kasus WHERE judul = 'Tidak Mengerjakan PR'), '2023-06-14 14:00:00', 'Ustadzah Sarah', 'Memberikan kesempatan kedua untuk mengerjakan PR dengan pengurangan nilai', 'Santri mengerjakan PR dan meminta maaf atas kelalaiannya'),
((SELECT id FROM kasus WHERE judul = 'Berkata Kasar kepada Teman'), '2023-06-13 16:00:00', 'Ustadz Budi', 'Memfasilitasi mediasi antara dua santri yang bertengkar', 'Kedua santri saling meminta maaf dan berdamai'),
((SELECT id FROM kasus WHERE judul = 'Membuang Sampah Sembarangan'), '2023-06-12 09:00:00', 'Ustadzah Fatimah', 'Memberikan tugas membersihkan area asrama selama 1 minggu', 'Santri menyelesaikan tugas dengan baik dan lebih sadar akan kebersihan'),
((SELECT id FROM kasus WHERE judul = 'Bolos Kelas'), '2023-06-11 13:00:00', 'Ustadz Rahman', 'Memberikan sanksi tambahan tugas dan menjadwalkan pemanggilan orang tua', 'Menunggu konfirmasi dari orang tua untuk tindakan lebih lanjut'),
((SELECT id FROM kasus WHERE judul = 'Menggunakan HP di Jam Belajar'), '2023-06-10 11:00:00', 'Ustadzah Aisha', 'Menyita HP dan memberikan aturan tentang penggunaan gadget', 'HP disita dan akan dikembalikan setelah 1 minggu');

-- Data contoh untuk tabel karakter_detail
INSERT INTO karakter_detail (karakter_id, aspek_id, nilai, keterangan) VALUES
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230001') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Sikap'), 75, 'Sopan kepada guru dan teman, namun kadang masih lupa salam'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230001') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Komunikasi'), 80, 'Aktif dalam diskusi kelas, mampu menyampaikan pendapat dengan baik'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230001') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Etos Kerja'), 70, 'Semangat belajar tinggi, namun kadang menunda-nunda tugas'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230001') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Disiplin'), 85, 'Selalu tepat waktu dalam mengikuti jadwal kegiatan'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230002') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Sikap'), 85, 'Sangat sopan dan ramah kepada semua orang'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230002') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Komunikasi'), 75, 'Cukup baik dalam berkomunikasi, namun terkadang malu-malu saat presentasi'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230002') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Etos Kerja'), 80, 'Memiliki etos kerja yang baik, selalu mengerjakan tugas tepat waktu'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230002') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Disiplin'), 70, 'Kadang terlambat bangun untuk shalat subuh'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230003') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Sikap'), 70, 'Sopan namun kadang masih perlu diingatkan untuk bersikap adil'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230003') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Komunikasi'), 85, 'Sangat baik dalam berkomunikasi, aktif dalam diskusi kelompok'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230003') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Etos Kerja'), 75, 'Cukup baik dalam mengerjakan tugas, namun kadang perlu diingatkan'),
((SELECT id FROM karakter WHERE santri_id = (SELECT id FROM santri WHERE nis = '20230003') AND periode = 'bulan-6'), (SELECT id FROM karakter_aspek WHERE nama = 'Disiplin'), 80, 'Baik dalam mengikuti jadwal, namun kadang lupa membawa buku pelajaran');