# test_servicos.py

import pytest
import requests
from unittest.mock import MagicMock
from dashboard import fetch_weather, WEATHER_API_KEY, LAT, LON 


MOCK_WEATHER_DATA = {
    "main": {"temp": 20.0, "humidity": 70},
    "wind": {"speed": 6.5}, 
    "weather": [{"description": "chuva leve"}]
}


class MockResponse:
    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code

    def json(self):
        return self.json_data

    def raise_for_status(self):
        if self.status_code >= 400:
            raise requests.exceptions.HTTPError(f"HTTP Error: {self.status_code}")

# ----------------- TESTES UNITÁRIOS -----------------

def test_clima_sucesso(monkeypatch):
    """Testa se a função retorna os dados corretamente em caso de sucesso (código 200)."""
    
    
    monkeypatch.setattr(requests, "get", lambda *args, **kwargs: MockResponse(MOCK_WEATHER_DATA, 200))
    
    resultado = fetch_weather() 
    
    assert resultado is not None
    assert resultado['main']['temp'] == 20.0

def test_clima_erro_401_nao_autorizado(monkeypatch):
    """Testa se a função trata o erro 401 (Não Autorizado) corretamente."""
    
    
    monkeypatch.setattr(requests, "get", lambda *args, **kwargs: MockResponse(None, 401))

    resultado = fetch_weather()
    
    
    assert resultado is None

def test_clima_erro_conexao(monkeypatch):
    """Testa se a função trata erros de conexão (timeout, DNS, etc.) corretamente."""
    
    def _raise_connection_error(*args, **kwargs):
        raise requests.exceptions.ConnectionError("Simulação de falha de conexão")

    monkeypatch.setattr(requests, "get", _raise_connection_error)

    resultado = fetch_weather()
    
    
    assert resultado is None

@pytest.mark.integration
def test_integracao_api_real():
    """Testa a integração com a API REAL para garantir que a comunicação externa funciona."""
    
    URL = f"https://api.openweathermap.org/data/2.5/weather?lat={LAT}&lon={LON}&appid={WEATHER_API_KEY}&units=metric&lang=pt_br"

    try:
        response = requests.get(URL, timeout=5) 
        response.raise_for_status() 
        data = response.json()
        
        
        assert 'main' in data
        assert 'temp' in data['main']
        
    except requests.exceptions.RequestException:
        pytest.fail("Falha no teste de integração: A comunicação com a API falhou ou a chave foi desativada.")