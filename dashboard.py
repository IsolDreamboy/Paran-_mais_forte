import streamlit as st
import pandas as pd
import os
import plotly.express as px
import requests

WEATHER_API_KEY = "ccccca2360ad11b224bdacd48b07926f" 
LAT = -25.688 
LON = -52.019 


def fetch_weather():
    """Busca dados de clima e inclui tratamento de erros."""
    URL = f"https://api.openweathermap.org/data/2.5/weather?lat={LAT}&lon={LON}&appid={WEATHER_API_KEY}&units=metric&lang=pt_br"

    try:
        response = requests.get(URL, timeout=10) 
        
        if response.status_code == 401:
            st.error(" Erro 401: API NÃO AUTORIZADA. Chave incorreta ou inativa.")
            return None
            
        response.raise_for_status() 
        return response.json()
        
    except requests.exceptions.RequestException as e:
        st.error(f" Erro de Conexão: Não foi possível alcançar o servidor da API. {e}")
        return None

st.set_page_config(
    page_title="Dashboard Paraná Mais Forte",
    layout="wide"
    )


df_doacoes = pd.read_csv('dados/dados_doacoes.csv', sep=",", decimal=',')
df_financeiros = pd.read_csv('dados/dados_financeiros.csv', sep=",", decimal=",")
df_obras = pd.read_csv('dados/dados_obras.csv', sep=",", decimal=",")
df_danos = pd.read_csv('dados/dados_humanos.csv', sep=",", decimal=",")


st.header("Recursos Financeiros e Apoio.")
col1 ,col2 ,col3 = st.columns(3)

#recursos liberados para ajudar 
col1.metric(label="Fundo Federal Liberado", value="R$ 25.000.000")

cartoes_entregues = 165 # cartoes de apoio entregues
col2.metric(label="Cartões Reconstrução Entregues", value=cartoes_entregues)

col3.metric(label="Moradias Pré-construídas", value="320 (Em Entrega)")


#agora vamos visualizar o financeiro
st.subheader("Alocação de Fundos por Fonte")
    
df_chart = df_financeiros[df_financeiros['Programa'] != 'Governo do Paraná (Cartão Reconstrução)'].copy()

df_chart['Valor Numérico'] = df_chart['Valor Total (R$)'].apply(lambda x: float(x) if x != 'Não especificado' else 0)

fig = px.bar(
    df_chart, 
    x='Programa', 
    y='Valor Numérico', 
    color='Valor Numérico', 
    labels={'Valor Numérico': 'Valor (R$)', 'Programa': 'Fonte de Recurso'},
    height=400,
    color_continuous_scale='Plasma'
    )
st.plotly_chart(fig, use_container_width=True) 

   
st.subheader("Status dos Serviços Essenciais e Obras")

st.dataframe(df_obras, use_container_width=True)


#doaçoes

st.markdown("---")
st.header("Doações")

col_doac_1, col_doac_2 = st.columns([1, 2])


materiais_doados = df_doacoes[df_doacoes['Tipo de Doação'] == 'Materiais (Corpo de Bombeiros)']['Quantidade/Valor'].iloc[0]
col_doac_1.metric(label="Materiais Arrecadados", value=materiais_doados)


chave_pix = df_doacoes[df_doacoes['Tipo de Doação'] == 'Dinheiro (PIX Prefeitura)']['Status/Detalhes'].iloc[0]
col_doac_2.info(f"**Doações em Dinheiro (PIX):**\n\nA Prefeitura está recebendo apoio via PIX.\n\nChave: **{chave_pix.split(': ')[1]}**\n\n*(Valor não quantificado no relatório)*")


st.markdown("---")
st.header("Monitoramento de Clima")
st.caption("Dados em tempo real, essenciais para segurança das obras.")

dados_clima = fetch_weather()

if dados_clima:
    
    temp = dados_clima['main']['temp']
    vento_ms = dados_clima['wind']['speed']
    vento_kmh = vento_ms * 3.6 # m/s para km/h
    
    
    st.success("Dados de clima atualizados com sucesso!")

    col_c1, col_c2, col_c3 = st.columns(3)
    
    # 1. Temperatura
    col_c1.metric("Temperatura Atual", f"{temp:.1f} °C")
    
    # 2. Vento
    col_c2.metric("Vento Atual", f"{vento_kmh:.1f} km/h")
    
    # 3. Clima
    descricao = dados_clima['weather'][0]['description'].capitalize()
    col_c3.info(f"Condição Geral: {descricao}") 

    # Alerta Amarelo para ventos acima de 40 km/h (risco para obras em altura)
    if vento_kmh > 40: 
        st.warning(f" ALERTA: Vento acima de 40 km/h. Risco moderado para trabalhos em altura. Cautela recomendada.")
    else:
        # Cor Verde (normal)
        st.success(" Condições climáticas favoráveis. Sem alertas de vento.")


