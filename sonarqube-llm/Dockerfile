FROM python:3.11-slim

# Instalamos las librerías necesarias
RUN pip install --no-cache-dir sonarqube-api requests

# Copiamos el script que hará la consulta
COPY fetch_sonar_report.py /app/fetch_sonar_report.py

# Establecemos el directorio de trabajo
WORKDIR /app

# Definimos que al correr el contenedor ejecute el script
ENTRYPOINT ["python", "fetch_sonar_report.py"]