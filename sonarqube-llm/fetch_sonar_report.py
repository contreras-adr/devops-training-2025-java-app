import os
import requests
import sys

# Configuraciones desde variables de entorno
SONAR_HOST = os.getenv('SONAR_HOST')
SONAR_TOKEN = os.getenv('SONAR_TOKEN')
PROJECT_KEY = os.getenv('PROJECT_KEY')

if not SONAR_HOST or not SONAR_TOKEN or not PROJECT_KEY:
    print("Debes definir las variables de entorno SONAR_HOST, SONAR_TOKEN y PROJECT_KEY.")
    sys.exit(1)

# Construimos la URL para consultar el último análisis
url = f"{SONAR_HOST}/api/project_analyses/search?project={PROJECT_KEY}"

# Hacemos la petición
response = requests.get(url, auth=(SONAR_TOKEN, ''))

if response.status_code != 200:
    print(f"Error en la consulta: {response.status_code} - {response.text}")
    sys.exit(1)

# Guardamos el resultado en un archivo
output_file = os.getenv('OUTPUT_FILE', 'sonar_last_analysis.json')
with open(output_file, 'w') as f:
    f.write(response.text)

print(f"Análisis guardado en {output_file}")