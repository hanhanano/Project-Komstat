# ==============================================================================
# BAGIAN 1: LIBRARY
# ==============================================================================
# Library untuk framework utama Shiny dan tampilan dashboard
library(shiny)          # Framework utama untuk aplikasi web interaktif
library(shinydashboard) # Template dashboard dengan layout sidebar dan konten
library(shinyWidgets)   # Widget tambahan untuk input yang lebih menarik

# Library untuk visualisasi data dan plotting
library(DT)            # Membuat tabel interaktif dengan fitur sorting, filtering
library(plotly)        # Grafik interaktif dengan zoom, hover, pan
library(corrplot)      # Visualisasi matriks korelasi dengan berbagai style
library(ggplot2)       # Grammar of graphics untuk plotting statis
library(leaflet)       # Peta interaktif berbasis web

# Library untuk manipulasi dan analisis data
library(dplyr)         # Grammar of data manipulation (filter, select, mutate, etc.)
library(tidyr)         # Tidy data (pivot, gather, spread operations)
library(readr)         # Membaca file CSV dengan parsing yang cepat dan akurat

# Library untuk skema warna dan styling
library(RColorBrewer)  # Palet warna yang telah didefinisi untuk visualisasi
library(viridis)       # Skema warna yang colorblind-friendly dan perceptually uniform

# ==============================================================================
# BAGIAN 2: STRUKTUR TAMPILAN APLIKASI
# ==============================================================================
ui <- dashboardPage(
  
  # ------------------------------------------------------------------------------
  # Header Dashboard
  # ------------------------------------------------------------------------------
  dashboardHeader(title = "Dashboard Analisis"),
  
  # ------------------------------------------------------------------------------
  # Sidebar Dashboard
  # ------------------------------------------------------------------------------
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",  # ID untuk tracking tab aktif
      
      # Menu item untuk halaman overview/ringkasan
      menuItem(" Overview", tabName = "overview", icon = icon("home")),
      
      # Menu item untuk analisis korelasi antar variabel
      menuItem(" Analisis Korelasi", tabName = "correlation", icon = icon("chart-line")),
      
      # Menu item untuk analisis regresi (masih dalam pengembangan - Beta)
      menuItem(" Analisis Regresi (Beta)", tabName = "regression", icon = icon("chart-line")),
      
      # Menu item untuk uji hipotesis statistik
      menuItem(" Uji Hipotesis", tabName = "hypothesis", icon = icon("flask")),
      
      # Menu item untuk analisis tren global agregat
      menuItem(" Analisis Global", tabName = "global_analysis", icon = icon("globe")),
      
      # Menu item untuk visualisasi peta interaktif
      menuItem("️ Peta Interaktif", tabName = "map", icon = icon("map")),
      
      # Menu item untuk melihat data mentah
      menuItem(" Data", tabName = "data", icon = icon("table")),
      
      # Menu item untuk analisis statistik inferensia
      menuItem(" Analisis Inferensia", tabName = "inference", icon = icon("chart-bar")),
      
      # Menu item user guide
      menuItem(" User Guide", tabName = "guide", icon = icon("user"))
    )
  ),
  
  # ------------------------------------------------------------------------------
  # Body Dashboard
  # ------------------------------------------------------------------------------
  dashboardBody(
    
    # Custom CSS styling untuk tampilan yang lebih menarik
    tags$head(
      tags$style(HTML("
        /* Background gradient untuk seluruh konten */
        .content-wrapper, .right-side {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
        }
        
        /* Styling untuk box/container */
        .box {
          border-radius: 15px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.1);
          border: none;
        }
        
        /* Styling untuk header box */
        .box-header {
          border-radius: 15px 15px 0 0;
        }
        
        /* Styling untuk navbar utama */
        .main-header .navbar {
          background: linear-gradient(45deg, #667eea, #764ba2) !important;
        }
        
        /* Styling untuk logo */
        .main-header .logo {
          background: linear-gradient(45deg, #667eea, #764ba2) !important;
        }
        
        /* Styling untuk sidebar */
        .skin-blue .main-sidebar {
          background-color: #2c3e50 !important;
        }
        
        /* Styling khusus untuk box uji normalitas */
        .norm-test-box {
          border-left: 5px solid #17a2b8 !important;
        }
        
        /* Styling khusus untuk box plot normalitas */
        .norm-plot-box {
          border-left: 5px solid #28a745 !important;
        }
      "))
    ),
    
    # ------------------------------------------------------------------------------
    # Konten untuk setiap menu
    # ------------------------------------------------------------------------------
    tabItems(
      
      # ============================================================================
      # TAB OVERVIEW
      # ============================================================================
      tabItem(tabName = "overview",
              
              # Header dengan tujuan penelitian
              fluidRow(
                box(
                  title = "Tujuan Penelitian", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  background = "light-blue",
                  
                  # Judul utama penelitian
                  h3("ANALISIS DAMPAK PERTUMBUHAN PENDUDUK DAN KARBONDIOKSIDA TERHADAP SUHU PERMUKAAN BUMI DAN KETINGGIAN PERMUKAAN AIR LAUT"),
                  
                  # Periode analisis
                  h4("PERIODE ANALISIS: 1993 - 2023 (31 TAHUN)", style = "color: #ffffff;"),
                  hr()
                )
              ),
              
              # Section untuk upload file data
              fluidRow(
                box(
                  title = "Upload Data", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Input file untuk data iklim utama
                  fileInput("file_iklim", "Upload Data Iklim (+ Populasi)", 
                            accept = c(".csv")),
                  
                  # Input file untuk data negara (koordinat geografis)
                  fileInput("file_negara", "Upload Data Negara", 
                            accept = c(".csv")),
                  
                  # Input file untuk data ketinggian air laut
                  fileInput("file_sea_level", "Upload Data Sea Level", 
                            accept = c(".csv")),
                  
                  # Tombol untuk memproses data yang diupload
                  actionButton("load_data", "Load Data", 
                               icon = icon("upload"),
                               class = "btn-primary")
                )
              ),
              
              # Value boxes untuk menampilkan statistik dasar
              fluidRow(
                valueBoxOutput("total_countries"),    # Jumlah negara dalam dataset
                valueBoxOutput("year_range"),         # Rentang tahun data
                valueBoxOutput("total_records")       # Total jumlah record data
              ),
              
              # Section untuk statistik deskriptif dan matriks korelasi
              fluidRow(
                # Box untuk statistik deskriptif per tahun
                box(
                  title = "Statistik Deskriptif", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # UI dinamis untuk pemilihan tahun
                  uiOutput("year_selector"),
                  
                  # Tabel statistik deskriptif
                  DT::dataTableOutput("desc_stats")
                ),
                
                # Box untuk matriks korelasi
                box(
                  title = "🔗 Matriks Korelasi Lengkap", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Plot matriks korelasi
                  plotOutput("correlation_matrix")
                )
              )
      ),
      
      # ============================================================================
      # TAB ANALISIS KORELASI
      # ============================================================================
      tabItem(tabName = "correlation",
              fluidRow(
                # Panel kontrol untuk pengaturan analisis korelasi
                box(
                  title = "Pengaturan Analisis Korelasi", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 3,
                  
                  # Pemilihan variabel independen (X)
                  selectInput("var_x", "Variabel X (Independen):", 
                              choices = c("Populasi" = "population", 
                                          "CO2 Total" = "co2", 
                                          "CO2 per Kapita" = "co2_per_capita",
                                          "Populasi (ln Standardization)" = "ln_population",
                                          "CO2 Total (ln Standardization)" = "ln_co2",
                                          "CO2 per Kapita (ln Standardization)" = "ln_co2percapita")),
                  
                  # Pemilihan variabel dependen (Y)
                  selectInput("var_y", "Variabel Y (Dependen):", 
                              choices = c("Perubahan Suhu" = "temp_change", 
                                          "Ketinggian Air Laut" = "Sea_level",
                                          "Perubahan Suhu (ln Standardization)" = "ln_temp_change",
                                          "Ketinggian Air Laut (ln Standardization)" = "ln_Sea_level")),
                  
                  # Filter rentang tahun untuk analisis
                  sliderInput("year_filter", "Filter Tahun:", 
                              min = 1993, max = 2023, 
                              value = c(2000, 2023), 
                              step = 1),
                  
                  hr(),
                  
                  # Pemilihan metode korelasi
                  radioButtons("cor_method", "Metode Korelasi:",
                               choices = c("Pearson (parametrik)" = "pearson",
                                           "Spearman (non-parametrik)" = "spearman",
                                           "Kendall (non-parametrik)" = "kendall")),
                  
                  # Tombol untuk menjalankan analisis
                  actionButton("analyze_corr", "Analisis Korelasi", class = "btn-primary")
                ),
                
                # Panel hasil visualisasi scatter plot
                box(
                  title = "Scatter Plot dengan Trendline", 
                  status = "success", 
                  solidHeader = TRUE, 
                  width = 9,
                  
                  # Plot interaktif dengan plotly
                  plotlyOutput("scatter_plot", height = "400px")
                )
              ),
              
              fluidRow(
                # Panel hasil uji korelasi numerik
                box(
                  title = "Hasil Uji Korelasi", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Output hasil uji korelasi
                  verbatimTextOutput("correlation_result")
                ),
                
                # Panel interpretasi hasil korelasi
                box(
                  title = "Interpretasi Korelasi", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Output interpretasi hasil
                  verbatimTextOutput("correlation_interpretation")
                )
              )
      ),
      
      # ============================================================================
      # TAB ANALISIS REGRESI
      # ============================================================================
      tabItem(tabName = "regression",
              fluidRow(
                # Panel kontrol untuk pengaturan regresi
                box(
                  title = " Pengaturan Regresi Lengkap", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 4,
                  
                  # Pemilihan multiple variabel independen
                  checkboxGroupInput("reg_x_multiple", "Variabel Independen (X) - Pilih Satu atau Lebih:", 
                                     choices = c("Populasi" = "population", 
                                                 "CO2 Total" = "co2", 
                                                 "CO2 per Kapita" = "co2_per_capita",
                                                 "Populasi (ln Standardization)" = "ln_population",
                                                 "CO2 Total (ln Standardization)" = "ln_co2",
                                                 "CO2 per Kapita (ln Standardization)" = "ln_co2percapita"),
                                     selected = "population"),
                  
                  # Pemilihan variabel dependen
                  selectInput("reg_y", "Variabel Dependen (Y):", 
                              choices = c("Perubahan Suhu" = "temp_change", 
                                          "Ketinggian Air Laut" = "Sea_level",
                                          "Perubahan Suhu (ln Standardization)" = "ln_temp_change",
                                          "Ketinggian Air Laut (ln Standardization)" = "ln_Sea_level")),
                  
                  # Pemilihan jenis regresi
                  selectInput("reg_type", "Jenis Regresi:", 
                              choices = c("Linear Sederhana" = "simple", 
                                          "Polinomial" = "poly")),
                  
                  hr(),
                  
                  # Preview formula model yang akan dibuat
                  h5("Model yang Akan Dibuat:"),
                  verbatimTextOutput("model_formula"),
                  br(),
                  
                  # Tombol untuk menjalankan analisis regresi
                  actionButton("analyze_reg", "Analisis Regresi", class = "btn-success")
                ),
                
                # Panel visualisasi hasil regresi
                box(
                  title = "Plot Regresi", 
                  status = "success", 
                  solidHeader = TRUE, 
                  width = 8,
                  
                  # Plot regresi interaktif
                  plotlyOutput("regression_plot", height = "400px")
                )
              ),
              
              fluidRow(
                # Panel summary statistik model regresi
                box(
                  title = "Summary Model Regresi", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 8,
                  
                  # Output summary model regresi
                  verbatimTextOutput("regression_summary")
                ),
                
                # Panel metrik performa model
                box(
                  title = "Model Performance", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 4,
                  
                  # Output metrik performa (R-squared, RMSE, dll)
                  verbatimTextOutput("model_performance")
                )
              ),
              
              fluidRow(
                # Panel diagnostik model (residual plots, Q-Q plot, dll)
                box(
                  title = "Diagnostik Model", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Plot diagnostik model regresi
                  plotOutput("diagnostic_plots", height = "500px")
                )
              )
      ),
      
      # ============================================================================
      # TAB UJI HIPOTESIS
      # ============================================================================
      tabItem(tabName = "hypothesis",
              fluidRow(
                # Panel penjelasan hipotesis penelitian
                box(
                  title = "Pengaturan Uji Hipotesis", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  h4("Hipotesis Penelitian:"),
                  
                  # Box dengan styling khusus untuk penjelasan hipotesis
                  div(style = "background: linear-gradient(135deg, #f8f9fa, #e9ecef); padding: 20px; border-radius: 10px; margin: 10px 0; border-left: 5px solid #007bff;",
                      # Hipotesis nol
                      h5("H₀ (Hipotesis Nol):"),
                      p("Tidak ada hubungan signifikan antara variabel X terhadap variabel Y."),
                      p("H₀: ρ = 0 (koefisien korelasi = 0)"),
                      
                      # Hipotesis alternatif
                      h5("H₁ (Hipotesis Alternatif):"),
                      p("Ada hubungan signifikan antara variabel X terhadap variabel Y."),
                      p("H₁: ρ ≠ 0 (koefisien korelasi ≠ 0)")
                  )
                )
              ),
              
              fluidRow(
                # Panel parameter uji hipotesis
                box(
                  title = "Parameter Uji", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 4,
                  
                  # Pemilihan variabel untuk uji hipotesis
                  selectInput("hyp_var1", "Variabel 1 (Independen):", 
                              choices = c("Populasi" = "population", 
                                          "CO2 Total" = "co2", 
                                          "CO2 per Kapita" = "co2_per_capita",
                                          "Populasi (ln Standardization)" = "ln_population",
                                          "CO2 Total (ln Standardization)" = "ln_co2",
                                          "CO2 per Kapita (ln Standardization)" = "ln_co2percapita")),
                  
                  selectInput("hyp_var2", "Variabel 2 (Dependen):", 
                              choices = c("Perubahan Suhu" = "temp_change", 
                                          "Ketinggian Air Laut" = "Sea_level",
                                          "Perubahan Suhu (ln Standardization)" = "ln_temp_change",
                                          "Ketinggian Air Laut (ln Standardization)" = "ln_Sea_level")),
                  
                  # Setting tingkat signifikansi alpha
                  numericInput("alpha", "Tingkat Signifikansi (α):", 
                               value = 0.05, min = 0.01, max = 0.1, step = 0.01),
                  
                  # Filter tahun untuk uji hipotesis
                  sliderInput("hyp_year_filter", "Filter Tahun untuk Uji:", 
                              min = 1993, max = 2023, 
                              value = c(2000, 2023), 
                              step = 1),
                  
                  # Pemilihan metode korelasi untuk uji hipotesis
                  radioButtons("cor_method_hyp", "Metode Korelasi:",
                               choices = c("Pearson (parametrik)" = "pearson",
                                           "Spearman (non-parametrik)" = "spearman",
                                           "Kendall (non-parametrik)" = "kendall")),
                  
                  # Tombol untuk menjalankan uji hipotesis
                  actionButton("test_hypothesis", "Uji Hipotesis", class = "btn-danger")
                ),
                
                # Panel hasil uji hipotesis
                box(
                  title = "Hasil Uji Hipotesis", 
                  status = "danger", 
                  solidHeader = TRUE, 
                  width = 8,
                  
                  # Output hasil uji hipotesis (t-test, p-value, confidence interval)
                  verbatimTextOutput("hypothesis_result")
                )
              ),
              
              fluidRow(
                # Panel kesimpulan uji hipotesis
                box(
                  title = "Kesimpulan Uji Hipotesis", 
                  status = "success", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Output kesimpulan apakah menolak atau menerima H0
                  verbatimTextOutput("hypothesis_conclusion")
                )
              )
      ),
      
      # ============================================================================
      # TAB ANALISIS GLOBAL
      # ============================================================================
      tabItem(tabName = "global_analysis",
              fluidRow(
                # Header penjelasan analisis global
                box(
                  title = "Analisis Tren Global + Sea Level", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  p("Analisis ini menggunakan data agregat global per tahun, termasuk sea level.")
                )
              ),
              
              fluidRow(
                # Plot tren CO2 vs Sea Level global
                box(
                  title = "Tren Global CO2 vs Sea Level", 
                  status = "success", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Plot interaktif tren CO2 dan sea level
                  plotlyOutput("global_co2_sealevel", height = "400px")
                ),
                
                # Plot tren suhu vs Sea Level global
                box(
                  title = "Tren Global Suhu vs Sea Level", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Plot interaktif tren suhu dan sea level
                  plotlyOutput("global_temp_sealevel", height = "400px")
                )
              ),
              
              fluidRow(
                # Panel korelasi variabel global
                box(
                  title = "Korelasi Global (dengan Sea Level)", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Output matriks korelasi data global
                  verbatimTextOutput("global_correlation")
                ),
                
                # Panel statistik deskriptif global
                box(
                  title = "Statistik Global", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 6,
                  
                  # Output statistik deskriptif data agregat global
                  verbatimTextOutput("global_stats")
                )
              )
      ),
      
      # ============================================================================
      # TAB PETA INTERAKTIF
      # ============================================================================
      tabItem(tabName = "map",
              fluidRow(
                # Panel kontrol untuk peta interaktif
                box(
                  title = "Kontrol Peta Interaktif Lengkap", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 3,
                  
                  # Pemilihan variabel untuk divisualisasikan pada peta
                  selectInput("map_variable", "Pilih Variabel untuk Visualisasi:",
                              choices = list(
                                "Emisi CO2 (Mt)" = "co2",
                                "CO2 per Kapita (ton)" = "co2_per_capita",
                                "Populasi" = "population", 
                                "Perubahan Suhu (°C)" = "temp_change",
                                "Emisi CO2 (log10 Standardization)" = "Plog_co2",
                                "CO2 per Kapita (log10 Standardization)" = "PER001",
                                "Populasi (log10 Standardization)" = "Plog_pop"
                              )),
                  
                  # Slider untuk pemilihan tahun dengan animasi
                  sliderInput("map_year", "Tahun:", 
                              min = 1993, max = 2023, 
                              value = 2020, 
                              step = 1,
                              animate = animationOptions(interval = 1500, loop = TRUE)),
                  
                  hr(),
                  
                  # Dropdown untuk zoom ke negara tertentu
                  selectInput("selected_country", " Pilih Negara untuk Zoom:",
                              choices = NULL,      # Akan diisi secara dinamis
                              selected = NULL),
                  
                  hr(),
                  
                  # Pemilihan gaya/style peta dasar
                  selectInput("map_style", "Gaya Peta:",
                              choices = list(
                                "OpenStreetMap" = "osm",
                                "Satellite" = "satellite",
                                "Terrain" = "terrain"
                              )),
                  
                  # Pemilihan skema warna untuk choropleth
                  selectInput("color_scheme", "Skema Warna:",
                              choices = list(
                                "Heat (Merah-Kuning)" = "heat",
                                "Ocean (Biru)" = "ocean",
                                "Viridis" = "viridis",
                                "Green-Blue" = "green"
                              )),
                  
                  hr(),
                  
                  # Panel statistik untuk tahun yang dipilih
                  h5(" Statistik Tahun Terpilih:"),
                  verbatimTextOutput("map_stats"),
                  hr()
                ),
                
                # Panel peta interaktif utama
                box(
                  title = "Peta Interaktif Dampak Iklim Global (1993-2023)", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 9,
                  
                  # Container dengan border radius untuk peta
                  div(style = "border-radius: 10px; overflow: hidden;",
                      leafletOutput("climate_map", height = "650px")
                  )
                )
              )
      ),
      
      # ============================================================================
      # TAB DATA
      # ============================================================================
      tabItem(tabName = "data",
              fluidRow(
                # Tabel data lengkap dengan sea level
                box(
                  title = "Data Lengkap dengan Sea Level", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Tabel interaktif dengan fitur sorting, filtering, export
                  DT::dataTableOutput("data_table")
                )
              ),
              
              fluidRow(
                # Tabel data global agregat
                box(
                  title = "Data Global Agregat", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Tabel data yang sudah diagregasi per tahun
                  DT::dataTableOutput("global_data_table")
                )
              )
      ),
      
      # ============================================================================
      # TAB ANALISIS INFERENSIA
      # ============================================================================
      tabItem(tabName = "inference",
              fluidRow(
                # Header penjelasan uji kenormalan
                box(
                  title = "Uji Kenormalan Data", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  h4("Pilih variabel untuk menguji distribusi normalitas data")
                )
              ),
              
              fluidRow(
                # Panel pengaturan uji kenormalan
                box(
                  title = "Pengaturan Uji", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 4,
                  
                  # Pemilihan variabel untuk uji normalitas
                  selectInput("norm_var", "Pilih Variabel:", 
                              choices = c("Populasi" = "population", 
                                          "CO2 Total" = "co2", 
                                          "CO2 per Kapita" = "co2_per_capita",
                                          "Perubahan Suhu" = "temp_change",
                                          "Ketinggian Air Laut" = "Sea_level",
                                          "Populasi (ln Standardization)" = "ln_population",
                                          "CO2 Total (ln Standardization)" = "ln_co2",
                                          "CO2 per Kapita (ln Standardization)" = "ln_co2percapita",
                                          "Perubahan Suhu (ln Standardization)" = "ln_temp_change",
                                          "Ketinggian Air Laut (ln Standardization)" = "ln_Sea_level")),
                  
                  # Filter rentang tahun untuk uji
                  sliderInput("norm_year_range", "Rentang Tahun:", 
                              min = 1993, max = 2023, 
                              value = c(2000, 2020), 
                              step = 1),
                  
                  # Pemilihan jenis uji kenormalan
                  radioButtons("norm_test", "Pilih Uji Kenormalan:",
                               choices = c("Shapiro-Wilk" = "shapiro",
                                           "Kolmogorov-Smirnov" = "ks")),
                  
                  # Tombol untuk menjalankan uji
                  actionButton("run_norm_test", "Jalankan Uji Kenormalan", class = "btn-info"),
                  
                  hr(),
                  
                  # Informasi interpretasi hasil uji
                  div(style = "background: #f8f9fa; padding: 10px; border-radius: 5px;",
                      h5("Daerah Kritis:"),
                      p("- p-value > 0.05: Data terdistribusi normal", style = "font-size: 12px;"),
                      p("- p-value ≤ 0.05: Data tidak normal", style = "font-size: 12px;")
                  )
                ),
                
                # Panel hasil uji kenormalan
                box(
                  title = "Hasil Uji Kenormalan", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 8,
                  
                  # Output hasil uji statistik
                  verbatimTextOutput("norm_test_result"),
                  hr(),
                  
                  # Plot Q-Q untuk visualisasi normalitas
                  plotOutput("norm_plot", height = "300px")
                )
              ),
              
              fluidRow(
                # Panel visualisasi distribusi data
                box(
                  title = "Visualisasi Distribusi", 
                  status = "success", 
                  solidHeader = TRUE, 
                  width = 12,
                  
                  # Histogram dan density plot interaktif
                  plotlyOutput("dist_plot", height = "400px")
                )
              )
      ),
      
      # ============================================================================
      # TAB USER GUIDE
      # ============================================================================
      tabItem(tabName = "guide",
              fluidRow(
                
                # 1. Overview
                box(
                  title = "Selamat Datang di Dashboard Analisis Iklim", status = "primary", solidHeader = TRUE, width = 12,
                  div(
                    h4("Tentang Dashboard Ini", style = "color: #2c3e50;"),
                    p("Dashboard ini dirancang untuk membantu Anda menganalisis hubungan kompleks antara aktivitas manusia dan perubahan iklim global. Dengan data komprehensif dari periode 1993-2023, Anda dapat mengeksplorasi dampak pertumbuhan penduduk dan emisi CO₂ terhadap perubahan suhu global dan kenaikan permukaan laut."),
                    
                    h4("Tujuan Penelitian", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ul(
                      tags$li(strong("Mengidentifikasi korelasi"), " antara pertumbuhan penduduk dan emisi CO₂ terhadap Suhu Permukaan Bumi dan Ketinggian Permukaan Air Laut "),
                      tags$li(strong("Menganalisis dampak"), " terhadap variabel iklim (suhu dan permukaan laut)"),
                      tags$li(strong("Membangun model prediktif"), " untuk memahami tren masa depan"),
                      tags$li(strong("Memberikan wawasan"), " berbasis data untuk kebijakan lingkungan")
                    ),
                    
                    div(
                      style = "background-color: #e8f4fd; padding: 15px; border-radius: 8px; margin-top: 20px;",
                      h4("Langkah Pertama - Persiapan Data", style = "color: #1f4e79; margin-top: 0;"),
                      tags$ol(
                        tags$li(strong("Persiapkan tiga file data utama:")),
                        div(style = "margin-left: 20px; margin-top: 10px;",
                            tags$ul(
                              tags$li(code("data_iklim_gabungan.csv"), " - Data iklim komprehensif"),
                              tags$li(code("negara.csv"), " - Informasi negara dan koordinat"),
                              tags$li(code("sea_level.csv"), " - Data kenaikan permukaan laut")
                            )
                        ),
                        tags$li(strong("Unggah file"), " menggunakan tombol upload yang tersedia"),
                        tags$li(strong("Klik 'Load Data'"), " untuk memproses dan menggabungkan data"),
                        tags$li(strong("Verifikasi data"), " melalui statistik deskriptif yang muncul")
                      ),
                      div(
                        style = "background-color: #d4edda; padding: 10px; border-radius: 5px; margin-top: 15px; border-left: 4px solid #28a745;",
                        " ", strong("Tip:"), " Pastikan semua file memiliki format yang benar dan tidak ada data yang hilang sebelum melanjutkan analisis."
                      )
                    )
                  )
                ),
                
                # 2. Analisis Korelasi
                box(
                  title = "Analisis Korelasi - Mengukur Kekuatan Hubungan", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Apa itu Analisis Korelasi?", style = "color: #2c3e50;"),
                    p("Analisis korelasi mengukur seberapa kuat dan ke arah mana dua variabel saling berhubungan. Nilai korelasi berkisar dari -1 hingga +1, di mana nilai mendekati 1 menunjukkan hubungan positif yang kuat, dan nilai mendekati -1 menunjukkan hubungan negatif yang kuat."),
                    
                    h4("Panduan Langkah demi Langkah", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ol(
                      tags$li(strong("Pilih Variabel Independen (X):"), " Variabel yang dianggap memengaruhi (contoh: Populasi, CO₂)"),
                      tags$li(strong("Pilih Variabel Dependen (Y):"), " Variabel yang dipengaruhi (contoh: Perubahan Suhu, Sea Level)"),
                      tags$li(strong("Tentukan Metode Korelasi:")),
                      div(style = "margin-left: 20px; margin-top: 10px;",
                          tags$ul(
                            tags$li(strong("Pearson:"), " Untuk data yang terdistribusi normal"),
                            tags$li(strong("Spearman:"), " Untuk data non-parametrik atau hubungan monoton"),
                            tags$li(strong("Kendall:"), " Alternatif robust untuk data dengan outlier")
                          )
                      ),
                      tags$li(strong("Atur Rentang Tahun:"), " Fokuskan analisis pada periode tertentu"),
                      tags$li(strong("Klik 'Analisis Korelasi' (!!Pastikan sudah diklik dahulu)"), " dan tunggu hasil pemrosesan")
                    ),
                    
                    h4("Interpretasi Hasil", style = "color: #2c3e50; margin-top: 20px;"),
                    div(style = "background-color: #f8f9fa; padding: 15px; border-radius: 8px;",
                        tags$ul(
                          tags$li(strong("Scatter Plot:"), " Visualisasi hubungan antara kedua variabel"),
                          tags$li(strong("Nilai Korelasi (r):"), " Kekuatan dan arah hubungan"),
                          tags$li(strong("P-value:"), " Signifikansi statistik (< 0.05 = signifikan)"),
                          tags$li(strong("Interpretasi Otomatis:"), " Penjelasan dalam bahasa yang mudah dipahami")
                        )
                    )
                  )
                ),
                
                # 3. Analisis Regresi
                box(
                  title = "Analisis Regresi - Membangun Model Prediktif (BETA)", status = "warning", solidHeader = TRUE, width = 12,
                  div(
                    div(
                      style = "background-color: #fff3cd; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107; margin-bottom: 20px;",
                      h5("Status Beta - Fitur dalam Pengembangan", style = "color: #856404; margin-top: 0;"),
                      p(style = "margin-bottom: 10px; color: #856404;", "Tab ini masih dalam tahap beta karena belum mendukung metode regresi robust yang penting untuk data iklim yang sering mengandung outlier dan noise. Keterbatasan saat ini:"),
                      tags$ul(style = "color: #856404; margin-bottom: 10px;",
                              tags$li("Belum tersedia regresi robust (Huber, Tukey's biweight, dll.)"),
                              tags$li("Belum ada penanganan otomatis untuk outlier dan leverage points"),
                              tags$li("Belum mendukung weighted regression untuk data dengan variabilitas berbeda"),
                              tags$li("Diagnostik residual masih terbatas untuk deteksi heteroskedastisitas")
                      ),
                      p(style = "color: #856404; margin-bottom: 0;", strong("Rekomendasi: "), "Gunakan hasil dengan hati-hati dan selalu periksa diagnostik model. Untuk analisis final, pertimbangkan validasi dengan tools statistik eksternal.")
                    ),
                    
                    h4("Mengapa Regresi Penting?", style = "color: #2c3e50;"),
                    p("Analisis regresi memungkinkan kita tidak hanya melihat hubungan antar variabel, tetapi juga membangun model untuk memprediksi nilai variabel target berdasarkan variabel prediktor. Ini sangat berguna untuk proyeksi perubahan iklim masa depan, meski dengan keterbatasan metode yang tersedia saat ini."),
                    
                    h4("Cara Menggunakan Fitur Ini", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ol(
                      tags$li(strong("Pilih Variabel Prediktor (X):"), " Dapat memilih satu atau lebih variabel independen"),
                      tags$li(strong("Pilih Variabel Target (Y):"), " Variabel yang ingin diprediksi"),
                      tags$li(strong("Tentukan Jenis Model:")),
                      div(style = "margin-left: 20px; margin-top: 10px;",
                          tags$ul(
                            tags$li(strong("Linear Sederhana:"), " Untuk hubungan linear langsung"),
                            tags$li(strong("Polinomial:"), " Untuk hubungan yang lebih kompleks/melengkung")
                          )
                      ),
                      tags$li(strong("Jalankan Analisis (!!Pastikan sudah diklik dahulu)"), " dan evaluasi hasil model")
                    ),
                    
                    h4("Memahami Output Model", style = "color: #2c3e50; margin-top: 20px;"),
                    div(style = "background-color: #e8f4fd; padding: 15px; border-radius: 8px; border-left: 4px solid #2196f3;",
                        tags$ul(
                          tags$li(strong("Plot Regresi:"), " Garis prediksi pada data aktual dengan confidence interval"),
                          tags$li(strong("R² (R-squared):"), " Persentase variasi yang dijelaskan model (>0.7 baik, >0.5 cukup)"),
                          tags$li(strong("RMSE/MAE:"), " Ukuran kesalahan prediksi - bandingkan dengan standar deviasi variabel target"),
                          tags$li(strong("Plot Diagnostik:"), " Residual plots untuk deteksi pola, outlier, dan pelanggaran asumsi"),
                          tags$li(strong("P-values:"), " Signifikansi koefisien regresi (< 0.05 signifikan)")
                        )
                    ),
                    
                    div(style = "background-color: #ffebee; padding: 15px; border-radius: 8px; border-left: 4px solid #f44336; margin-top: 15px;",
                        h5("Peringatan Interpretasi", style = "color: #c62828; margin-top: 0;"),
                        p(style = "color: #c62828; margin-bottom: 10px;", "Karena keterbatasan metode robust, berhati-hatilah dengan:"),
                        tags$ul(style = "color: #c62828; margin-bottom: 10px;",
                                tags$li("Outlier yang dapat mendistorsi garis regresi secara signifikan"),
                                tags$li("Heteroskedastisitas (variabilitas residual tidak konstan)"),
                                tags$li("Non-linearitas yang tidak tertangkap model polinomial sederhana"),
                                tags$li("Multikolinearitas pada regresi dengan multiple predictors")
                        ),
                        p(style = "color: #c62828; margin-bottom: 0;", strong("Solusi sementara: "), "Lakukan analisis residual manual dan pertimbangkan transformasi data jika diperlukan.")
                    )
                  )
                ),
                
                # 4. Uji Hipotesis
                box(
                  title = "Uji Hipotesis - Membuktikan Signifikansi Statistik", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Konsep Uji Hipotesis", style = "color: #2c3e50;"),
                    p("Uji hipotesis adalah metode statistik untuk memutuskan apakah suatu klaim tentang populasi didukung oleh bukti sampel yang ada. Dalam konteks ini, kita menguji apakah hubungan antar variabel benar-benar signifikan atau hanya kebetulan."),
                    
                    div(style = "background-color: #e3f2fd; padding: 15px; border-radius: 8px; margin: 15px 0;",
                        h5("Hipotesis yang Diuji:", style = "color: #1565c0; margin-top: 0;"),
                        tags$ul(
                          tags$li(strong("H₀ (Hipotesis Nol):"), " Tidak ada hubungan signifikan antara variabel X dan Y"),
                          tags$li(strong("H₁ (Hipotesis Alternatif):"), " Ada hubungan signifikan antara variabel X dan Y")
                        )
                    ),
                    
                    h4("Prosedur Pengujian", style = "color: #2c3e50;"),
                    tags$ol(
                      tags$li(strong("Pilih dua variabel"), " yang ingin diuji hubungannya"),
                      tags$li(strong("Tentukan periode analisis"), " dengan memilih rentang tahun"),
                      tags$li(strong("Atur tingkat signifikansi (α):")),
                      div(style = "margin-left: 20px; margin-top: 10px;",
                          tags$ul(
                            tags$li("0.05 (5%) - Standar untuk kebanyakan penelitian"),
                            tags$li("0.01 (1%) - Untuk kriteria yang lebih ketat"),
                            tags$li("0.10 (10%) - Untuk penelitian eksploratori")
                          )
                      ),
                      tags$li(strong("Jalankan uji (!!Pastikan sudah diklik dahulu)"), " dan interpretasikan hasil p-value")
                    ),
                    
                    div(style = "background-color: #f3e5f5; padding: 15px; border-radius: 8px; border-left: 4px solid #9c27b0;",
                        strong("Interpretasi Hasil:"), br(),
                        "• Jika p-value < α: Tolak H₀ (hubungan signifikan)", br(),
                        "• Jika p-value ≥ α: Gagal tolak H₀ (hubungan tidak signifikan)"
                    )
                  )
                ),
                
                # 5. Analisis Global
                box(
                  title = "Analisis Global - Tren Perubahan Iklim Dunia", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Perspektif Global", style = "color: #2c3e50;"),
                    p("Tab ini menyajikan gambaran besar perubahan iklim global dengan mengagregasi data dari seluruh negara. Analisis ini penting untuk memahami tren makro yang mungkin tidak terlihat dari analisis per negara."),
                    
                    h4("Fitur Visualisasi Global", style = "color: #2c3e50; margin-top: 20px;"),
                    div(style = "display: flex; flex-wrap: wrap; gap: 15px;",
                        div(style = "flex: 1; min-width: 250px; background-color: #e8f5e8; padding: 15px; border-radius: 8px;",
                            strong("Tren Temporal"), br(),
                            "Grafik garis menunjukkan perubahan CO₂, suhu, dan permukaan laut dari tahun ke tahun"
                        ),
                        div(style = "flex: 1; min-width: 250px; background-color: #e8f4fd; padding: 15px; border-radius: 8px;",
                            strong("Korelasi Antar Variabel"), br(),
                            "Matrix korelasi untuk melihat hubungan simultan semua variabel utama"
                        ),
                        div(style = "flex: 1; min-width: 250px; background-color: #fff8e1; padding: 15px; border-radius: 8px;",
                            strong("Statistik Ringkasan"), br(),
                            "Tabel agregat dengan mean, median, min, max per tahun untuk semua variabel"
                        )
                    ),
                    
                    h4("Cara Menggunakan", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ul(
                      tags$li("Amati tren jangka panjang untuk mengidentifikasi pola perubahan global"),
                      tags$li("Bandingkan tingkat perubahan antar dekade untuk melihat akselerasi"),
                      tags$li("Gunakan korelasi global sebagai baseline untuk analisis regional"),
                      tags$li("Export data ringkasan untuk analisis lanjutan di tools eksternal")
                    )
                  )
                ),
                
                # 6. Peta Interaktif
                box(
                  title = " Peta Interaktif - Visualisasi Spasial Data Iklim", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Mengapa Visualisasi Spasial?", style = "color: #2c3e50;"),
                    p("Peta interaktif memungkinkan Anda melihat distribusi geografis variabel iklim, mengidentifikasi hotspot perubahan, dan memahami pola regional yang mungkin tidak terlihat dalam analisis statistik konvensional."),
                    
                    h4("Panduan Interaksi", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ol(
                      tags$li(strong("Pilih Variabel:"), " Tentukan data yang ingin divisualisasikan (CO₂, Suhu, Sea Level, dll.)"),
                      tags$li(strong("Navigasi Temporal:"), " Gunakan slider tahun untuk melihat perubahan dari waktu ke waktu"),
                      tags$li(strong("Filter Regional:"), " Pilih negara atau wilayah tertentu untuk analisis fokus"),
                      tags$li(strong("Kustomisasi Visual:")),
                      div(style = "margin-left: 20px; margin-top: 10px;",
                          tags$ul(
                            tags$li("Pilih skema warna yang sesuai dengan jenis data"),
                            tags$li("Atur transparansi untuk overlay data"),
                            tags$li("Sesuaikan ukuran marker berdasarkan nilai")
                          )
                      ),
                      tags$li(strong("Interaksi:"), " Hover mouse pada titik untuk detail, klik untuk informasi lengkap")
                    ),
                    
                    div(style = "background-color: #f0f8ff; padding: 15px; border-radius: 8px; border-left: 4px solid #4fc3f7;",
                        h5("Tips Penggunaan Optimal:", style = "color: #0277bd; margin-top: 0;"),
                        tags$ul(style = "margin-bottom: 0;",
                                tags$li("Gunakan animasi temporal untuk melihat tren perubahan"),
                                tags$li("Bandingkan pola antar benua dengan filter regional"),
                                tags$li("Perhatikan outlier geografis yang mungkin memiliki cerita khusus"),
                                tags$li("Screenshot peta untuk dokumentasi dan presentasi")
                        )
                    )
                  )
                ),
                
                # 7. Data
                box(
                  title = "Eksplorasi Data - Tabel Interaktif Lengkap", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Pusat Data Komprehensif", style = "color: #2c3e50;"),
                    p("Tabel data interaktif ini adalah jantung dari dashboard, menyediakan akses langsung ke semua data yang digunakan dalam analisis. Fitur-fitur canggih memungkinkan eksplorasi data yang mendalam sebelum analisis statistik."),
                    
                    h4("Fitur Tabel Interaktif", style = "color: #2c3e50; margin-top: 20px;"),
                    div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px;",
                        div(style = "background-color: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #28a745;",
                            strong("Pencarian & Filter"), br(),
                            "Cari data spesifik dengan search box atau filter berdasarkan kolom tertentu"
                        ),
                        div(style = "background-color: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #007bff;",
                            strong("Sorting & Paging"), br(),
                            "Urutkan data ascending/descending, navigasi dengan pagination yang fleksibel"
                        ),
                        div(style = "background-color: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107;",
                            strong("Export Multi-format"), br(),
                            "Unduh data dalam format CSV, Excel, atau PDF sesuai kebutuhan analisis"
                        )
                    ),
                    
                    h4("Strategi Eksplorasi Data", style = "color: #2c3e50; margin-top: 20px;"),
                    tags$ol(
                      tags$li(strong("Data Quality Check:"), " Periksa missing values, outlier, dan konsistensi data"),
                      tags$li(strong("Pattern Recognition:"), " Identifikasi pola temporal dan regional"),
                      tags$li(strong("Hypothesis Generation:"), " Temukan insight awal untuk analisis lanjutan"),
                      tags$li(strong("Validation:"), " Verifikasi hasil analisis dengan data mentah")
                    )
                  )
                ),
                
                # 8. Analisis Inferensia
                box(
                  title = "Uji Kenormalan - Validasi Asumsi Statistik", status = "info", solidHeader = TRUE, width = 12,
                  div(
                    h4("Mengapa Uji Kenormalan Penting?", style = "color: #2c3e50;"),
                    p("Banyak uji statistik parametrik (seperti korelasi Pearson dan regresi linear) mengasumsikan bahwa data terdistribusi normal. Uji kenormalan membantu memvalidasi asumsi ini dan menentukan metode analisis yang tepat."),
                    
                    div(style = "background-color: #fff3cd; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107; margin: 15px 0;",
                        strong("Penting:"), " Jika data tidak normal, gunakan metode non-parametrik seperti korelasi Spearman atau uji Mann-Whitney."
                    ),
                    
                    h4("Prosedur Pengujian", style = "color: #2c3e50;"),
                    tags$ol(
                      tags$li(strong("Pilih Variabel:"), " Tentukan variabel yang akan diuji normalitasnya"),
                      tags$li(strong("Tentukan Periode:"), " Fokuskan pada rentang tahun yang relevan"),
                      tags$li(strong("Pilih Metode Uji:")),
                      div(style = "margin-left: 20px; margin-top: 10px;",
                          div(style = "background-color: #e8f5e8; padding: 10px; border-radius: 5px; margin-bottom: 10px;",
                              strong("Shapiro-Wilk Test"), br(),
                              "• Ideal untuk sampel kecil hingga sedang (n < 5000)", br(),
                              "• Lebih sensitif terhadap penyimpangan dari normalitas", br(),
                              "• Rekomendasi untuk data negara individual"
                          ),
                          div(style = "background-color: #e3f2fd; padding: 10px; border-radius: 5px;",
                              strong("Kolmogorov-Smirnov Test"), br(),
                              "• Cocok untuk sampel besar (n > 50)", br(),
                              "• Kurang sensitif, baik untuk data dengan noise", br(),
                              "• Rekomendasi untuk data agregat global"
                          )
                      ),
                      tags$li(strong("Interpretasi Hasil:"), " Analisis p-value dan visualisasi distribusi")
                    ),
                    
                    h4("Memahami Output", style = "color: #2c3e50; margin-top: 20px;"),
                    div(style = "background-color: #f3e5f5; padding: 15px; border-radius: 8px;",
                        tags$ul(
                          tags$li(strong("P-value:"), " Probabilitas mendapatkan hasil yang diamati jika data benar-benar normal"),
                          tags$li(strong("Histogram + Kurva Normal:"), " Perbandingan visual distribusi data dengan kurva normal teoretis"),
                          tags$li(strong("Q-Q Plot:"), " Grafik quantile-quantile untuk mendeteksi penyimpangan spesifik"),
                          tags$li(strong("Kesimpulan Otomatis:"), " Interpretasi statistik dalam bahasa yang mudah dipahami")
                        )
                    ),
                    
                    div(style = "background-color: #e8f4fd; padding: 15px; border-radius: 8px; border-left: 4px solid #2196f3; margin-top: 15px;",
                        strong("Rekomendasi Lanjutan:"), br(),
                        "Jika data tidak normal, pertimbangkan transformasi data (log, square root) atau gunakan metode non-parametrik untuk analisis selanjutnya."
                    )
                  )
                )
              )
              
      )
    )
  )
)

# ===============================================================================
# BAGIAN 3: DEFINISI SERVER FUNCTION DAN INISIALISASI REACTIVE VALUES
# ===============================================================================
server <- function(input, output, session) {
  
  # -----------------------------------------------------------------------
  # 1. Inisiasi Nilai
  # -----------------------------------------------------------------------
  # Reactive Values menyimpan state aplikasi yang dapat berubah dan memicu reaktivitas ketika dimodifikasi. Struktur data ini menjadi "database" dalam memori untuk seluruh aplikasi
  
  rv <- reactiveValues(
    # Dataset utama iklim yang berisi data per negara dan tahun
    # Struktur: country, year, temp_change, co2, population, co2_per_capita
    data_iklim = NULL,
    
    # Dataset informasi negara (metadata geografis/regional)
    # Digunakan untuk join dengan data iklim jika diperlukan analisis regional
    data_negara = NULL,
    
    # Dataset tinggi permukaan laut global per tahun
    # Struktur: Year, Sea_level (dalam mm)
    data_sea_level = NULL,
    
    # Flag boolean untuk mengetahui status loading data
    # Digunakan untuk kontrol flow dan validasi di seluruh aplikasi
    data_loaded = FALSE,
    
    # Dataset agregat global per tahun untuk analisis tren makro
    # Berisi ringkasan statistik global: total CO2, rata-rata temp, dll
    data_global_yearly = NULL,
    
    # Dataset gabungan antara data iklim dengan sea level
    # Dataset utama untuk analisis korelasi dan regresi antar variabel
    data_with_sealevel = NULL
  )
  
  # -----------------------------------------------------------------------
  # 2. Upload dan Proses data
  # -----------------------------------------------------------------------
  # Bagian ini menangani proses loading, validasi, dan preprocessing data
  # dari file CSV yang diupload oleh user melalui interface
  
  observeEvent(input$load_data, {
    # Memastikan semua file yang diperlukan sudah dipilih sebelum memproses
    # req() akan menghentikan eksekusi jika ada input yang NULL/missing
    req(input$file_iklim, input$file_negara, input$file_sea_level)
    
    # TryCatch untuk error handling yang robust dan user-friendly
    tryCatch({
      
      # -----------------------------------------------------------------------
      # 2.1 Membaca File
      # -----------------------------------------------------------------------
      # Membaca ketiga file CSV yang diupload dengan konfigurasi optimal
      
      # File iklim: data utama dengan emisi CO2, populasi, perubahan suhu per negara
      rv$data_iklim <- read_csv(input$file_iklim$datapath, show_col_types = FALSE)
      
      # File negara: metadata geografis untuk referensi dan kategorisasi
      rv$data_negara <- read_csv(input$file_negara$datapath, show_col_types = FALSE)
      
      # File sea level: data global tinggi permukaan laut per tahun
      rv$data_sea_level <- read_csv(input$file_sea_level$datapath, show_col_types = FALSE)
      
      # -----------------------------------------------------------------------
      # 2.2 Konversi tipe data
      # -----------------------------------------------------------------------
      # Memastikan semua kolom numerik dikonversi dengan benar untuk menghindari
      # error dalam perhitungan statistik dan visualisasi
      
      # Konversi kolom-kolom kunci dalam dataset iklim
      rv$data_iklim$temp_change <- as.numeric(rv$data_iklim$temp_change)
      rv$data_iklim$co2 <- as.numeric(rv$data_iklim$co2)
      rv$data_iklim$population <- as.numeric(rv$data_iklim$population)
      rv$data_iklim$year <- as.numeric(rv$data_iklim$year)
      rv$data_iklim$Plog_pop <- as.numeric(rv$data_iklim$Plog_pop)
      rv$data_iklim$Plog_co2 <- as.numeric(rv$data_iklim$Plog_co2)
      rv$data_iklim$PER001 <- as.numeric(rv$data_iklim$PER001)
      
      rv$data_iklim$ln_population <- as.numeric(rv$data_iklim$ln_population)
      rv$data_iklim$ln_co2 <- as.numeric(rv$data_iklim$ln_co2)
      rv$data_iklim$ln_temp_change <- as.numeric(rv$data_iklim$ln_temp_change)
      rv$data_iklim$ln_co2percapita <- as.numeric(rv$data_iklim$ln_co2percapita)
      
      # Konversi sea level data ke numerik
      rv$data_sea_level$Sea_level <- as.numeric(rv$data_sea_level$Sea_level)
      rv$data_sea_level$ln_Sea_level <- as.numeric(rv$data_sea_level$ln_Sea_level)
      
      # -----------------------------------------------------------------------
      # 2.3 Variabel turunan
      # -----------------------------------------------------------------------
      # Membuat variabel turunan untuk analisis yang lebih mendalam
      
      # Menghitung CO2 per kapita sebagai indikator intensitas emisi per penduduk
      # Formula: total CO2 emissions / total population
      rv$data_iklim$co2_per_capita <- as.numeric(rv$data_iklim$co2/rv$data_iklim$population)
      
      # -----------------------------------------------------------------------
      # 2.4 Batas data
      # -----------------------------------------------------------------------
      # Membatasi analisis pada periode dimana semua data tersedia secara konsisten
      # Periode 1993-2023 dipilih karena ketersediaan data sea level yang reliable
      
      rv$data_iklim <- rv$data_iklim %>% filter(year >= 1993 & year <= 2023)
      rv$data_sea_level <- rv$data_sea_level %>% filter(Year >= 1993 & Year <= 2023)
      
      # -----------------------------------------------------------------------
      # 2.5 Tren Global
      # -----------------------------------------------------------------------
      # Membuat dataset ringkasan global per tahun untuk analisis makro ekonomi
      # dan lingkungan pada skala global
      
      rv$data_global_yearly <- rv$data_iklim %>%
        group_by(year) %>%
        summarise(
          # Total emisi CO2 global per tahun (agregasi dari semua negara)
          total_co2 = sum(co2, na.rm = TRUE),
          
          # Rata-rata perubahan suhu global (mean dari semua negara)
          avg_temp_change = mean(temp_change, na.rm = TRUE),
          
          # Total populasi global per tahun
          total_population = sum(population, na.rm = TRUE),
          
          # Rata-rata CO2 per kapita global
          avg_co2_per_capita = mean(co2_per_capita, na.rm = TRUE),
          
          # Menghindari grouping issues dalam dplyr
          .groups = 'drop'
        ) %>%
        # Menggabungkan dengan data sea level berdasarkan tahun
        # Left join memastikan semua tahun dari data iklim tetap ada
        left_join(rv$data_sea_level, by = c("year" = "Year"))
      
      # -----------------------------------------------------------------------
      # 2.6 Membuat Dataset
      # -----------------------------------------------------------------------
      # Membuat dataset gabungan utama untuk analisis korelasi dan regresi
      # Dataset ini menggabungkan data per negara dengan data sea level global
      
      rv$data_with_sealevel <- rv$data_iklim %>%
        left_join(rv$data_sea_level, by = c("year" = "Year"))
      
      # Set flag bahwa data telah berhasil dimuat
      rv$data_loaded <- TRUE
      
      # Notifikasi sukses untuk user feedback
      showNotification("Data berhasil dimuat!", type = "message")
      
    }, error = function(e) {
      # Error handling dengan user feedback yang informatif
      showNotification(paste("Error:", e$message), type = "error")
    })
  })
  
  # -----------------------------------------------------------------------
  # 3. User Interface
  # -----------------------------------------------------------------------
  # Bagian ini menghasilkan komponen UI yang dinamis berdasarkan data yang dimuat
  
  # -----------------------------------------------------------------------
  # 3.1 Tahun
  # -----------------------------------------------------------------------
  # Membuat dropdown selector tahun yang disesuaikan dengan data yang tersedia
  # UI element ini akan muncul setelah data berhasil dimuat
  
  output$year_selector <- renderUI({
    # Memastikan data sudah dimuat sebelum rendering
    req(rv$data_loaded)
    
    # Membuat selectInput dengan pilihan tahun dari data aktual
    selectInput("selected_year", "Pilih Tahun:",
                # Mengambil tahun unik dari dataset gabungan
                choices = unique(rv$data_with_sealevel$year),
                # Default selection adalah tahun terbaru (maksimum)
                selected = max(rv$data_with_sealevel$year))
  })
  
  # -----------------------------------------------------------------------
  # 4. Dashboard
  # -----------------------------------------------------------------------
  # Bagian ini menghasilkan ringkasan statistik kunci dalam bentuk value boxes
  # untuk memberikan overview cepat tentang dataset
  
  # -----------------------------------------------------------------------
  # 4.1 Jumlah Negara
  # -----------------------------------------------------------------------
  # Menampilkan jumlah negara yang tersedia dalam dataset
  
  output$total_countries <- renderValueBox({
    # Jika data belum dimuat, tampilkan placeholder
    if (!rv$data_loaded) {
      return(valueBox("Upload Data", "Data belum dimuat", icon = icon("exclamation")))
    }
    
    # Menghitung jumlah negara unik dalam dataset
    valueBox(
      value = n_distinct(rv$data_iklim$country), 
      subtitle = "Jumlah Negara", 
      icon = icon("flag"),
      color = "purple"
    )
  })
  
  # -----------------------------------------------------------------------
  # 4.2 Rentang Tahun
  # -----------------------------------------------------------------------
  # Menampilkan rentang tahun yang dianalisis
  
  output$year_range <- renderValueBox({
    # Placeholder jika data belum dimuat
    if (!rv$data_loaded) {
      return(valueBox("Upload Data", "Data belum dimuat", icon = icon("exclamation")))
    }
    
    # Menampilkan rentang tahun tetap (1993-2023)
    valueBox(
      value = "1993 - 2023", 
      subtitle = "Rentang Tahun", 
      icon = icon("calendar"),
      color = "green"
    )
  })
  
  # -----------------------------------------------------------------------
  # 4.3 Jumlah data
  # -----------------------------------------------------------------------
  # Menampilkan jumlah total observasi dalam dataset gabungan
  
  output$total_records <- renderValueBox({
    # Placeholder jika data belum dimuat
    if (!rv$data_loaded) {
      return(valueBox("Upload Data", "Data belum dimuat", icon = icon("exclamation")))
    }
    
    # Menghitung total baris dalam dataset gabungan
    valueBox(
      value = format(nrow(rv$data_with_sealevel)),
      subtitle = "Total Data Lengkap",
      icon = icon("database"),
      color = "yellow"
    )
  })
  
  # -----------------------------------------------------------------------
  # 5. Tabel Deskriptif
  # -----------------------------------------------------------------------
  # Bagian ini menghasilkan tabel statistik deskriptif yang komprehensif
  # untuk tahun yang dipilih user, menampilkan berbagai ukuran statistik
  
  output$desc_stats <- DT::renderDataTable({
    # Memastikan data dimuat dan tahun dipilih
    req(rv$data_loaded, input$selected_year)
    
    # -----------------------------------------------------------------------
    # 5.1 Batas data
    # -----------------------------------------------------------------------
    # Filter data untuk tahun spesifik yang dipilih user
    filtered_data <- rv$data_with_sealevel %>%
      filter(year == input$selected_year)
    
    # -----------------------------------------------------------------------
    # 5.2 Penghitungan sederhana
    # -----------------------------------------------------------------------
    # Menghitung statistik deskriptif untuk semua variabel kunci
    # Menggunakan bind_rows untuk menggabungkan statistik dari berbagai variabel
    
    final_stats <- bind_rows(
      # STATISTIK UNTUK SEA LEVEL (variabel global - satu nilai per tahun)
      filtered_data %>%
        distinct(year, .keep_all = TRUE) %>%
        summarise(
          Variable = "Sea_level",
          Count = n(),  # Jumlah observasi
          Mean = round(mean(Sea_level, na.rm = TRUE), 2),      # Rata-rata
          Median = round(median(Sea_level, na.rm = TRUE), 2),  # Median
          SD = round(sd(Sea_level, na.rm = TRUE), 2),          # Standar deviasi
          Min = round(min(Sea_level, na.rm = TRUE), 2),        # Nilai minimum
          Q1 = round(quantile(Sea_level, 0.25, na.rm = TRUE), 2),  # Kuartil 1
          Q3 = round(quantile(Sea_level, 0.75, na.rm = TRUE), 2),  # Kuartil 3
          Max = round(max(Sea_level, na.rm = TRUE), 2),        # Nilai maksimum
          Total = NA  # Total tidak relevan untuk sea level
        ),
      
      # STATISTIK UNTUK POPULATION (data per negara)
      filtered_data %>%
        summarise(
          Variable = "population",
          Count = n(),
          Mean = round(mean(population, na.rm = TRUE), 2),
          Median = round(median(population, na.rm = TRUE), 2),
          SD = round(sd(population, na.rm = TRUE), 2),
          Min = round(min(population, na.rm = TRUE), 2),
          Q1 = round(quantile(population, 0.25, na.rm = TRUE), 2),
          Q3 = round(quantile(population, 0.75, na.rm = TRUE), 2),
          Max = round(max(population, na.rm = TRUE), 2),
          Total = round(sum(population, na.rm = TRUE), 2)  # Total populasi global
        ),
      
      # STATISTIK UNTUK CO2 EMISSIONS (data per negara)
      filtered_data %>%
        summarise(
          Variable = "co2",
          Count = n(),
          Mean = round(mean(co2, na.rm = TRUE), 2),
          Median = round(median(co2, na.rm = TRUE), 2),
          SD = round(sd(co2, na.rm = TRUE), 2),
          Min = round(min(co2, na.rm = TRUE), 2),
          Q1 = round(quantile(co2, 0.25, na.rm = TRUE), 2),
          Q3 = round(quantile(co2, 0.75, na.rm = TRUE), 2),
          Max = round(max(co2, na.rm = TRUE), 2),
          Total = round(sum(co2, na.rm = TRUE), 2)  # Total emisi CO2 global
        ),
      
      # STATISTIK UNTUK CO2 PER CAPITA (intensitas emisi per orang)
      filtered_data %>%
        summarise(
          Variable = "co2_per_capita",
          Count = n(),
          Mean = round(mean(co2_per_capita, na.rm = TRUE), 2),
          Median = round(median(co2_per_capita, na.rm = TRUE), 2),
          SD = round(sd(co2_per_capita, na.rm = TRUE), 2),
          Min = round(min(co2_per_capita, na.rm = TRUE), 2),
          Q1 = round(quantile(co2_per_capita, 0.25, na.rm = TRUE), 2),
          Q3 = round(quantile(co2_per_capita, 0.75, na.rm = TRUE), 2),
          Max = round(max(co2_per_capita, na.rm = TRUE), 2),
          Total = NA  # Total tidak relevan untuk rata-rata per kapita
        ),
      
      # STATISTIK UNTUK TEMPERATURE CHANGE (perubahan suhu per negara)
      filtered_data %>%
        summarise(
          Variable = "temp_change", 
          Count = n(),
          Mean = round(mean(temp_change, na.rm = TRUE), 2),
          Median = round(median(temp_change, na.rm = TRUE), 2),
          SD = round(sd(temp_change, na.rm = TRUE), 2),
          Min = round(min(temp_change, na.rm = TRUE), 2),
          Q1 = round(quantile(temp_change, 0.25, na.rm = TRUE), 2),
          Q3 = round(quantile(temp_change, 0.75, na.rm = TRUE), 2),
          Max = round(max(temp_change, na.rm = TRUE), 2),
          Total = NA  # Total tidak relevan untuk perubahan suhu
        )
    )
    
    # -----------------------------------------------------------------------
    # 5.3 Tabel Deskriptif
    # -----------------------------------------------------------------------
    # Membuat tabel interaktif dengan fitur export dan navigasi
    
    DT::datatable(
      final_stats,
      options = list(
        scrollX = TRUE,        # Horizontal scrolling untuk tabel lebar
        pageLength = 10,       # Menampilkan 10 baris per halaman
        dom = 'Brtip',        # Layout: Buttons, table, info, pagination
        buttons = c('copy', 'csv', 'excel', 'pdf'),  # Tombol export
        searching = FALSE      # Nonaktifkan search box (data sedikit)
      ),
      extensions = 'Buttons',   # Aktifkan extension untuk tombol export
      caption = paste("Descriptive Statistics for Year", input$selected_year),
      rownames = FALSE         # Hilangkan row numbers
    )
  })
  
  # -----------------------------------------------------------------------
  # 6. Matriks Korelasi
  # -----------------------------------------------------------------------
  # Bagian ini menghasilkan visualisasi matriks korelasi antar semua variabel
  # menggunakan corrplot untuk analisis hubungan multivariat
  
  output$correlation_matrix <- renderPlot({
    # Memastikan data sudah dimuat
    req(rv$data_loaded)
    
    # -----------------------------------------------------------------------
    # 6.1 Persiapan Data
    # -----------------------------------------------------------------------
    # Memilih hanya variabel numerik dan membersihkan missing values
    
    cor_data <- rv$data_with_sealevel %>%
      # Pilih variabel yang akan dianalisis korelasinya
      select(population, co2, co2_per_capita, temp_change, Sea_level) %>%
      # Hapus baris dengan missing values untuk perhitungan korelasi yang akurat
      na.omit() %>%
      # Hitung matriks korelasi Pearson
      cor()
    
    # -----------------------------------------------------------------------
    # 6.2 Plot Korelasi
    # -----------------------------------------------------------------------
    # Membuat visualisasi matriks korelasi dengan kustomisasi estetika
    
    corrplot(cor_data, 
             method = "color",           # Gunakan warna untuk representasi
             type = "upper",            # Tampilkan hanya segitiga atas
             addCoef.col = "black",     # Tambahkan koefisien dengan warna hitam
             tl.cex = 0.8,             # Ukuran text label
             number.cex = 0.7,         # Ukuran angka koefisien
             # Custom color palette: merah (negatif) ke biru (positif)
             col = colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", 
                                      "#77AADD", "#4477AA"))(200))
  })
  
  # -----------------------------------------------------------------------
  # 7. Analisis Korelasi
  # -----------------------------------------------------------------------
  # Bagian ini merupakan engine utama untuk analisis korelasi yang komprehensif
  # dengan dukungan berbagai metode statistik dan visualisasi interaktif
  
  observeEvent(input$analyze_corr, {
    # Memastikan data sudah dimuat sebelum analisis
    req(rv$data_loaded)
    
    # -----------------------------------------------------------------------
    # 7.1 Khusus Y sea_level
    # -----------------------------------------------------------------------
    # Analisis khusus ketika Sea Level dipilih sebagai variabel Y
    # Karena Sea Level adalah data global (satu nilai per tahun), 
    # diperlukan agregasi data yang berbeda
    
    if (input$var_y == "Sea_level" || input$var_y == "ln_Sea_level") {
      tryCatch({
        # AGREGASI DATA GLOBAL PER TAHUN
        # Menggabungkan data per negara menjadi total global per tahun
        # untuk dibandingkan dengan sea level global
        filtered_data <- rv$data_with_sealevel %>%
          # Filter berdasarkan rentang tahun yang dipilih user
          filter(year >= input$year_filter[1] & year <= input$year_filter[2]) %>%
          group_by(year) %>%
          summarize(
            # Agregasi variabel X (misal: total CO2 global per tahun)
            x_value = as.numeric(sum(!!sym(input$var_x), na.rm = TRUE)),
            # Sea level: ambil nilai pertama karena sama untuk semua negara di tahun yang sama
            y_value = as.numeric(sum(!!sym(input$var_y), na.rm = TRUE)),
            .groups = 'drop'
          ) %>%
          # Hapus baris dengan missing values
          filter(complete.cases(.)) %>%
          # Hapus nilai infinite yang mungkin muncul dari perhitungan
          filter_if(is.numeric, all_vars(!is.infinite(.)))
        
        # VALIDASI DATA MINIMUM
        # Minimal 3 tahun data diperlukan untuk analisis korelasi yang meaningful
        if(nrow(filtered_data) < 3) {
          stop("Data tidak cukup (minimal 3 tahun diperlukan)")
        }
        
        # -----------------------------------------------------------------------
        # 7.1.1 Scatter Plot
        # -----------------------------------------------------------------------
        output$scatter_plot <- renderPlotly({
          # Menentukan nama metode untuk subtitle
          method_name <- switch(input$cor_method,
                                "pearson" = "Linear (Pearson)",
                                "spearman" = "Monotonic (Spearman)",
                                "kendall" = "Monotonic (Kendall)")
          
          # Membuat base plot dengan ggplot2
          p <- ggplot(filtered_data, aes(x = x_value, y = y_value)) +
            # Scatter points dengan styling yang menarik
            geom_point(alpha = 0.8, color = "steelblue", size = 3) +
            # Labels dan title yang informatif
            labs(title = paste("Hubungan Global:", input$var_x, "vs Sea Level"),
                 subtitle = paste("Metode:", method_name, "| Periode:", 
                                  input$year_filter[1], "-", input$year_filter[2]),
                 x = paste("Total Global", input$var_x), 
                 y = "Sea Level (mm)") +
            theme_minimal()
          
          # CONDITIONAL TREND LINE BERDASARKAN METODE KORELASI
          if(input$cor_method == "pearson") {
            # Untuk Pearson: tambahkan linear regression line
            p <- p + geom_smooth(method = "lm", formula = y ~ x,
                                 color = "red", se = TRUE, size = 1.2)
          } else {
            # Untuk non-parametrik: tambahkan LOESS smoothing + linear reference
            p <- p +
              geom_smooth(method = "loess", formula = y ~ x,
                          color = "green", se = TRUE, size = 1.2) +
              geom_line(stat = "smooth", method = "lm", formula = y ~ x,
                        color = "red", linetype = "dashed", alpha = 0.5)
          }
          
          # Convert ke plotly untuk interaktivitas
          ggplotly(p)
        })
        
        # -----------------------------------------------------------------------
        # 7.1.2 Statistik
        # -----------------------------------------------------------------------
        # Melakukan uji korelasi dengan metode yang dipilih user
        
        cor_test <- cor.test(
          x = filtered_data$x_value,
          y = filtered_data$y_value,
          method = input$cor_method,
          exact = FALSE  # Untuk metode non-parametrik dengan sample besar
        )
        
        # -----------------------------------------------------------------------
        # 7.1.3 Hasil
        # -----------------------------------------------------------------------
        output$correlation_result <- renderText({
          paste(
            "HASIL UJI KORELASI", toupper(input$cor_method), " (SEA LEVEL)\n",
            "======================================\n\n",
            "Variabel X: Total Global", input$var_x, "\n",
            "Variabel Y: Sea Level (Global)\n\n",
            "Analisis menggunakan total global per tahun.\n\n",
            "Koefisien Korelasi:", round(cor_test$estimate, 4), "\n",
            "p-value:", format.pval(cor_test$p.value, digits = 3), "\n",
            # CONDITIONAL OUTPUT BERDASARKAN METODE
            if(input$cor_method == "pearson") {
              paste("Confidence Interval 95%:", 
                    round(cor_test$conf.int[1], 4), "-", 
                    round(cor_test$conf.int[2], 4), "\n",
                    "t-statistic:", round(cor_test$statistic, 4), "\n",
                    "df:", cor_test$parameter, "\n")
            } else {
              paste("Metode non-parametrik tidak menghitung confidence interval\n")
            },
            "Sample size:", nrow(filtered_data), "tahun\n",
            "Periode analisis:", input$year_filter[1], "-", input$year_filter[2], "\n\n",
            if(input$cor_method != "pearson") {
              "CATATAN: Metode non-parametrik digunakan karena data tidak normal atau hubungan tidak linear"
            } else ""
          )
        })
        
        # -----------------------------------------------------------------------
        # 7.1.4 Interpretasi
        # -----------------------------------------------------------------------
        output$correlation_interpretation <- renderText({
          # KLASIFIKASI KEKUATAN KORELASI
          strength <- case_when(
            abs(cor_test$estimate) >= 0.7 ~ "sangat kuat",
            abs(cor_test$estimate) >= 0.5 ~ "kuat",
            abs(cor_test$estimate) >= 0.3 ~ "sedang",
            TRUE ~ "lemah"
          )
          
          # ARAH KORELASI
          direction <- ifelse(cor_test$estimate > 0, "positif", "negatif")
          
          # SIGNIFIKANSI STATISTIK
          significance <- ifelse(cor_test$p.value < 0.05, "signifikan", "tidak signifikan")
          
          paste(
            "INTERPRETASI:\n",
            "Hubungan", strength, "dan", direction, "\n",
            "Signifikansi (α=0.05):", significance, "\n\n",
            # METHOD-SPECIFIC INTERPRETATION
            if(input$cor_method != "pearson") {
              paste("METODE NON-PARAMETRIK:\n",
                    "• Mengukur hubungan monotonik (tidak harus linear)\n",
                    "• Lebih robust terhadap outlier dan data tidak normal\n")
            } else {
              paste("ASUMSI PEARSON:\n",
                    "• Hubungan linear antara variabel\n",
                    "• Data berdistribusi normal (disarankan cek dengan uji Shapiro-Wilk)\n")
            }
          )
        })
        
      }, error = function(e) {
        # ERROR HANDLING UNTUK SEA LEVEL ANALYSIS
        output$correlation_result <- renderText({
          paste("ERROR:", e$message, "\n",
                "Pastikan:\n",
                "1. Data tersedia untuk periode ini\n",
                "2. Variabel mengandung nilai numerik\n",
                "3. Tidak ada missing values yang mengganggu")
        })
        
        # PLACEHOLDER PLOT UNTUK ERROR STATE
        output$scatter_plot <- renderPlotly({
          ggplot() + 
            annotate("text", x = 0.5, y = 0.5, label = "Data tidak dapat ditampilkan") +
            theme_void()
        })
        
        output$correlation_interpretation <- renderText({
          "Interpretasi tidak tersedia karena error dalam analisis data"
        })
      })
      
      # -----------------------------------------------------------------------
      # 7.2 Khusus Y non sea_level
      # -----------------------------------------------------------------------
      # Analisis korelasi standar untuk variabel selain Sea Level
      # Menggunakan data per negara tanpa agregasi temporal
      
    } else {
      # Blok try-catch untuk menangani error dalam analisis korelasi
      tryCatch({
        # Memfilter data berdasarkan rentang tahun yang dipilih user
        # dan memilih hanya variabel X dan Y yang akan dianalisis
        filtered_data <- rv$data_with_sealevel %>%
          filter(year >= input$year_filter[1] & year <= input$year_filter[2]) %>%
          select(!!sym(input$var_x), !!sym(input$var_y)) %>%
          filter(complete.cases(.)) %>%  # Menghapus baris dengan nilai NA
          filter_if(is.numeric, all_vars(!is.infinite(.)))  # Menghapus nilai infinite
        
        # Validasi jumlah data minimum untuk analisis korelasi
        if(nrow(filtered_data) < 3) {
          stop("Data tidak cukup (minimal 3 observasi diperlukan)")
        }
        
        # -----------------------------------------------------------------------
        # 7.2.1 Scatter Plot
        # -----------------------------------------------------------------------
        
        # Membuat scatter plot dengan plotly untuk visualisasi hubungan antar variabel
        output$scatter_plot <- renderPlotly({
          # Menentukan nama metode korelasi untuk subtitle plot
          method_name <- switch(input$cor_method,
                                "pearson" = "Linear (Pearson)",
                                "spearman" = "Monotonic (Spearman)",
                                "kendall" = "Monotonic (Kendall)")
          
          # Membuat plot dasar dengan ggplot2
          p <- ggplot(filtered_data, aes_string(x = input$var_x, y = input$var_y)) +
            geom_point(alpha = 0.6, color = "steelblue", size = 1.5) +  # Titik-titik data
            labs(title = paste("Hubungan antara", input$var_x, "dan", input$var_y),
                 subtitle = paste("Metode:", method_name, "| Periode:", 
                                  input$year_filter[1], "-", input$year_filter[2]),
                 x = input$var_x, y = input$var_y) +
            theme_minimal() +
            theme(plot.title = element_text(size = 14, face = "bold"))
          
          # Menambahkan garis tren berdasarkan metode korelasi yang dipilih
          if(input$cor_method == "pearson") {
            # Untuk Pearson: garis regresi linear dengan confidence interval
            p <- p + geom_smooth(method = "lm", formula = y ~ x,
                                 color = "red", se = TRUE, size = 1.2)
          } else {
            # Untuk Spearman/Kendall: garis LOESS (non-linear) + garis linear putus-putus
            p <- p + 
              geom_smooth(method = "loess", formula = y ~ x,
                          color = "green", se = TRUE, size = 1.2) +
              geom_line(stat = "smooth", method = "lm", formula = y ~ x,
                        color = "red", linetype = "dashed", alpha = 0.5)
          }
          
          # Mengkonversi ggplot ke plotly untuk interaktivitas
          ggplotly(p)
        })
        
        # -----------------------------------------------------------------------
        # 7.2.2 Statistik
        # -----------------------------------------------------------------------
        
        # Melakukan uji korelasi berdasarkan metode yang dipilih
        cor_test <- cor.test(
          x = filtered_data[[1]],  # Variabel X (kolom pertama)
          y = filtered_data[[2]],  # Variabel Y (kolom kedua)
          method = input$cor_method,  # Metode: pearson, spearman, atau kendall
          exact = FALSE  # Menggunakan aproksimasi normal untuk sampel besar
        )
        
        # -----------------------------------------------------------------------
        # 7.2.3 Hasil
        # -----------------------------------------------------------------------
        
        # Menampilkan hasil numerik uji korelasi dalam format yang mudah dibaca
        output$correlation_result <- renderText({
          paste(
            "HASIL UJI KORELASI", toupper(input$cor_method), "\n",
            "==========================\n\n",
            "Variabel X:", input$var_x, "\n",
            "Variabel Y:", input$var_y, "\n\n",
            "Koefisien Korelasi:", round(cor_test$estimate, 4), "\n",
            "p-value:", format.pval(cor_test$p.value, digits = 3), "\n",
            
            # Informasi tambahan hanya untuk metode Pearson
            if(input$cor_method == "pearson") {
              paste("Confidence Interval 95%:", 
                    round(cor_test$conf.int[1], 4), "-", 
                    round(cor_test$conf.int[2], 4), "\n",
                    "t-statistic:", round(cor_test$statistic, 4), "\n",
                    "df:", cor_test$parameter, "\n")
            } else {
              paste("Metode non-parametrik tidak menghitung confidence interval\n")
            },
            
            "Jumlah Sampel:", nrow(filtered_data), "\n",
            "Periode analisis:", input$year_filter[1], "-", input$year_filter[2], "\n\n",
            
            # Catatan untuk metode non-parametrik
            if(input$cor_method != "pearson") {
              "CATATAN: Metode non-parametrik digunakan karena data tidak normal atau hubungan tidak linear"
            } else ""
          )
        })
        
        # -----------------------------------------------------------------------
        # 7.2.4 Interpretasi
        # -----------------------------------------------------------------------
        
        # Memberikan interpretasi yang mudah dipahami tentang hasil korelasi
        output$correlation_interpretation <- renderText({
          # Menentukan kekuatan korelasi berdasarkan nilai absolut koefisien
          strength <- case_when(
            abs(cor_test$estimate) >= 0.7 ~ "sangat kuat",
            abs(cor_test$estimate) >= 0.5 ~ "kuat",
            abs(cor_test$estimate) >= 0.3 ~ "sedang",
            TRUE ~ "lemah"
          )
          
          # Menentukan arah korelasi (positif atau negatif)
          direction <- ifelse(cor_test$estimate > 0, "positif", "negatif")
          
          # Menentukan signifikansi statistik (alpha = 0.05)
          significance <- ifelse(cor_test$p.value < 0.05, "signifikan", "tidak signifikan")
          
          # Menyusun interpretasi lengkap
          paste(
            "INTERPRETASI:\n",
            "Hubungan", strength, "dan", direction, "\n",
            "Signifikansi (α=0.05):", significance, "\n\n",
            
            # Penjelasan spesifik berdasarkan metode yang digunakan
            if(input$cor_method != "pearson") {
              paste("METODE NON-PARAMETRIK:\n",
                    "• Mengukur hubungan monotonik (tidak harus linear)\n",
                    "• Lebih robust terhadap outlier dan data tidak normal\n",
                    "• Berdasarkan ranking data, bukan nilai aktual\n\n")
            } else {
              paste("ASUMSI PEARSON:\n",
                    "• Hubungan linear antara variabel\n",
                    "• Data berdistribusi normal (disarankan cek dengan uji Shapiro-Wilk)\n\n")
            },
            
            # Rekomendasi berdasarkan kekuatan korelasi
            "REKOMENDASI:\n",
            if(abs(cor_test$estimate) >= 0.5) {
              "Korelasi cukup kuat untuk dipertimbangkan dalam analisis lebih lanjut"
            } else {
              "Korelasi lemah, mungkin perlu mempertimbangkan variabel lain"
            }
          )
        })
        
      }, error = function(e) {
        # -----------------------------------------------------------------------
        # 7.2.5 Error
        # -----------------------------------------------------------------------
        
        # Menampilkan pesan error yang informatif jika analisis gagal
        output$correlation_result <- renderText({
          paste("ERROR:", e$message, "\n",
                "Pastikan:\n",
                "1. Data tersedia untuk periode ini\n",
                "2. Variabel mengandung nilai numerik\n",
                "3. Tidak ada missing values yang mengganggu")
        })
        
        # Menampilkan plot kosong dengan pesan error
        output$scatter_plot <- renderPlotly({
          ggplot() + 
            annotate("text", x = 0.5, y = 0.5, label = "Data tidak dapat ditampilkan") +
            theme_void()
        })
        
        # Menampilkan pesan error untuk interpretasi
        output$correlation_interpretation <- renderText({
          "Interpretasi tidak tersedia karena error dalam analisis data"
        })
      })
    }
  })
  
  # -----------------------------------------------------------------------
  # 8. Analisis Regresi
  # -----------------------------------------------------------------------
  
  # Bagian ini menangani analisis regresi untuk memodelkan hubungan antara
  # variabel dependen dengan satu atau lebih variabel independen
  
  # -----------------------------------------------------------------------
  # 8.1 Rumus 
  # -----------------------------------------------------------------------
  
  # Membuat dan menampilkan formula model regresi berdasarkan input user
  output$model_formula <- renderText({
    # Validasi input variabel independen
    if(length(input$reg_x_multiple) == 0) {
      "Pilih minimal satu variabel independen"
    } else if(length(input$reg_x_multiple) == 1) {
      # Formula untuk regresi dengan satu variabel independen
      if(input$reg_type == "poly") {
        # Regresi polinomial orde 2
        paste(input$reg_y, "~ poly(", input$reg_x_multiple[1], ", 2)")
      } else {
        # Regresi linear sederhana
        paste(input$reg_y, "~", input$reg_x_multiple[1])
      }
    } else {
      # Formula untuk regresi dengan multiple variabel independen
      if(input$reg_type == "poly") {
        # Regresi polinomial untuk setiap variabel independen
        poly_terms <- sapply(input$reg_x_multiple, function(x) paste0("poly(", x, ", 2)"))
        paste(input$reg_y, "~", paste(poly_terms, collapse = " + "))
      } else {
        # Regresi linear multivariabel
        paste(input$reg_y, "~", paste(input$reg_x_multiple, collapse = " + "))
      }
    }
  })
  
  # -----------------------------------------------------------------------
  # 8.2 Uji
  # -----------------------------------------------------------------------
  
  # Event handler untuk tombol analisis regresi
  observeEvent(input$analyze_reg, {
    # Validasi input yang diperlukan
    req(input$reg_x_multiple, rv$data_loaded)
    
    # Persiapan data berdasarkan variabel dependen yang dipilih
    if(input$reg_y == "Sea_level" || input$reg_y == "ln_Sea_level") {
      # Untuk sea level: gunakan data unik per tahun (time series)
      reg_data <- rv$data_with_sealevel %>%
        distinct(year, .keep_all = TRUE) %>%
        na.omit()  # Hapus missing values
    } else {
      # Untuk variabel lain: gunakan semua data
      reg_data <- rv$data_with_sealevel %>% na.omit()
    }
    
    # -----------------------------------------------------------------------
    # 8.3 Persiapan dan uji
    # -----------------------------------------------------------------------
    
    # Membangun formula model berdasarkan tipe regresi yang dipilih
    if(input$reg_type == "poly") {
      # Regresi polinomial
      if(length(input$reg_x_multiple) == 1) {
        # Polinomial orde 2 untuk satu variabel
        formula_str <- paste(input$reg_y, "~ poly(", input$reg_x_multiple[1], ", 2)")
      } else {
        # Polinomial orde 2 untuk multiple variabel
        poly_terms <- sapply(input$reg_x_multiple, function(x) paste0("poly(", x, ", 2)"))
        formula_str <- paste(input$reg_y, "~", paste(poly_terms, collapse = " + "))
      }
    } else {
      # Regresi linear
      formula_str <- paste(input$reg_y, "~", paste(input$reg_x_multiple, collapse = " + "))
    }
    
    # Membangun model regresi linear menggunakan fungsi lm()
    model <- lm(as.formula(formula_str), data = reg_data)
    
    # -----------------------------------------------------------------------
    # 8.4 Hasil (visual)
    # -----------------------------------------------------------------------
    
    # Membuat plot regresi yang sesuai dengan jumlah variabel independen
    output$regression_plot <- renderPlotly({
      if(length(input$reg_x_multiple) == 1) {
        # Plot scatter dengan garis regresi untuk satu variabel independen
        p <- ggplot(reg_data, aes_string(x = input$reg_x_multiple[1], y = input$reg_y)) +
          geom_point(alpha = 0.6, color = "steelblue", size = 1.5) +  # Data points
          geom_smooth(method = "lm", color = "red", se = TRUE, size = 1.2) +  # Garis regresi
          labs(title = paste("Regresi:", input$reg_y, "~", input$reg_x_multiple[1]),
               x = input$reg_x_multiple[1], y = input$reg_y) +
          theme_minimal()
        
        ggplotly(p)
      } else {
        # Plot Actual vs Predicted untuk regresi multivariabel
        model_data <- data.frame(
          fitted = fitted(model),      # Nilai prediksi model
          residuals = residuals(model), # Residual model
          actual = reg_data[[input$reg_y]]  # Nilai aktual
        )
        
        # Scatter plot nilai aktual vs prediksi
        p <- ggplot(model_data, aes(x = fitted, y = actual)) +
          geom_point(alpha = 0.6, color = "steelblue") +
          geom_abline(slope = 1, intercept = 0, color = "red", size = 1.2) +  # Garis diagonal (perfect fit)
          labs(title = "Actual vs Predicted Values",
               x = "Predicted Values", y = "Actual Values") +
          theme_minimal()
        
        ggplotly(p)
      }
    })
    
    # -----------------------------------------------------------------------
    # 8.5 Statistik Model
    # -----------------------------------------------------------------------
    
    # Menampilkan summary lengkap model regresi
    output$regression_summary <- renderText({
      # Mengcapture output summary model dalam format teks
      summary_text <- capture.output(summary(model))
      paste(summary_text, collapse = "\n")
    })
    
    # -----------------------------------------------------------------------
    # 8.6 Hasil
    # -----------------------------------------------------------------------
    
    # Menghitung dan menampilkan metrik evaluasi model
    output$model_performance <- renderText({
      # Metrik-metrik evaluasi model
      r_squared <- summary(model)$r.squared           # R-squared
      adj_r_squared <- summary(model)$adj.r.squared   # Adjusted R-squared
      rmse <- sqrt(mean(residuals(model)^2))          # Root Mean Squared Error
      mae <- mean(abs(residuals(model)))              # Mean Absolute Error
      
      # Format output metrik performa
      paste("MODEL PERFORMANCE METRICS\n",
            "=========================\n\n",
            "R-squared:", round(r_squared, 4), "\n",
            "Adjusted R-squared:", round(adj_r_squared, 4), "\n",
            "RMSE:", round(rmse, 4), "\n",
            "MAE:", round(mae, 4), "\n\n",
            "INTERPRETASI:\n",
            paste("Model menjelaskan", round(r_squared*100, 2), "% variasi dalam", input$reg_y))
    })
    
    # -----------------------------------------------------------------------
    # 8.7 Hasil diagnostik
    # -----------------------------------------------------------------------
    
    # Membuat plot diagnostik untuk validasi asumsi regresi
    output$diagnostic_plots <- renderPlot({
      # Mengatur layout plot dalam grid 2x3
      par(mfrow = c(2, 3), mar = c(4, 4, 2, 1))
      
      # Plot 1: Residuals vs Fitted Values
      # Untuk mengecek homoskedastisitas (kesamaan varian residual)
      plot(fitted(model), residuals(model), 
           main = "Residuals vs Fitted", 
           xlab = "Fitted Values", ylab = "Residuals",
           pch = 16, col = alpha("steelblue", 0.6))
      abline(h = 0, col = "red", lwd = 2)  # Garis horizontal di y=0
      
      # Plot 2: Normal Q-Q Plot
      # Untuk mengecek normalitas residual
      qqnorm(residuals(model), main = "Normal Q-Q Plot", 
             pch = 16, col = alpha("steelblue", 0.6))
      qqline(residuals(model), col = "red", lwd = 2)  # Garis referensi normal
      
      # Plot 3: Scale-Location Plot
      # Untuk mengecek homoskedastisitas dengan cara lain
      plot(fitted(model), sqrt(abs(residuals(model))), 
           main = "Scale-Location", 
           xlab = "Fitted Values", ylab = "√|Residuals|",
           pch = 16, col = alpha("steelblue", 0.6))
      
      # Plot 4: Cook's Distance
      # Untuk mengidentifikasi observasi yang berpengaruh (influential observations)
      plot(cooks.distance(model), 
           main = "Cook's Distance", 
           ylab = "Cook's Distance",
           pch = 16, col = alpha("steelblue", 0.6))
      # Garis referensi Cook's Distance threshold (4/n)
      abline(h = 4/nrow(reg_data), col = "red", lwd = 2, lty = 2)
      
      # Plot 5: Residuals vs Leverage
      # Untuk mengidentifikasi outlier dan high leverage points
      plot(hatvalues(model), residuals(model), 
           main = "Residuals vs Leverage", 
           xlab = "Leverage", ylab = "Residuals",
           pch = 16, col = alpha("steelblue", 0.6))
      abline(h = 0, col = "red", lwd = 2)  # Garis horizontal di y=0
      
      # Plot 6: Histogram of Residuals
      # Untuk visualisasi distribusi residual
      hist(residuals(model), 
           main = "Histogram of Residuals", 
           xlab = "Residuals", 
           col = alpha("steelblue", 0.7),
           border = "white")
    })
  })
  
  # -----------------------------------------------------------------------
  # 9. Uji Hipotesis
  # -----------------------------------------------------------------------
  
  # Bagian ini menangani uji hipotesis statistik untuk menguji hubungan korelasi
  # antara dua variabel dengan berbagai metode korelasi dan tingkat signifikansi
  # yang dapat disesuaikan oleh user
  
  # Event handler untuk tombol uji hipotesis
  # Dipicu ketika user menekan tombol "Test Hypothesis"
  observeEvent(input$test_hypothesis, {
    # Validasi bahwa data sudah dimuat
    req(rv$data_loaded)
    
    # -----------------------------------------------------------------------
    # 9.1 Uji hipotesis dengan sea level
    # -----------------------------------------------------------------------
    
    # Penanganan khusus untuk analisis yang melibatkan Sea Level sebagai variabel Y
    # Sea Level memerlukan perlakuan khusus karena merupakan data time series global
    if(input$hyp_var2 == "Sea_level" || input$hyp_var2 == "ln_Sea_level") {
      
      # Blok try-catch untuk menangani error dalam analisis sea level
      tryCatch({
        
        # -----------------------------------------------------------------------
        # 9.1.1 Persiapan data
        # -----------------------------------------------------------------------
        
        # Memfilter dan mengagregasi data untuk analisis sea level
        # Data diagregasi per tahun karena sea level adalah data time series
        filtered_data <- rv$data_with_sealevel %>%
          # Filter berdasarkan rentang tahun yang dipilih user
          filter(year >= input$hyp_year_filter[1] & year <= input$hyp_year_filter[2]) %>%
          # Group by tahun untuk agregasi data
          group_by(year) %>%
          summarize(
            # Menghitung total global variabel X per tahun
            x_value = as.numeric(sum(!!sym(input$hyp_var1), na.rm = TRUE)),
            # Mengambil nilai sea level (asumsi sama untuk semua observasi dalam tahun yang sama)
            y_value = as.numeric(sum(!!sym(input$hyp_var2), na.rm = TRUE)),
            .groups = 'drop'  # Menghapus grouping setelah summarize
          ) %>%
          # Menghapus baris dengan nilai NA
          filter(complete.cases(.)) %>%
          # Menghapus nilai infinite jika ada
          filter_if(is.numeric, all_vars(!is.infinite(.)))
        
        # Validasi jumlah data minimum untuk uji hipotesis
        if(nrow(filtered_data) < 3) {
          stop("Data tidak cukup (minimal 3 tahun diperlukan)")
        }
        
        # -----------------------------------------------------------------------
        # 9.1.2 Uji
        # -----------------------------------------------------------------------
        
        # Melakukan uji korelasi dengan parameter yang ditentukan user
        cor_test <- cor.test(
          x = filtered_data$x_value,           # Total global variabel X
          y = filtered_data$y_value,           # Sea level
          method = input$cor_method_hyp,       # Metode korelasi (pearson/spearman/kendall)
          exact = FALSE,                       # Menggunakan aproksimasi untuk sampel besar
          conf.level = 1 - input$alpha         # Tingkat confidence berdasarkan alpha
        )
        
        # -----------------------------------------------------------------------
        # 9.1.3 Hasil
        # -----------------------------------------------------------------------
        
        # Menampilkan hasil numerik uji hipotesis dalam format yang terstruktur
        output$hypothesis_result <- renderText({
          paste(
            "HASIL UJI HIPOTESIS", toupper(input$cor_method_hyp), " (SEA LEVEL)\n",
            "============================================\n\n",
            "Variabel X: Total Global", input$hyp_var1, "\n",
            "Variabel Y: Sea Level (Global)\n\n",
            "Analisis menggunakan total global per tahun.\n\n",
            "Koefisien Korelasi:", round(cor_test$estimate, 4), "\n",
            "p-value:", format.pval(cor_test$p.value, digits = 3), "\n",
            
            # Informasi tambahan khusus untuk metode Pearson
            if(input$cor_method_hyp == "pearson") {
              paste("Confidence Interval", (1-input$alpha)*100, "%:", 
                    round(cor_test$conf.int[1], 4), "-", 
                    round(cor_test$conf.int[2], 4), "\n",
                    "t-statistic:", round(cor_test$statistic, 4), "\n",
                    "df:", cor_test$parameter, "\n")
            } else {
              paste("Metode non-parametrik tidak menghitung confidence interval\n")
            },
            
            "Sample size:", nrow(filtered_data), "tahun\n",
            "Periode analisis:", input$hyp_year_filter[1], "-", input$hyp_year_filter[2], "\n",
            "Tingkat Signifikansi (α):", input$alpha, "\n\n",
            
            # Catatan untuk metode non-parametrik
            if(input$cor_method_hyp != "pearson") {
              "CATATAN: Metode non-parametrik digunakan karena data tidak normal atau hubungan tidak linear"
            } else ""
          )
        })
        
        # -----------------------------------------------------------------------
        # 9.1.4 Interpretasi
        # -----------------------------------------------------------------------
        
        # Memberikan interpretasi dan kesimpulan uji hipotesis yang mudah dipahami
        output$hypothesis_conclusion <- renderText({
          
          # Menentukan kekuatan korelasi berdasarkan nilai absolut koefisien
          strength <- case_when(
            abs(cor_test$estimate) >= 0.7 ~ "sangat kuat",
            abs(cor_test$estimate) >= 0.5 ~ "kuat",
            abs(cor_test$estimate) >= 0.3 ~ "sedang",
            TRUE ~ "lemah"
          )
          
          # Menentukan arah korelasi
          direction <- ifelse(cor_test$estimate > 0, "positif", "negatif")
          
          # Menentukan signifikansi berdasarkan alpha yang dipilih user
          significance <- ifelse(cor_test$p.value < input$alpha, "signifikan", "tidak signifikan")
          
          # Keputusan hipotesis berdasarkan p-value vs alpha
          decision <- ifelse(cor_test$p.value < input$alpha, "TOLAK H₀", "GAGAL TOLAK H₀")
          
          # Menyusun kesimpulan lengkap
          paste(
            "KESIMPULAN UJI HIPOTESIS:\n",
            "========================\n\n",
            "Keputusan:", decision, "\n",
            "Hubungan", strength, "dan", direction, "\n",
            "Signifikansi (α=", input$alpha, "):", significance, "\n\n",
            
            # Penjelasan berdasarkan metode yang digunakan
            if(input$cor_method_hyp != "pearson") {
              paste("METODE NON-PARAMETRIK:\n",
                    "• Mengukur hubungan monotonik (tidak harus linear)\n",
                    "• Lebih robust terhadap outlier dan data tidak normal\n\n")
            } else {
              paste("ASUMSI PEARSON:\n",
                    "• Hubungan linear antara variabel\n",
                    "• Data berdistribusi normal (disarankan cek dengan uji Shapiro-Wilk)\n\n")
            },
            
            # Interpretasi kontekstual khusus untuk sea level
            "INTERPRETASI:\n",
            if(significance == "signifikan") {
              paste("Terdapat bukti statistik yang", 
                    ifelse(strength %in% c("kuat", "sangat kuat"), "kuat", "cukup"),
                    "bahwa Total Global", input$hyp_var1, 
                    ifelse(direction == "positif", "berhubungan positif", "berhubungan negatif"),
                    "dengan Sea Level.\n\n",
                    "IMPLIKASI:\n",
                    "• Sea Level merupakan variabel global yang kompleks\n",
                    "• Hubungan ini menunjukkan pengaruh yang perlu dipertimbangkan\n",
                    "• Analisis lebih lanjut diperlukan untuk memahami mekanisme kausal")
            } else {
              paste("Tidak cukup bukti untuk menyatakan hubungan signifikan antara",
                    "Total Global", input$hyp_var1, "dan Sea Level pada tingkat signifikansi α =", input$alpha, "\n\n",
                    "REKOMENDASI:\n",
                    "• Pertimbangkan rentang waktu yang berbeda\n",
                    "• Evaluasi faktor-faktor lain yang mempengaruhi Sea Level\n",
                    "• Gunakan metode analisis yang lebih kompleks jika diperlukan")
            }
          )
        })
        
      }, error = function(e) {
        # -----------------------------------------------------------------------
        # 9.1.5 Error
        # -----------------------------------------------------------------------
        
        # Menampilkan pesan error yang informatif untuk sea level
        output$hypothesis_result <- renderText({
          paste("ERROR:", e$message, "\n",
                "Pastikan:\n",
                "1. Data tersedia untuk periode ini\n",
                "2. Variabel mengandung nilai numerik\n",
                "3. Tidak ada missing values yang mengganggu")
        })
        
        # Menampilkan pesan error untuk kesimpulan
        output$hypothesis_conclusion <- renderText({
          "Kesimpulan tidak tersedia karena error dalam analisis data"
        })
      })
      
      # -----------------------------------------------------------------------
      # 9.2 Uji hipotesis biasa
      # -----------------------------------------------------------------------
      
      # Penanganan untuk uji hipotesis antara dua variabel reguler (bukan sea level)
    } else {
      
      # Blok try-catch untuk menangani error dalam analisis variabel reguler
      tryCatch({
        
        # -----------------------------------------------------------------------
        # 9.2.1 Persiapan data
        # -----------------------------------------------------------------------
        
        # Memfilter dan mempersiapkan data untuk analisis variabel reguler
        filtered_data <- rv$data_with_sealevel %>%
          # Filter berdasarkan rentang tahun yang dipilih user
          filter(year >= input$hyp_year_filter[1] & year <= input$hyp_year_filter[2]) %>%
          # Memilih hanya dua variabel yang akan diuji
          select(!!sym(input$hyp_var1), !!sym(input$hyp_var2)) %>%
          # Menghapus baris dengan nilai NA
          filter(complete.cases(.)) %>%
          # Menghapus nilai infinite jika ada
          filter_if(is.numeric, all_vars(!is.infinite(.)))
        
        # Validasi jumlah data minimum untuk uji hipotesis
        if(nrow(filtered_data) < 3) {
          stop("Data tidak cukup (minimal 3 observasi diperlukan)")
        }
        
        # -----------------------------------------------------------------------
        # 9.2.2 Uji
        # -----------------------------------------------------------------------
        
        # Melakukan uji korelasi dengan parameter yang ditentukan user
        cor_test <- cor.test(
          x = filtered_data[[1]],              # Variabel pertama (X)
          y = filtered_data[[2]],              # Variabel kedua (Y)
          method = input$cor_method_hyp,       # Metode korelasi
          exact = FALSE,                       # Aproksimasi untuk sampel besar
          conf.level = 1 - input$alpha         # Tingkat confidence
        )
        
        # -----------------------------------------------------------------------
        # 9.2.3 Hasil
        # -----------------------------------------------------------------------
        
        # Menampilkan hasil numerik uji hipotesis untuk variabel reguler
        output$hypothesis_result <- renderText({
          paste(
            "HASIL UJI HIPOTESIS", toupper(input$cor_method_hyp), "\n",
            "==============================\n\n",
            "Variabel X:", input$hyp_var1, "\n",
            "Variabel Y:", input$hyp_var2, "\n\n",
            "Koefisien Korelasi:", round(cor_test$estimate, 4), "\n",
            "p-value:", format.pval(cor_test$p.value, digits = 3), "\n",
            
            # Informasi tambahan untuk metode Pearson
            if(input$cor_method_hyp == "pearson") {
              paste("Confidence Interval", (1-input$alpha)*100, "%:", 
                    round(cor_test$conf.int[1], 4), "-", 
                    round(cor_test$conf.int[2], 4), "\n",
                    "t-statistic:", round(cor_test$statistic, 4), "\n",
                    "df:", cor_test$parameter, "\n")
            } else {
              paste("Metode non-parametrik tidak menghitung confidence interval\n")
            },
            
            "Jumlah Sampel:", nrow(filtered_data), "\n",
            "Periode analisis:", input$hyp_year_filter[1], "-", input$hyp_year_filter[2], "\n",
            "Tingkat Signifikansi (α):", input$alpha, "\n\n",
            
            # Catatan untuk metode non-parametrik
            if(input$cor_method_hyp != "pearson") {
              "CATATAN: Metode non-parametrik digunakan karena data tidak normal atau hubungan tidak linear"
            } else ""
          )
        })
        
        # -----------------------------------------------------------------------
        # 9.2.4 Interpretasi
        # -----------------------------------------------------------------------
        
        # Memberikan interpretasi dan kesimpulan untuk variabel reguler
        output$hypothesis_conclusion <- renderText({
          
          # Menentukan kekuatan korelasi
          strength <- case_when(
            abs(cor_test$estimate) >= 0.7 ~ "sangat kuat",
            abs(cor_test$estimate) >= 0.5 ~ "kuat",
            abs(cor_test$estimate) >= 0.3 ~ "sedang",
            TRUE ~ "lemah"
          )
          
          # Menentukan arah korelasi
          direction <- ifelse(cor_test$estimate > 0, "positif", "negatif")
          
          # Menentukan signifikansi statistik
          significance <- ifelse(cor_test$p.value < input$alpha, "signifikan", "tidak signifikan")
          
          # Keputusan hipotesis
          decision <- ifelse(cor_test$p.value < input$alpha, "TOLAK H₀", "GAGAL TOLAK H₀")
          
          # Menyusun kesimpulan lengkap untuk variabel reguler
          paste(
            "KESIMPULAN UJI HIPOTESIS:\n",
            "========================\n\n",
            "Keputusan:", decision, "\n",
            "Hubungan", strength, "dan", direction, "\n",
            "Signifikansi (α=", input$alpha, "):", significance, "\n\n",
            
            # Penjelasan berdasarkan metode yang digunakan
            if(input$cor_method_hyp != "pearson") {
              paste("METODE NON-PARAMETRIK:\n",
                    "• Mengukur hubungan monotonik (tidak harus linear)\n",
                    "• Lebih robust terhadap outlier dan data tidak normal\n",
                    "• Berdasarkan ranking data, bukan nilai aktual\n\n")
            } else {
              paste("ASUMSI PEARSON:\n",
                    "• Hubungan linear antara variabel\n",
                    "• Data berdistribusi normal (disarankan cek dengan uji Shapiro-Wilk)\n\n")
            },
            
            # Interpretasi kontekstual untuk variabel reguler
            "INTERPRETASI:\n",
            if(significance == "signifikan") {
              paste("Terdapat bukti statistik yang", 
                    ifelse(strength %in% c("kuat", "sangat kuat"), "kuat", "cukup"),
                    "bahwa", input$hyp_var1, 
                    ifelse(direction == "positif", "berhubungan positif", "berhubungan negatif"),
                    "dengan", input$hyp_var2, ".\n\n",
                    "REKOMENDASI:\n",
                    if(abs(cor_test$estimate) >= 0.5) {
                      "Korelasi cukup kuat untuk dipertimbangkan dalam analisis lebih lanjut dan pengambilan keputusan."
                    } else {
                      "Meskipun signifikan, korelasi relatif lemah. Pertimbangkan variabel lain yang mungkin berpengaruh."
                    })
            } else {
              paste("Tidak cukup bukti untuk menyatakan hubungan signifikan antara",
                    input$hyp_var1, "dan", input$hyp_var2, "pada tingkat signifikansi α =", input$alpha, "\n\n",
                    "REKOMENDASI:\n",
                    "1. Pertimbangkan rentang waktu yang berbeda\n",
                    "2. Evaluasi variabel lain yang mungkin berpengaruh\n",
                    "3. Periksa asumsi metode statistik yang digunakan\n",
                    "4. Pertimbangkan menggunakan tingkat signifikansi yang berbeda")
            }
          )
        })
        
      }, error = function(e) {
        # -----------------------------------------------------------------------
        # 9.2.5 Error
        # -----------------------------------------------------------------------
        
        # Menampilkan pesan error yang informatif untuk variabel reguler
        output$hypothesis_result <- renderText({
          paste("ERROR:", e$message, "\n",
                "Pastikan:\n",
                "1. Data tersedia untuk periode ini\n",
                "2. Variabel mengandung nilai numerik\n",
                "3. Tidak ada missing values yang mengganggu")
        })
        
        # Menampilkan pesan error untuk kesimpulan
        output$hypothesis_conclusion <- renderText({
          "Kesimpulan tidak tersedia karena error dalam analisis data"
        })
      })
    }
  })
  
  # -----------------------------------------------------------------------
  # 10. Global
  # -----------------------------------------------------------------------
  # -----------------------------------------------------------------------
  # 10.1 Scatter Plot
  # -----------------------------------------------------------------------
  
  # Plot scatter untuk menampilkan hubungan antara CO2 Global dan Sea Level
  output$global_co2_sealevel <- renderPlotly({
    # Validasi data: Memastikan data sudah dimuat sebelum membuat plot
    # req() akan membatalkan eksekusi jika kondisi tidak terpenuhi
    req(rv$data_loaded)
    
    # Membuat plot dasar menggunakan ggplot2
    # Menampilkan hubungan antara total CO2 global (sumbu x) dengan sea level (sumbu y)
    p <- ggplot(rv$data_global_yearly, aes(x = total_co2, y = Sea_level)) +
      # Menambahkan titik-titik data dengan warna biru steel dan ukuran 3
      geom_point(color = "steelblue", size = 3) +
      # Menambahkan garis regresi linear dengan confidence interval (se = TRUE)
      # Garis berwarna merah untuk menunjukkan tren hubungan
      geom_smooth(method = "lm", color = "red", se = TRUE) +
      # Memberikan judul dan label sumbu yang informatif
      labs(title = "CO2 Global vs Sea Level",
           x = "Total CO2 Global (Mt)", y = "Sea Level (mm)") +
      # Menggunakan tema minimal untuk tampilan yang bersih
      theme_minimal()
    
    # Mengkonversi plot ggplot menjadi plot interaktif menggunakan plotly
    # Ini memungkinkan user untuk zoom, hover, dan interaksi lainnya
    ggplotly(p)
  })
  
  # Plot scatter untuk menampilkan hubungan antara Suhu Global dan Sea Level
  output$global_temp_sealevel <- renderPlotly({
    # Validasi data: Memastikan data sudah dimuat sebelum membuat plot
    req(rv$data_loaded)
    
    # Membuat plot dasar menggunakan ggplot2
    # Menampilkan hubungan antara perubahan suhu global (sumbu x) dengan sea level (sumbu y)
    p <- ggplot(rv$data_global_yearly, aes(x = avg_temp_change, y = Sea_level)) +
      # Menambahkan titik-titik data dengan warna orange dan ukuran 3
      # Warna berbeda untuk membedakan dari plot CO2
      geom_point(color = "orange", size = 3) +
      # Menambahkan garis regresi linear dengan confidence interval
      # Garis merah konsisten dengan plot sebelumnya
      geom_smooth(method = "lm", color = "red", se = TRUE) +
      # Memberikan judul dan label sumbu yang sesuai dengan data suhu
      labs(title = "Suhu Global vs Sea Level",
           x = "Rata-rata Perubahan Suhu Global (°C)", y = "Sea Level (mm)") +
      # Menggunakan tema minimal untuk konsistensi tampilan
      theme_minimal()
    
    # Mengkonversi ke plot interaktif plotly
    ggplotly(p)
  })
  
  # -----------------------------------------------------------------------
  # 10.2 Statistik
  # -----------------------------------------------------------------------
  
  # Output teks yang menampilkan analisis korelasi antara variabel global
  output$global_correlation <- renderText({
    # Validasi data sebelum melakukan perhitungan
    req(rv$data_loaded)
    
    # Menghitung korelasi Pearson antara CO2 global dan sea level
    # use = "complete.obs" mengabaikan nilai NA dalam perhitungan
    cor_co2_sea <- cor(rv$data_global_yearly$total_co2, 
                       rv$data_global_yearly$Sea_level, 
                       use = "complete.obs")
    
    # Menghitung korelasi Pearson antara perubahan suhu global dan sea level
    # Menggunakan parameter yang sama untuk konsistensi
    cor_temp_sea <- cor(rv$data_global_yearly$avg_temp_change, 
                        rv$data_global_yearly$Sea_level, 
                        use = "complete.obs")
    
    # Membuat output teks terformat yang menampilkan hasil korelasi
    # Menggunakan paste() untuk menggabungkan string dengan format yang rapi
    paste("KORELASI GLOBAL + SEA LEVEL\n",
          "===========================\n\n",
          # Menampilkan korelasi CO2-Sea Level dengan pembulatan 4 desimal
          "CO2 Global vs Sea Level:", round(cor_co2_sea, 4), "\n",
          # Menampilkan korelasi Suhu-Sea Level dengan pembulatan 4 desimal
          "Suhu Global vs Sea Level:", round(cor_temp_sea, 4), "\n\n",
          # Menampilkan ukuran sampel untuk validitas statistik
          "Sample size:", nrow(rv$data_global_yearly), "tahun\n",
          # Menampilkan periode data untuk konteks temporal
          "Periode: 1993-2023")
  })
  
  # -----------------------------------------------------------------------
  # 10.3 Statistik Desakriptif
  # -----------------------------------------------------------------------
  
  # Output teks yang menampilkan statistik deskriptif dari data global
  output$global_stats <- renderText({
    # Validasi data sebelum melakukan perhitungan statistik
    req(rv$data_loaded)
    
    # Membuat ringkasan statistik deskriptif menggunakan paste()
    # Setiap perhitungan menggunakan na.rm = TRUE untuk mengatasi nilai missing
    paste("STATISTIK DATA GLOBAL\n",
          "====================\n\n",
          # Menghitung dan menampilkan rata-rata CO2 global dengan 2 desimal
          "Rata-rata CO2 Global:", round(mean(rv$data_global_yearly$total_co2, na.rm = TRUE), 2), "Mt\n",
          # Menghitung dan menampilkan rata-rata perubahan suhu dengan 3 desimal (lebih presisi)
          "Rata-rata Suhu Global:", round(mean(rv$data_global_yearly$avg_temp_change, na.rm = TRUE), 3), "°C\n",
          # Menghitung dan menampilkan rata-rata sea level dengan 2 desimal
          "Rata-rata Sea Level:", round(mean(rv$data_global_yearly$Sea_level, na.rm = TRUE), 2), "mm\n\n",
          # Menghitung total kenaikan sea level selama periode pengamatan
          # Menggunakan selisih antara nilai maksimum dan minimum
          "Tren Sea Level:", round(max(rv$data_global_yearly$Sea_level, na.rm = TRUE) - 
                                     min(rv$data_global_yearly$Sea_level, na.rm = TRUE), 2), "mm kenaikan")
  })
  
  # -----------------------------------------------------------------------
  # 11. Map Interaktif
  # -----------------------------------------------------------------------
  # -----------------------------------------------------------------------
  # 11.1 Persiapan data
  # -----------------------------------------------------------------------
  # Reactive expression untuk mempersiapkan data yang akan ditampilkan di peta
  # Menggabungkan data iklim dengan koordinat geografis negara
  map_data_reactive <- reactive({
    # Validasi data: Memastikan semua data yang diperlukan sudah dimuat
    # dan input tahun sudah dipilih oleh user
    req(rv$data_loaded, rv$data_with_sealevel, rv$data_negara, input$map_year)
    
    # Filter data iklim berdasarkan tahun yang dipilih user
    # Mengambil data untuk satu tahun spesifik dari dataset lengkap
    climate_year_data <- rv$data_with_sealevel %>% 
      filter(year == input$map_year)
    
    # Menggabungkan data negara (dengan koordinat) dengan data iklim
    # left_join mempertahankan semua negara dan menambahkan data iklim jika tersedia
    map_data <- rv$data_negara %>%
      left_join(climate_year_data, by = c("FULL_NAME" = "country")) %>%
      # Filter hanya negara yang memiliki koordinat valid (lat dan lng tidak NA)
      filter(!is.na(lat), !is.na(lng))
    
    # Konversi koordinat ke format numerik dan validasi ulang
    # Memastikan koordinat dalam format yang benar untuk plotting
    map_data <- map_data %>%
      mutate(
        lat = as.numeric(lat),   # Konversi latitude ke numerik
        lng = as.numeric(lng)    # Konversi longitude ke numerik
      ) %>%
      # Filter sekali lagi untuk memastikan tidak ada koordinat NA setelah konversi
      filter(!is.na(lat), !is.na(lng))
    
    # Mengembalikan data yang sudah diproses
    return(map_data)
  })
  
  # Observer untuk memperbarui pilihan negara berdasarkan data yang tersedia
  # Berjalan otomatis ketika map_data_reactive() berubah
  observe({
    # Memastikan data reaktif sudah tersedia
    req(map_data_reactive())
    
    # Mengambil daftar negara yang memiliki data valid untuk variabel yang dipilih
    # Menghindari nilai NA dan infinite dalam data
    available_countries <- map_data_reactive() %>%
      filter(!is.na(!!sym(input$map_variable)), !is.infinite(!!sym(input$map_variable))) %>%
      arrange(FULL_NAME) %>%              # Mengurutkan nama negara secara alfabetis
      pull(FULL_NAME) %>%                 # Mengambil kolom nama negara
      unique()                            # Menghilangkan duplikasi
    
    # Memperbarui pilihan dropdown negara di UI
    # Menambahkan opsi "Tampilkan Semua" di awal daftar
    updateSelectInput(session, "selected_country",
                      choices = c("Tampilkan Semua" = "all", 
                                  setNames(available_countries, available_countries)),
                      selected = "all")
  })
  
  # -----------------------------------------------------------------------
  # 11.2 Statistik
  # -----------------------------------------------------------------------
  
  # Output teks yang menampilkan statistik ringkas dari data peta
  output$map_stats <- renderText({
    # Validasi ketersediaan data
    req(map_data_reactive())
    
    # Mengambil data dari reactive expression
    map_data <- map_data_reactive()
    
    # Memeriksa apakah variabel yang dipilih tersedia dalam dataset
    if(input$map_variable %in% names(map_data)) {
      # Filter data untuk mendapatkan nilai yang valid (tidak NA dan tidak infinite)
      valid_data <- map_data %>%
        filter(!is.na(!!sym(input$map_variable)), !is.infinite(!!sym(input$map_variable)))
      
      # Jika ada data valid, hitung dan tampilkan statistik
      if(nrow(valid_data) > 0) {
        # Ekstrak nilai variabel untuk perhitungan statistik
        var_data <- valid_data[[input$map_variable]]
        
        # Membuat output teks dengan statistik deskriptif
        paste("Tahun:", input$map_year, "\n",
              "Negara terpetakan:", nrow(valid_data), "\n",
              "Min:", round(min(var_data, na.rm = TRUE), 2), "\n",
              "Max:", round(max(var_data, na.rm = TRUE), 2), "\n",
              "Rata-rata:", round(mean(var_data, na.rm = TRUE), 2))
      } else {
        # Pesan jika tidak ada data valid
        paste("Tahun:", input$map_year, "\n",
              "Tidak ada data valid untuk variabel ini")
      }
    } else {
      # Pesan jika variabel tidak tersedia dalam dataset
      paste("Tahun:", input$map_year, "\n",
            "Variabel tidak tersedia")
    }
  })
  
  # -----------------------------------------------------------------------
  # 11.2 Render
  # -----------------------------------------------------------------------
  
  # Fungsi utama untuk menghasilkan peta interaktif menggunakan Leaflet
  output$climate_map <- renderLeaflet({
    # Validasi ketersediaan data
    req(map_data_reactive())
    
    # Mengambil data yang sudah diproses
    map_data <- map_data_reactive()
    
    # === VALIDASI DATA DAN ERROR HANDLING ===
    
    # Jika tidak ada data sama sekali, tampilkan peta kosong dengan pesan
    if(nrow(map_data) == 0) {
      return(leaflet() %>% 
               addTiles() %>% 
               setView(lng = 0, lat = 20, zoom = 2) %>%
               addMarkers(lng = 0, lat = 0, popup = "Tidak ada data untuk tahun ini"))
    }
    
    # Jika variabel yang dipilih tidak ada dalam dataset
    if(!(input$map_variable %in% names(map_data))) {
      return(leaflet() %>% 
               addTiles() %>% 
               setView(lng = 0, lat = 20, zoom = 2) %>%
               addMarkers(lng = 0, lat = 0, popup = "Variabel tidak tersedia"))
    }
    
    # === PREPROCESSING KOORDINAT ===
    
    # Membersihkan dan memvalidasi koordinat geografis
    map_data <- map_data %>%
      mutate(
        # Konversi koordinat ke numerik dengan handling untuk berbagai format
        lat = as.numeric(as.character(lat)),
        lng = as.numeric(as.character(lng))
      ) %>%
      # Filter koordinat yang valid dalam rentang geografis yang masuk akal
      filter(!is.na(lat), !is.na(lng),
             lat >= -90, lat <= 90,        # Validasi latitude
             lng >= -180, lng <= 180)      # Validasi longitude
    
    # === PREPROCESSING NILAI VARIABEL ===
    
    # Memproses nilai variabel yang akan ditampilkan
    if(input$map_variable %in% names(map_data)) {
      map_data <- map_data %>%
        mutate(
          # Konversi nilai variabel ke numerik dan beri nama standar
          map_value = as.numeric(as.character(!!sym(input$map_variable)))
        ) %>%
        # Filter nilai yang valid (tidak NA dan tidak infinite)
        filter(!is.na(map_value), !is.infinite(map_value))
    } else {
      # Jika variabel tidak ditemukan, return peta kosong
      return(leaflet() %>% addTiles() %>% setView(lng = 0, lat = 20, zoom = 2))
    }
    
    # Jika setelah filtering tidak ada data valid
    if(nrow(map_data) == 0) {
      return(leaflet() %>% 
               addTiles() %>% 
               setView(lng = 0, lat = 20, zoom = 2) %>%
               addMarkers(lng = 0, lat = 0, popup = "Tidak ada data valid untuk variabel ini"))
    }
    
    # === VALIDASI DISTRIBUSI DATA ===
    
    # Ekstrak dan validasi nilai untuk pewarnaan
    var_values <- map_data$map_value
    var_values <- var_values[!is.na(var_values) & !is.infinite(var_values) & is.finite(var_values)]
    
    # Jika data tidak cukup untuk visualisasi (kurang dari 2 nilai unik)
    if(length(var_values) == 0 || length(unique(var_values)) < 2) {
      return(leaflet() %>% 
               addTiles() %>% 
               setView(lng = 0, lat = 20, zoom = 2) %>%
               addMarkers(lng = 0, lat = 0, popup = "Data tidak cukup untuk visualisasi"))
    }
    
    # === KONFIGURASI SKEMA WARNA ===
    
    # Menentukan palet warna berdasarkan pilihan user
    if(input$color_scheme == "heat") {
      # Skema warna panas: putih ke merah gelap
      colors <- c("#FFF5F0", "#FEE0D2", "#FCBBA1", "#FC9272", "#FB6A4A", "#EF3B2C", "#CB181D", "#A50F15", "#67000D")
    } else if(input$color_scheme == "ocean") {
      # Skema warna laut: putih ke biru gelap
      colors <- c("#F7FBFF", "#DEEBF7", "#C6DBEF", "#9ECAE1", "#6BAED6", "#4292C6", "#2171B5", "#08519C", "#08306B")
    } else if(input$color_scheme == "viridis") {
      # Skema warna viridis: colorblind-friendly
      colors <- viridis(9)
    } else if(input$color_scheme == "green") {
      # Skema warna hijau: putih ke hijau gelap
      colors <- c("#F7FCF0", "#E0F3DB", "#CCEBC5", "#A8DDB5", "#7BCCC4", "#4EB3D3", "#2B8CBE", "#0868AC", "#084081")
    } else {
      # Default ke skema panas
      colors <- c("#FFF5F0", "#FEE0D2", "#FCBBA1", "#FC9272", "#FB6A4A", "#EF3B2C", "#CB181D", "#A50F15", "#67000D")
    }
    
    # Membuat palet warna numerik dengan error handling
    tryCatch({
      pal <- colorNumeric(colors, domain = range(var_values, na.rm = TRUE), na.color = "transparent")
    }, error = function(e) {
      # Fallback ke palet biru jika ada error
      pal <- colorNumeric("Blues", domain = range(var_values, na.rm = TRUE), na.color = "transparent")
    })
    
    # === KONFIGURASI METADATA VARIABEL ===
    
    # Definisi metadata untuk setiap variabel (judul, unit, icon)
    var_settings <- list(
      co2 = list(title = "Emisi CO2", unit = " Mt"),
      population = list(title = "Populasi", unit = ""),
      temp_change = list(title = "Perubahan Suhu", unit = "°C"),
      co2_per_capita = list(title = "CO2 per Kapita", unit = " ton"),
      Sea_level = list(title = "Ketinggian Air Laut", unit = " mm")
    )
    
    # Mengambil metadata untuk variabel yang dipilih
    current_var <- var_settings[[input$map_variable]]
    if(is.null(current_var)) {
      # Default metadata jika variabel tidak terdefinisi
      current_var <- list(title = input$map_variable, unit = "")
    }
    
    # === KONFIGURASI VIEW PETA ===
    
    # Menentukan center dan zoom level berdasarkan negara yang dipilih
    if(!is.null(input$selected_country) && input$selected_country != "all") {
      # Jika negara spesifik dipilih, fokus ke negara tersebut
      selected_data <- map_data %>% filter(FULL_NAME == input$selected_country)
      if(nrow(selected_data) > 0) {
        center_lat <- selected_data$lat[1]    # Latitude negara
        center_lng <- selected_data$lng[1]    # Longitude negara
        zoom_level <- 6                       # Zoom lebih dekat
      } else {
        # Fallback jika negara tidak ditemukan
        center_lat <- 20
        center_lng <- 0
        zoom_level <- 2
      }
    } else {
      # View global untuk "Tampilkan Semua"
      center_lat <- 20
      center_lng <- 0
      zoom_level <- 2
    }
    
    # === INISIALISASI BASE MAP ===
    
    # Membuat peta dasar dengan view yang sudah ditentukan
    base_map <- leaflet(map_data) %>% 
      setView(lng = center_lng, lat = center_lat, zoom = zoom_level)
    
    # Menambahkan tile layer berdasarkan style yang dipilih user
    if(input$map_style == "satellite") {
      # Peta satelit dari Esri
      base_map <- base_map %>% 
        addProviderTiles(providers$Esri.WorldImagery)
    } else if(input$map_style == "terrain") {
      # Peta topografi dari Esri
      base_map <- base_map %>% 
        addProviderTiles(providers$Esri.WorldTopoMap)
    } else {
      # Default OpenStreetMap tiles
      base_map <- base_map %>% addTiles()
    }
    
    # === RENDERING MARKERS DAN LEGENDA ===
    
    # Menambahkan circle markers dan legenda dengan error handling
    tryCatch({
      base_map %>%
        addCircleMarkers(
          lng = ~lng,                       # Longitude untuk posisi marker
          lat = ~lat,                       # Latitude untuk posisi marker
          # Radius dinamis berdasarkan nilai variabel (5-30 pixel)
          radius = ~pmax(5, pmin(30, sqrt(abs(map_value)) * 2)),
          fillColor = ~pal(map_value),      # Warna fill berdasarkan nilai
          color = "white",                  # Warna border putih
          weight = 2,                       # Ketebalan border
          opacity = 0.8,                    # Transparansi border
          fillOpacity = 0.7,                # Transparansi fill
          # Popup informasi detail untuk setiap marker
          popup = ~paste(
            "<div style='font-family: Arial; font-size: 12px;'>",
            "<h4 style='margin: 5px 0; color: #2c3e50;'>", current_var$icon, " ", FULL_NAME, "</h4>",
            "<hr style='margin: 5px 0;'>",
            "<b>Tahun:</b> ", input$map_year, "<br>",
            "<b>", current_var$title, ":</b> ", 
            format(round(map_value, 2), big.mark = ","), current_var$unit, "<br>",
            # Catatan khusus untuk Sea Level (sama untuk semua negara)
            if(input$map_variable == "Sea_level") "<b>Catatan:</b> Sea Level sama untuk semua negara<br>" else "",
            "</div>"
          )
        ) %>%
        # Menambahkan legenda di pojok kanan bawah
        addLegend(
          pal = pal,                        # Palet warna yang digunakan
          values = ~map_value,              # Nilai untuk skala legenda
          title = paste(current_var$icon, current_var$title),  # Judul legenda
          position = "bottomright",         # Posisi legenda
          opacity = 0.8                     # Transparansi legenda
        )
    }, error = function(e) {
      # Error handling: tampilkan peta kosong dengan pesan error
      leaflet() %>% 
        addTiles() %>% 
        setView(lng = 0, lat = 20, zoom = 2) %>%
        addMarkers(lng = 0, lat = 0, popup = paste("Error rendering map:", e$message))
    })
  })
  
  # -----------------------------------------------------------------------
  # 12. Data Lengkap
  # -----------------------------------------------------------------------
  # -----------------------------------------------------------------------
  # 12.1 Tabel data
  # -----------------------------------------------------------------------
  # Render tabel interaktif untuk menampilkan dataset lengkap dengan sea level
  # Menggabungkan data iklim negara dengan data sea level global
  output$data_table <- DT::renderDataTable({
    # Validasi data: Memastikan semua data sudah berhasil dimuat sebelum rendering
    # req() akan menghentikan eksekusi jika kondisi tidak terpenuhi
    req(rv$data_loaded)
    
    # Membuat DataTable interaktif menggunakan package DT
    # rv$data_with_sealevel adalah dataset gabungan data iklim + sea level
    DT::datatable(rv$data_with_sealevel, 
                  # Konfigurasi opsi untuk fungsionalitas tabel
                  options = list(
                    # scrollX = TRUE: Mengaktifkan scroll horizontal untuk tabel lebar
                    # Penting untuk dataset dengan banyak kolom agar tetap dapat diakses
                    scrollX = TRUE,
                    
                    # pageLength = 15: Menampilkan 15 baris per halaman
                    # Memberikan keseimbangan antara overview data dan performa loading
                    pageLength = 15,
                    
                    # dom = 'Bfrtip': Mengatur layout elemen tabel
                    # B = Buttons, f = filter, r = processing, t = table, i = info, p = pagination
                    dom = 'Bfrtip',
                    
                    # buttons: Menambahkan tombol export dalam berbagai format
                    # Memungkinkan user untuk mengunduh data dalam format yang diinginkan
                    buttons = c('copy',    # Copy ke clipboard
                                'csv',     # Export ke CSV
                                'excel',   # Export ke Excel
                                'pdf',     # Export ke PDF
                                'print')   # Print tabel
                  ),
                  # extensions = 'Buttons': Mengaktifkan ekstensi Buttons untuk fitur export
                  # Diperlukan untuk menampilkan dan mengaktifkan tombol export
                  extensions = 'Buttons',
                  
                  # caption: Memberikan judul/deskripsi pada tabel
                  # Memberikan konteks tentang isi dan periode data
                  caption = "Data Lengkap dengan Sea Level (1993-2023)")
  })
  
  # -----------------------------------------------------------------------
  # 12.2 Tabel data global
  # -----------------------------------------------------------------------
  
  # Render tabel interaktif untuk menampilkan data global yang sudah diagregasi
  # Menampilkan statistik iklim global per tahun dalam format yang lebih ringkas
  output$global_data_table <- DT::renderDataTable({
    # Validasi data: Memastikan data global sudah berhasil dimuat dan diproses
    req(rv$data_loaded)
    
    # Membuat DataTable untuk data global yang sudah diagregasi per tahun
    # rv$data_global_yearly berisi rata-rata/total global untuk setiap tahun
    DT::datatable(rv$data_global_yearly, 
                  # Konfigurasi opsi yang lebih sederhana untuk data agregat
                  options = list(
                    # scrollX = TRUE: Tetap mengaktifkan scroll horizontal
                    # Meskipun data lebih sedikit, tetap diperlukan untuk konsistensi UI
                    scrollX = TRUE,
                    
                    # pageLength = 15: Jumlah baris yang sama untuk konsistensi
                    # Data global biasanya lebih sedikit (31 tahun), tapi tetap konsisten
                    pageLength = 15
                    
                    # Tidak menggunakan buttons export pada tabel ini
                    # Fokus pada tampilan data untuk analisis visual, bukan download
                  ),
                  
                  # caption: Memberikan deskripsi yang jelas tentang data agregat
                  # Menjelaskan bahwa ini adalah data yang sudah diproses/diagregasi
                  caption = "Data Global Agregat per Tahun (1993-2023)")
  })
  
  # -----------------------------------------------------------------------
  # 13. Inferensia
  # -----------------------------------------------------------------------
  # -----------------------------------------------------------------------
  # 13.1 Uji Kenormalan
  # -----------------------------------------------------------------------
  # Event observer yang dijalankan ketika user menekan tombol "run_norm_test"
  # Melakukan analisis inferensia untuk menguji normalitas distribusi data
  observeEvent(input$run_norm_test, {
    # Validasi input: Memastikan variabel dan data sudah dipilih/dimuat
    # Mencegah error saat user belum memilih variabel atau data belum ready
    req(input$norm_var, rv$data_loaded)
    
    # === PREPROCESSING DATA UNTUK UJI NORMALITAS ===
    
    # Ekstraksi dan filtering data berdasarkan parameter yang dipilih user
    norm_data <- rv$data_with_sealevel %>%
      # Filter data berdasarkan rentang tahun yang dipilih user
      # Menggunakan slider input untuk fleksibilitas periode analisis
      filter(year >= input$norm_year_range[1] & year <= input$norm_year_range[2]) %>%
      # Memilih hanya kolom variabel yang akan diuji normalitasnya
      # !!sym() digunakan untuk evaluasi nama kolom secara dinamis
      select(!!sym(input$norm_var)) %>%
      # Menghapus nilai missing (NA) yang dapat mengganggu uji statistik
      na.omit() %>%
      # Mengkonversi ke vektor numerik untuk analisis statistik
      pull()
    
    # === VALIDASI UKURAN SAMPEL ===
    
    # Memeriksa apakah data cukup untuk melakukan uji normalitas
    # Minimal 3 observasi diperlukan untuk uji statistik yang valid
    if(length(norm_data) < 3) {
      # Menampilkan pesan peringatan jika data tidak mencukupi
      output$norm_test_result <- renderText({
        "Peringatan: Data terlalu sedikit untuk melakukan uji kenormalan (minimal 3 observasi)"
      })
      # Menghentikan eksekusi fungsi jika data tidak mencukupi
      return()
    }
    
    # === PEMILIHAN DAN EKSEKUSI UJI NORMALITAS ===
    
    # Conditional logic untuk memilih jenis uji normalitas
    if(input$norm_test == "shapiro") {
      # Uji Shapiro-Wilk: Lebih powerful tapi terbatas pada sampel ≤ 5000
      # Jika data > 5000, dilakukan random sampling untuk memenuhi batasan
      test_data <- if(length(norm_data) > 5000) sample(norm_data, 5000) else norm_data
      test_result <- shapiro.test(test_data)
      test_name <- "Shapiro-Wilk"
    } else {
      # Uji Kolmogorov-Smirnov: Dapat menangani sampel besar tanpa batasan
      # Membandingkan distribusi empiris dengan distribusi normal teoretis
      test_result <- ks.test(norm_data, "pnorm", 
                             mean = mean(norm_data), 
                             sd = sd(norm_data))
      test_name <- "Kolmogorov-Smirnov"
    }
    
    # === OUTPUT HASIL UJI STATISTIK ===
    
    # Rendering hasil uji normalitas dalam format teks yang terstruktur
    output$norm_test_result <- renderText({
      paste("HASIL UJI", toupper(test_name), "\n",
            "==========================\n\n",
            # Informasi dasar tentang analisis yang dilakukan
            "Variabel:", input$norm_var, "\n",
            "Periode:", input$norm_year_range[1], "-", input$norm_year_range[2], "\n",
            "Jumlah data:", length(norm_data), "\n",
            # Catatan khusus jika data di-sampling untuk Shapiro-Wilk
            if(input$norm_test == "shapiro" && length(norm_data) > 5000) 
              "CATATAN: Data di-sampling ke 5000 observasi\n\n" else "\n",
            # Hasil statistik uji
            "Statistik Uji:", round(test_result$statistic, 4), "\n",
            "p-value:", format.pval(test_result$p.value, digits = 4), "\n\n",
            # Interpretasi hasil berdasarkan p-value dengan α = 0.05
            "INTERPRETASI:\n",
            ifelse(test_result$p.value > 0.05,
                   "Data terdistribusi normal (tidak menolak H0)",
                   "Data TIDAK terdistribusi normal (menolak H0)"))
    })
    
    # -----------------------------------------------------------------------
    # 13.2 Plot distribusi dasar
    # -----------------------------------------------------------------------
    
    # Plot diagnostik menggunakan base R graphics
    # Menyediakan visualisasi tradisional untuk evaluasi normalitas
    output$norm_plot <- renderPlot({
      # Mengatur layout plot: 1 baris, 2 kolom untuk perbandingan
      par(mfrow = c(1, 2))
      
      # Plot 1: Histogram untuk melihat bentuk distribusi data
      hist(norm_data, 
           main = paste("Histogram", input$norm_var),  # Judul dinamis
           xlab = input$norm_var,                      # Label sumbu x
           col = "skyblue",                            # Warna fill biru muda
           border = "white")                           # Border putih untuk estetika
      
      # Plot 2: Q-Q Plot untuk membandingkan dengan distribusi normal
      qqnorm(norm_data, main = "Normal Q-Q Plot")
      # Menambahkan garis referensi normal (warna merah)
      qqline(norm_data, col = "red")
    })
    
    # -----------------------------------------------------------------------
    # 13.3 Plot distribusi lanjutan
    # -----------------------------------------------------------------------
    
    # Plot distribusi yang lebih sophisticated menggunakan ggplot2 + plotly
    output$dist_plot <- renderPlotly({
      # Membuat data frame untuk kompatibilitas dengan ggplot2
      df <- data.frame(value = norm_data)
      
      # Membuat plot distribusi dengan multiple layers
      p <- ggplot(df, aes(x = value)) +
        # Layer 1: Histogram dengan density scaling
        # ..density.. mengkonversi count ke density untuk perbandingan dengan kurva
        geom_histogram(aes(y = ..density..), 
                       bins = 30,                    # 30 bins untuk detail yang cukup
                       fill = "steelblue",           # Warna konsisten dengan theme
                       alpha = 0.7) +               # Transparansi untuk overlay
        
        # Layer 2: Kurva density empiris (estimasi dari data)
        geom_density(color = "red",                  # Warna merah untuk kontras
                     size = 1) +                     # Ketebalan garis
        
        # Layer 3: Kurva distribusi normal teoretis untuk perbandingan
        stat_function(fun = dnorm,                   # Fungsi distribusi normal
                      args = list(mean = mean(norm_data),    # Parameter mean dari data
                                  sd = sd(norm_data)),        # Parameter sd dari data
                      color = "green",               # Warna hijau untuk pembedaan
                      size = 1,                      # Ketebalan garis
                      linetype = "dashed") +         # Garis putus-putus
        
        # Kustomisasi labels dan judul
        labs(title = paste("Distribusi", input$norm_var),
             subtitle = paste("Periode:", input$norm_year_range[1], "-", input$norm_year_range[2]),
             x = input$norm_var, 
             y = "Density") +
        
        # Menggunakan tema minimal untuk tampilan bersih
        theme_minimal()
      
      # Mengkonversi ggplot ke plotly untuk interaktivitas
      # Memungkinkan zoom, hover, dan interaksi mouse lainnya
      ggplotly(p)
    })
  })
}

# -----------------------------------------------------------------------
# Aplikasi
# -----------------------------------------------------------------------
# Menggabungkan semua fungsi analisis dalam satu aplikasi web interaktif

shinyApp(ui = ui, server = server)