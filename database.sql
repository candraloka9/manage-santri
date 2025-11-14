-- Pertma
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

-- Index untuk performa
CREATE INDEX idx_absensi_santri_id ON absensi(santri_id);
CREATE INDEX idx_absensi_tanggal ON absensi(tanggal);
CREATE INDEX idx_hafalan_santri_id ON hafalan(santri_id);
CREATE INDEX idx_hafalan_tanggal ON hafalan(tanggal);
CREATE INDEX idx_kesantrian_santri_id ON kesantrian(santri_id);
CREATE INDEX idx_kasus_santri_id ON kasus(santri_id);

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

-- View untuk dashboard
CREATE VIEW dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM profiles) as total_santri,
    (SELECT COUNT(*) FROM absensi WHERE tanggal = CURRENT_DATE AND status = 'hadir') as hadir_hari_ini,
    (SELECT COALESCE(SUM(halaman_akhir - halaman_awal + 1), 0) FROM hafalan) as total_halaman,
    (SELECT COUNT(*) FROM kasus) as total_kasus;

-- ==============================================================================================
-- ==============================================================================================
-- Kedua
-- Enable RLS pada semua tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE absensi ENABLE ROW LEVEL SECURITY;
ALTER TABLE hafalan ENABLE ROW LEVEL SECURITY;
ALTER TABLE kesantrian ENABLE ROW LEVEL SECURITY;
ALTER TABLE kasus ENABLE ROW LEVEL SECURITY;

-- Policies untuk profiles
CREATE POLICY "Allow all operations for authenticated users" ON profiles
FOR ALL USING (auth.role() = 'authenticated');

-- Policies untuk absensi
CREATE POLICY "Allow all operations for authenticated users" ON absensi
FOR ALL USING (auth.role() = 'authenticated');

-- Policies untuk hafalan
CREATE POLICY "Allow all operations for authenticated users" ON hafalan
FOR ALL USING (auth.role() = 'authenticated');

-- Policies untuk kesantrian
CREATE POLICY "Allow all operations for authenticated users" ON kesantrian
FOR ALL USING (auth.role() = 'authenticated');

-- Policies untuk kasus
CREATE POLICY "Allow all operations for authenticated users" ON kasus
FOR ALL USING (auth.role() = 'authenticated');

-- ======================
-- ======================
-- kemudian buat akun admin di supabase, dan hilangkan ceklist confirm email
