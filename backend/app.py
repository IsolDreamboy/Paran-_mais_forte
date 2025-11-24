from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import requests
import os


# CONFIG


WEATHER_API_KEY = "ccccca2360ad11b224bdacd48b07926f"
LAT = -25.688
LON = -52.019

# Caminho absoluto da pasta deste arquivo (backend/)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Pasta /dados na raiz do projeto
DATA_DIR = os.path.join(BASE_DIR, "dados")

# Verifica se existe
if not os.path.exists(DATA_DIR):
    raise RuntimeError(f"Pasta de dados não encontrada: {DATA_DIR}")



# FASTAPI APP


app = FastAPI(
    title="Paraná Mais Forte API",
    version="1.0.0",
)

# Libera acesso do Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)



# FUNÇÃO DE CLIMA 


def fetch_weather_raw():
    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?lat={LAT}&lon={LON}&appid={WEATHER_API_KEY}&units=metric&lang=pt_br"
    )

    try:
        r = requests.get(url, timeout=10)

        if r.status_code == 401:
            raise HTTPException(
                status_code=401,
                detail="API de clima não autorizada. Verifique a chave."
            )

        r.raise_for_status()
        return r.json()

    except requests.exceptions.RequestException as e:
        raise HTTPException(
            status_code=503,
            detail=f"Falha ao acessar API de clima: {e}"
        )



# FUNÇÃO PARA LER CSV


def read_csv(filename: str) -> pd.DataFrame:
    path = os.path.join(DATA_DIR, filename)

    if not os.path.exists(path):
        raise HTTPException(
            status_code=500,
            detail=f"Arquivo {filename} não encontrado em {DATA_DIR}"
        )

    df = pd.read_csv(path, sep=",", decimal=",")

    # Remove NaN sempre
    df = df.fillna("")

    return df



# ENDPOINTS


@app.get("/financeiros")
def get_financeiros():
    df = read_csv("dados_financeiros.csv")
    return df.to_dict(orient="records")


@app.get("/doacoes")
def get_doacoes():
    df = read_csv("dados_doacoes.csv")
    return df.to_dict(orient="records")


@app.get("/obras")
def get_obras():
    df = read_csv("dados_obras.csv")
    return df.to_dict(orient="records")


@app.get("/danos")
def get_danos():
    df = read_csv("dados_humanos.csv")
    return df.to_dict(orient="records")


@app.get("/clima")
def get_clima():
    dados = fetch_weather_raw()

    temp = dados["main"]["temp"]
    vento_ms = dados["wind"]["speed"]
    vento_kmh = vento_ms * 3.6
    descricao = dados["weather"][0]["description"].capitalize()

    alerta = None
    if vento_kmh > 40:
        alerta = "Vento acima de 40 km/h. Risco moderado para trabalhos em altura."

    return {
        "temp": temp,
        "vento_kmh": vento_kmh,
        "descricao": descricao,
        "alerta": alerta
    }
