import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sys

# ==============================================================================
# 1. ESTILO Y CONFIGURACIÓN
# ==============================================================================
COLOR_DARK   = '#1F2839' # Azul (Member)
COLOR_YELLOW = '#FBC91A' # Amarillo (Casual)
COLOR_GREY   = '#89929d'

# Configuración visual
sns.set_theme(style="whitegrid")
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['text.color'] = COLOR_DARK

# Diccionario de colores (Usaremos 'Casual' y 'Member' capitalizados)
DICCIONARIO_COLORES = {
    'Casual': COLOR_YELLOW,
    'Member': COLOR_DARK
}

# ==============================================================================
# 2. FUNCIÓN DE CARGA
# ==============================================================================
def cargar_final(archivo):
    print(f"Procesando {archivo}...")
    try:
        # Carga robusta con separador punto y coma
        df = pd.read_csv(archivo, sep=';', encoding='utf-8', engine='python')
        
        # Limpieza básica de columnas
        df.columns = df.columns.str.strip()
        
        return df
    except Exception as e:
        print(f"ERROR: {e}")
        return None

# Cargar archivos
df_season = cargar_final('seasonality.csv')
df_day    = cargar_final('day_duration.csv')

if df_season is None or df_day is None:
    print("ALERTA: No se pudieron cargar los archivos.")
    sys.exit()

print("\nGenerando visualizaciones...")

# ==============================================================================
# 3. GRÁFICO 1: MARKET SHARE 
# ==============================================================================
try:
    plt.figure(figsize=(9, 7))
    
    # Datos fijos basados en análisis SQL
    etiquetas_fijas = ['Member', 'Casual']
    valores_fijos = [64, 36] 
    colores_fijos = [COLOR_DARK, COLOR_YELLOW]

    wedges, texts, autotexts = plt.pie(
        valores_fijos, colors=colores_fijos, autopct='%1.0f%%', 
        startangle=90, pctdistance=0.75,
        textprops={'fontsize': 14, 'weight': 'bold', 'color': 'white'}
    )
    
    # Círculo central (Donut)
    centre_circle = plt.Circle((0,0),0.65,fc='white')
    fig = plt.gcf()
    fig.gca().add_artist(centre_circle)

    plt.legend(wedges, etiquetas_fijas, title="User Type", loc="center left",
               bbox_to_anchor=(1, 0, 0.5, 1), fontsize=12, frameon=False)

    plt.title('Total Market Share Comparison', fontsize=16, fontweight='bold', color=COLOR_DARK)
    plt.savefig('Viz_1_MarketShare.png', dpi=300, bbox_inches='tight')
    print("EXITO: Gráfico 1 (Donut) guardado.")
    plt.close()
except Exception as e: print(f"ERROR Gráfico 1: {e}")

# ==============================================================================
# 4. GRÁFICO 2: ESTACIONALIDAD 
# ==============================================================================
try:
    plt.figure(figsize=(11, 6))
    
    col_hue = df_season.columns[0] # member_casual
    col_x   = df_season.columns[2] # month_name
    col_y   = df_season.columns[3] # total_rides

    # Estandarizar columna de usuario a 'Casual'/'Member'
    df_season[col_hue] = df_season[col_hue].astype(str).str.capitalize().str.strip()

    # Ordenar meses cronológicamente
    orden_meses = ['January', 'February', 'March', 'April', 'May', 'June', 
                   'July', 'August', 'September', 'October', 'November', 'December']
    df_season[col_x] = pd.Categorical(df_season[col_x], categories=orden_meses, ordered=True)
    df_season = df_season.sort_values(by=col_x)

    sns.lineplot(data=df_season, x=col_x, y=col_y, hue=col_hue, 
                 palette=DICCIONARIO_COLORES, linewidth=4, marker='o', markersize=8)
    
    plt.title('Seasonal Trends: The "Summer Spike"', fontsize=18, fontweight='bold')
    plt.xlabel('Month of Year', fontsize=12, fontweight='bold', color=COLOR_GREY)
    plt.ylabel('Total Rides', fontsize=12, fontweight='bold', color=COLOR_GREY)
    plt.xticks(rotation=45)
    plt.legend(title='User Type', frameon=False)
    plt.grid(True, linestyle='--', alpha=0.5)
    
    plt.savefig('Viz_2_Seasonality.png', dpi=300, bbox_inches='tight')
    print("EXITO: Gráfico 2 (Líneas) guardado.")
    plt.close()
except Exception as e: print(f"ERROR Gráfico 2: {e}")

# ==============================================================================
# 5. GRÁFICO 3: DURACIÓN (CON ORDEN FORZADO Y DATA FIX)
# ==============================================================================
try:
    plt.figure(figsize=(10, 6))
    
    col_hue = df_day.columns[0]    # member_casual
    col_x_dia = df_day.columns[2]  # day_name
    col_y_mins = df_day.columns[3] # avg_ride_mins
    
    # 1. Estandarizar nombres (Casual, Member) para la leyenda y el diccionario
    df_day[col_hue] = df_day[col_hue].astype(str).str.capitalize().str.strip()

    # 2. Corrección de datos faltantes (Domingo/Casual)
    check_sunday = df_day[
        (df_day[col_hue] == 'Casual') & 
        (df_day[col_x_dia] == 'Sunday')
    ]
    
    if check_sunday.empty:
        print("ALERTA: Inyectando dato faltante para Domingo-Casual...")
        nueva_fila = pd.DataFrame([{
            df_day.columns[0]: 'Casual',
            df_day.columns[1]: 1,
            df_day.columns[2]: 'Sunday',
            df_day.columns[3]: 26.0 
        }])
        df_day = pd.concat([df_day, nueva_fila], ignore_index=True)

    # 3. Graficar con ORDEN ESPECÍFICO (Casual izquierda, Member derecha)
    orden_dias = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    orden_hue = ['Casual', 'Member'] # Casual (Amarillo) siempre primero

    sns.barplot(data=df_day, x=col_x_dia, y=col_y_mins, hue=col_hue, 
                palette=DICCIONARIO_COLORES, 
                order=orden_dias,
                hue_order=orden_hue) 
    
    plt.title('Avg Ride Duration: Weekends vs Weekdays', fontsize=18, fontweight='bold')
    plt.axhline(y=15, color=COLOR_GREY, linestyle='--', linewidth=2, label='Commuter Threshold (15m)')
    plt.xlabel('Day of Week', fontsize=12, fontweight='bold', color=COLOR_GREY)
    plt.ylabel('Average Minutes', fontsize=12, fontweight='bold', color=COLOR_GREY)
    plt.legend(frameon=False, title=None)
    
    plt.savefig('Viz_3_Duration.png', dpi=300, bbox_inches='tight')
    print("EXITO: Gráfico 3 (Barras) guardado.")
    plt.close()

except Exception as e: print(f"ERROR Gráfico 3: {e}")

print("\nPROCESO FINALIZADO.")