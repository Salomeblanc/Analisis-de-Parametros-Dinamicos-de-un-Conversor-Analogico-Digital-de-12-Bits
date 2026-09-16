# Analisis-de-Parametros-Dinamicos-de-un-Conversor-Analogico-Digital-de-12-Bits

**Raspberry Pi Pico 2 W (RP2350)** · Caracterización dinámica de ADC mediante FFT

Laboratorio de la asignatura **Comunicaciones Digitales** — Programa de Ingeniería en Telecomunicaciones, Universidad Militar Nueva Granada.

## Autores

- Bohorquez Blanco Salome — 1401654
- 
- Riveros Sierra Harol Felipe — 1401660

**Docente:** Ing. José de Jesús Rugeles Uribe

## Descripción

Este laboratorio caracteriza dinámicamente el ADC de 12 bits integrado en el microcontrolador **RP2350** (Raspberry Pi Pico 2 W), a partir del muestreo de una señal senoidal de referencia y el análisis espectral vía FFT. El trabajo se desarrolla en dos fases:

- **Fase 1 — Verificación de la frecuencia de muestreo:** se comprueba, con osciloscopio e instrumentación digital, la frecuencia de muestreo (Fs) reportada por el software, su estabilidad temporal (jitter) y el cumplimiento del criterio de Nyquist.
- **Fase 2 — Caracterización dinámica del ADC:** se adquieren registros de N = 128 a 1024 muestras de la señal de referencia (250 Hz) y se calculan, a partir de la FFT, las métricas dinámicas SNR, THD, SINAD, ENOB, SFDR y el piso de ruido espectral, contrastando los resultados contra los límites teóricos de un ADC ideal de 12 bits según la nota de aplicación **Microchip AN693**.

### Objetivos

1. Determinar experimentalmente la frecuencia de muestreo (Fs) y su estabilidad temporal.
2. Evaluar el desempeño dinámico del ADC: SNR, THD, SINAD, ENOB, SFDR y piso de ruido de la FFT.
3. Demostrar cuantitativa y visualmente la ganancia de procesamiento de la FFT y el descenso del piso de ruido por bin al variar el número de puntos de la transformada (M).
4. Contrastar los resultados experimentales frente a los límites teóricos de un ADC ideal de 12 bits (AN693).

## Estructura del repositorio

```
2 laboratorio segundo corte/
├── 6 INFORME DE COMUNICACION DIGITAL(...).docx / .pdf   # Informe de laboratorio
├── Análisis de parámetros de un conversor ADC.pdf        # Guía / material de apoyo
├── piso_ruido_ideal_vs_medido.png                        # Figura: piso de ruido ideal vs. medido
├── SNR_ENOB_vs_M.png                                      # Figura: SNR y ENOB vs. número de puntos M
├── fig11_12.m                                              # Script MATLAB que genera las dos figuras anteriores
│
├── FASE 1/                        # Verificación de Fs y jitter (N = M = 512, ventana Hann)
│   ├── ADC_testing_1.py           # Script de adquisición (MicroPython, corre en la Pico 2 W)
│   ├── adc_samples_*.csv          # Muestras en el dominio del tiempo
│   ├── adc_fft_*.csv              # Espectro (FFT) en dBFS
│   ├── adc_summary_*.csv          # Resumen de métricas dinámicas
│   ├── Fs en el osc.bmp / Frecuencia y numero de muestras de la señal.bmp
│   ├── verificacion de voltaje max y min.bmp
│   └── Resultado de consola.png
│
└── FASE 2/                        # Barrido de M = 128, 256, 512, 1024 puntos de FFT
    ├── codigo de matlab/
    │   └── ejemplo_base_adc.m     # Script base para graficar tiempo y espectro en MATLAB
    ├── PRUEBA 1 (128)/            # N = M = 128
    ├── PRUEBA 2 (256)/            # N = M = 256
    ├── PRUEBA 3 (512)/            # N = M = 512
    └── PRUEBA 4 (1024)/           # N = M = 1024
        (cada carpeta: adc_samples_*.csv, adc_fft_*.csv, adc_summary_*.csv,
         captura de consola y script GRAFICA_PRUEBA_X.m)
```

## Metodología / instrumentación

- **Microcontrolador:** Raspberry Pi Pico 2 W (RP2350), ADC de 12 bits, `VREF = 3.3 V`.
- **Entrada analógica:** GP27 (ADC); marcador de muestreo en GP15.
- **Señal de referencia:** senoidal de 250 Hz generada externamente.
- **Frecuencia de muestreo objetivo:** `Fs ≈ 2000 Hz` (medida real ≈ 2000.2–2001.5 Hz según la prueba).
- **Ventana:** Hann (comparada contra rectangular en el script).
- **Software de adquisición:** `ADC_testing_1.py`, ejecutado directamente en la Pico 2 W mediante MicroPython. Calcula en el propio microcontrolador la FFT, el piso de ruido, SNR, THD, THD+N, SINAD, ENOB y SFDR, y exporta los resultados a CSV.
- **Post-procesamiento y graficación:** MATLAB (`ejemplo_base_adc.m`, `GRAFICA_PRUEBA_X.m`, `fig11_12.m`), a partir de los CSV generados por el script de Python.

## Resultados principales (Fase 2 — barrido de M)

Señal de referencia de 250 Hz, ventana Hann, `SNR_ideal = 74.0 dB` (ADC ideal de 12 bits):

| M (=N) | SNR medido [dB] | ENOB [bits] | THD [%] | SINAD [dB] | SFDR [dBc] | Piso de ruido medido [dBFS/bin] | Piso de ruido ideal [dBFS/bin] |
|-------:|-----------------:|------------:|--------:|-----------:|-----------:|---------------------------------:|---------------------------------:|
|    128 |            58.76 |        8.41 |   0.211 |      52.38 |      60.32 |                           −69.68 |                           −90.30 |
|    256 |            52.33 |        8.33 |   0.080 |      51.88 |      61.26 |                           −73.50 |                           −93.31 |
|    512 |            49.38 |        7.84 |   0.107 |      48.97 |      60.00 |                           −75.85 |                           −96.32 |
|   1024 |            49.41 |        7.88 |   0.076 |      49.20 |      63.26 |                           −78.75 |                           −99.33 |

Estos valores, junto con las figuras `piso_ruido_ideal_vs_medido.png` y `SNR_ENOB_vs_M.png`, evidencian que el piso de ruido ideal cae con M (ganancia de procesamiento de la FFT) mientras que el piso de ruido medido, limitado por ruido de hardware y jitter, decrece más lentamente — de ahí la brecha creciente entre SNR ideal y SNR medido a medida que M aumenta.

## Cómo reproducir el experimento

1. **Adquisición (Pico 2 W):**
   - Cargar `FASE 1/ADC_testing_1.py` (o el correspondiente en `FASE 2`) en la Raspberry Pi Pico 2 W con MicroPython.
   - Conectar el generador de funciones a GP27 y el osciloscopio al pin marcador (GP15) para verificar Fs.
   - Ejecutar el script; al iniciar, permite configurar la frecuencia de entrada y el tipo de ventana (Enter = valores por defecto: 250 Hz, Hann).
   - El script imprime en consola el resumen de métricas y exporta `adc_samples_*.csv`, `adc_fft_*.csv` y `adc_summary_*.csv`.
2. **Graficación (MATLAB):**
   - Abrir el script correspondiente (`ejemplo_base_adc.m` o `GRAFICA_PRUEBA_X.m`) en la carpeta donde estén los CSV de esa prueba.
   - Ejecutar para obtener la señal en el dominio del tiempo y el espectro en dBFS.
   - `fig11_12.m` reproduce las figuras comparativas de piso de ruido y de SNR/ENOB vs. M usando los resultados ya tabulados del barrido.

## Requisitos

- Raspberry Pi Pico 2 W con firmware MicroPython.
- Generador de funciones y osciloscopio digital (Fase 1).
- MATLAB (con soporte para `readtable`) para la graficación y el post-procesamiento.

## Informe

El desarrollo teórico completo (cuantización y LSB, escala dBFS, ganancia de procesamiento de la FFT, efecto del ventaneo, definición formal de SNR/THD/SINAD/ENOB/SFDR, jitter de muestreo) y el análisis de resultados se encuentran en:

- `6 INFORME DE COMUNICACION DIGITAL(SALOME BOHORQUEZ-HAROL RIVEROS) (1).pdf` / `.docx`

## Referencias

- Microchip Technology, *Application Note AN693 — Using the PIC16C7XX A/D Converter*.
- IEEE Std 1241, *IEEE Standard for Terminology and Test Methods for Analog-to-Digital Converters*.
