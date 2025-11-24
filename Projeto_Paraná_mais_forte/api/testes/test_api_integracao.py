import sys
from pathlib import Path

root_dir = Path(__file__).parent.parent.parent
sys.path.insert(0, str(root_dir))

from api.main import app, fetch_weather_raw
from fastapi.testclient import TestClient
import pytest

client = TestClient(app)


def test_read_financeiros():
    response = client.get("/dados_financeiros")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0


def test_read_doacoes():
    response = client.get("/dados_doacoes")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0


def test_read_obras():
    response = client.get("/dados_obras")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0


def test_read_danos():
    response = client.get("/dados_danos")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0


def test_read_clima():
    response = client.get("/clima")
    assert response.status_code in [200, 503]
    
    if response.status_code == 200:
        data = response.json()
        assert "temp" in data
        assert "vento_kmh" in data
        assert "descricao" in data


def test_financeiros_structure():
    response = client.get("/dados_financeiros")
    data = response.json()
    
    if len(data) > 0:
        primeiro_registro = data[0]
        assert isinstance(primeiro_registro, dict)


def test_clima_alerta_vento():
    response = client.get("/clima")
    
    if response.status_code == 200:
        data = response.json()
        vento = data["vento_kmh"]
        alerta = data.get("alerta")
        
        if vento > 40:
            assert alerta is not None
            assert "Vento" in alerta