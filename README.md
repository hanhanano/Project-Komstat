# Dashboard Analisis Dampak Iklim (1993-2023)

## Tentang Dashboard

Dashboard ini dirancang untuk membantu menganalisis hubungan kompleks antara aktivitas manusia dan perubahan iklim global.  
Menggunakan data periode **1993-2023**, pengguna dapat mengeksplorasi dampak **pertumbuhan penduduk** dan **emisi CO₂** terhadap **perubahan suhu global** dan **kenaikan permukaan laut**.

---

## Tujuan Penelitian

- **Mengidentifikasi korelasi** antara pertumbuhan penduduk dan emisi CO₂ terhadap suhu permukaan bumi dan ketinggian permukaan laut.
- **Menganalisis dampak** kedua faktor terhadap variabel iklim.
- **Membangun model prediktif** untuk memahami tren masa depan.
- **Memberikan rekomendasi kebijakan** berbasis data.

---
## Metadata Deskriptif 
##     Fitur                Variabel                                    Tipe Data
-   Analisis Korelasi     >= 2 Numerik                                  Numerik
-   Analisis Regresi      Respon(Y), Prediktor(X1,...,Xn)               Numerik, Kategorik
-   Uji Hipotesis	        kategorik, numerik	                          Numerik, Kategorik
-   Analisis Tren Global	Waktu (date, year, month), numerik	          Tanggal, Numerik
-   Peta Interaktif	      Latitude, Longitude, numerik/kategorik	      Numerik, Teks
-   Analisis Inferensial	numerik/kategorik, minimal 2 kelompok data	  Numerik, Kategorik                                            

## Metadata Struktural
##    Kolom               Tipe Data      Contoh          Keterangan
File1
-    country                String      Indonesia
-    year                    int         2020
-    population             decimal      128678
-    co2                    decimal      1.478
-    temp_change            decimal      0.123
-    Plog_pop               decimal      0.40          persentase populasi
-    Plog_co2               decimal      0.02          persentase co2
-    PER001                 decimal      
-    ln_population          decimal      4.5
-    ln_co2                 decimal      0.3 
-    ln_temp_change         decimal      0.3
-    ln_co2percapita        decimal      0.1  
File2 
-    FULL_NAME              Stirng       Indonesia
-    lat                    decimal       33.0            latitude      
-    lng                    decimal       66.0            longitude      
File3 
-    Sea_level              decimal       -32.8
-    Kenaikan               decimal       0.001
-    ln_Sea_level           decimal       -3.35
## Persiapan Data

Siapkan 3 file data berikut:

1. `data_iklim_gabungan.csv` — Data iklim komprehensif
2. `negara.csv` — Informasi negara dan koordinat
3. `sea_level.csv` — Data kenaikan permukaan laut

**Langkah:**
- Unggah file via tombol upload di dashboard
- Klik tombol **Load Data**
- Verifikasi statistik deskriptif

> **Tips:** Pastikan format data valid dan tidak ada missing values sebelum melanjutkan.

---

## Fitur Analisis

### 1. Analisis Korelasi  
Mengukur kekuatan hubungan antar dua variabel.

**Metode:**
- Pearson
- Spearman
- Kendall

**Langkah:**
- Pilih variabel X dan Y
- Tentukan metode korelasi
- Pilih rentang tahun
- Klik **Analisis Korelasi**
- Interpretasi hasil:
  - Scatter plot
  - Nilai korelasi (r)
  - P-value
  - Penjelasan otomatis

---

### 2. Analisis Regresi (BETA)  
Membangun model prediktif.

**Jenis Model:**
- Linear Sederhana
- Polinomial

**Langkah:**
- Pilih variabel X dan Y
- Pilih jenis model
- Jalankan analisis
- Evaluasi hasil:
  - Plot regresi
  - R²
  - RMSE/MAE
  - Diagnostik residual

> **Catatan:** Belum mendukung regresi robust & outlier handling otomatis.

---

### 3. Uji Hipotesis  
Menguji signifikansi hubungan antar variabel.

**Hipotesis:**
- H₀: Tidak ada hubungan signifikan
- H₁: Ada hubungan signifikan

**Langkah:**
- Pilih dua variabel
- Tentukan periode
- Atur tingkat signifikansi (α)
- Jalankan uji
- Interpretasi hasil

---

### 4. Analisis Global  
Melihat tren iklim global agregat.

**Fitur:**
- Tren tahunan
- Korelasi antar variabel
- Statistik ringkasan

---

### 5. Peta Interaktif  
Visualisasi spasial data iklim.

**Langkah:**
- Pilih variabel
- Gunakan slider tahun
- Filter regional
- Atur warna & marker
- Interaksi klik & hover

---

### 6. Eksplorasi Data  
Tabel interaktif data mentah.

**Fitur:**
- Search & filter
- Sorting & paging
- Export ke CSV, Excel, PDF

---

### 7. Uji Kenormalan  
Validasi distribusi normal data.

**Metode:**
- Shapiro-Wilk (n < 5000)
- Kolmogorov-Smirnov (n > 50)

**Langkah:**
- Pilih variabel & periode
- Pilih metode uji
- Interpretasi p-value, histogram, Q-Q plot, kesimpulan

> Jika data tidak normal, gunakan transformasi data atau metode non-parametrik.

---

## Catatan Tambahan

- Cek kualitas data sebelum analisis.
- Hasil regresi sementara, gunakan regresi robust di software statistik untuk finalisasi.
- Simpan hasil visualisasi dan export data untuk dokumentasi.

---

