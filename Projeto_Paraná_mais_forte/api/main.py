from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import requests
from pathlib import Path


WEATHER_API_KEY = "ccccca2360ad11b224bdacd48b07926f"
LAT = -25.688
LON = -52.019

# Configuração de caminhos
BASE_DIR = Path(__file__).parent.parent
DADOS_DIR = BASE_DIR / "dados"

app = FastAPI(
    title="Paraná Mais Forte API",
    version="1.0.0",
)

# libera acesso do Flutter (web, mobile etc.)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


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
                detail="API de clima não autorizada. Verifique a chave.",
            )

        r.raise_for_status()
        return r.json()
    except requests.exceptions.RequestException as e:
        raise HTTPException(
            status_code=503,
            detail=f"Falha ao acessar API de clima: {e}",
        )


@app.get("/dados_financeiros")
def get_financeiros():
    try:
        df = pd.read_csv(DADOS_DIR / "dados_financeiros.csv", sep=";", decimal=",")
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Arquivo de financeiros não encontrado.")

    return df.to_dict(orient="records")


@app.get("/dados_doacoes")
def get_doacoes():
    try:
        df = pd.read_csv(DADOS_DIR / "dados_doacoes.csv", sep=";", decimal=",")
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Arquivo de doações não encontrado.")

    return df.to_dict(orient="records")


@app.get("/dados_obras")
def get_obras():
    try:
        df = pd.read_csv(DADOS_DIR / "dados_obras.csv", sep=";", decimal=",")
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Arquivo de obras não encontrado.")

    return df.to_dict(orient="records")


@app.get("/dados_danos")
def get_danos():
    try:
        df = pd.read_csv(DADOS_DIR / "dados_humanos.csv", sep=";", decimal=",")
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Arquivo de danos humanos não encontrado.")

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