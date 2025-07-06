DASHBOARD ANALISIS DAMPAK IKLIM (1993-2023)
==========================================

Tentang Dashboard
-----------------
Dashboard ini dirancang untuk membantu menganalisis hubungan antara aktivitas manusia dan perubahan iklim global.
Dengan data periode 1993-2023, pengguna dapat mengeksplorasi dampak pertumbuhan penduduk dan emisi CO₂ terhadap perubahan suhu global dan kenaikan permukaan laut.

Tujuan Penelitian
-----------------
- Mengidentifikasi korelasi antara pertumbuhan penduduk dan emisi CO₂ terhadap suhu permukaan bumi dan ketinggian permukaan laut.
- Menganalisis dampak kedua faktor tersebut terhadap variabel iklim.
- Membangun model prediktif untuk memahami tren masa depan.
- Memberikan rekomendasi kebijakan berbasis data.

Persiapan Data
--------------
Siapkan 3 file berikut:
- data_iklim_gabungan.csv  : Data iklim komprehensif.
- negara.csv               : Informasi negara dan koordinat.
- sea_level.csv            : Data kenaikan permukaan laut.

Langkah:
1. Unggah file via dashboard.
2. Klik 'Load Data'.
3. Cek statistik deskriptif untuk memastikan data valid.

Catatan:
Pastikan format data valid dan tidak ada missing values.

Fitur Analisis
--------------

1. Analisis Korelasi
--------------------
Mengukur kekuatan hubungan antar variabel.

Metode:
- Pearson
- Spearman
- Kendall

Langkah:
- Pilih variabel X dan Y.
- Tentukan metode korelasi.
- Pilih rentang tahun.
- Klik 'Analisis Korelasi'.
- Lihat hasil: scatter plot, nilai r, p-value, dan interpretasi otomatis.

2. Analisis Regresi (BETA)
--------------------------
Membangun model prediktif.

Jenis model:
- Linear sederhana
- Polinomial

Langkah:
- Pilih variabel prediktor (X) dan target (Y).
- Tentukan jenis model.
- Jalankan analisis.
- Lihat hasil: plot regresi, R², RMSE/MAE, diagnostik residual.

Catatan:
Fitur ini belum mendukung regresi robust dan outlier handling otomatis.

3. Uji Hipotesis
----------------
Menguji signifikansi hubungan antar variabel.

Hipotesis:
- H₀ : Tidak ada hubungan signifikan.
- H₁ : Ada hubungan signifikan.

Langkah:
- Pilih 2 variabel.
- Tentukan periode.
- Pilih tingkat signifikansi (α).
- Jalankan uji.
- Interpretasikan hasil p-value.

4. Analisis Global
------------------
Analisis tren iklim secara global.

Fitur:
- Tren temporal tahunan.
- Korelasi antar variabel.
- Statistik ringkasan per tahun.

Gunakan untuk:
- Melihat pola jangka panjang.
- Membandingkan antar dekade.
- Menjadi baseline analisis regional.

5. Peta Interaktif
------------------
Visualisasi spasial data iklim.

Langkah:
- Pilih variabel.
- Atur slider tahun.
- Filter regional.
- Sesuaikan skema warna dan ukuran marker.
- Hover/klik titik untuk detail.

Saran:
Gunakan animasi temporal untuk melihat tren waktu.

6. Eksplorasi Data
------------------
Tabel interaktif untuk seluruh data.

Fitur:
- Search dan filter kolom.
- Sorting dan paging.
- Export ke CSV, Excel, PDF.

Gunakan untuk:
- Memeriksa kualitas data.
- Mendeteksi outlier.
- Menemukan insight awal.

7. Uji Kenormalan (Inferensia)
------------------------------
Validasi distribusi normal data.

Metode:
- Shapiro-Wilk : Untuk n < 5000
- Kolmogorov-Smirnov : Untuk n > 50

Langkah:
- Pilih variabel.
- Tentukan periode.
- Pilih metode uji.
- Interpretasikan hasil: p-value, histogram + kurva normal, Q-Q plot, kesimpulan otomatis.

Catatan:
Jika data tidak normal, gunakan metode non-parametrik atau lakukan transformasi data.

Data Periode
------------
1993 - 2023

Catatan Tambahan
----------------
- Selalu periksa kualitas data sebelum analisis.
- Gunakan hasil regresi dengan hati-hati karena belum tersedia regresi robust.
- Simpan hasil dan export untuk dokumentasi.
