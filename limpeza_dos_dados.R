
# bibliotecas ultilizadas: 

library("tidyverse")
library("ggplot2")
library("readr")
library("readxl")
library("googlesheets4")
library("googledrive")
library("reactable")
library("usethis")


# download dos dados

microdados_ed_basica_2021 <- read_delim("~/currículos/teste_movimento_pela_base/microdados_ed_basica_2021.csv", 
                                        delim = ";", escape_double = FALSE, locale = locale(encoding='latin1')) 
dicionario_dados <- read_excel("~/currículos/teste_movimento_pela_base/dicionário_dados_educação_básica.xlsx", skip = 6)


# consultando o dicionário de dados

dicionario_dados %>% 
  select(`Nome da Variável`, `Descrição da Variável`)

# limpeza dos dados: 

microdados_ed_basica_2021_2 <- microdados_ed_basica_2021 %>%  
  select(NO_UF, NO_MUNICIPIO,CO_MUNICIPIO, TP_DEPENDENCIA, QT_MAT_INF, QT_MAT_INF_CRE, QT_MAT_INF_PRE) %>% 
  filter(TP_DEPENDENCIA == 3) %>% 
  filter(NO_UF == "Roraima" |
           NO_UF == "Rondônia" |
           NO_UF == "Tocantins" | 
           NO_UF == "Pará"|
           NO_UF == "Acre" |
           NO_UF == "Amazonas"|
           NO_UF == "Amapá") %>% 
  group_by(CO_MUNICIPIO, NO_MUNICIPIO, TP_DEPENDENCIA, NO_UF) %>%
  summarise(across(c(QT_MAT_INF, QT_MAT_INF_CRE, QT_MAT_INF_PRE), 
                   list(soma=sum), na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(TP_DEPENDENCIA = gsub(3,"Municipal", TP_DEPENDENCIA))

# transferindo os dados para o google sheets:

sheet_write(microdados_ed_basica_2021_2, ss = "https://docs.google.com/spreadsheets/d/11d1f-q7GQFedSMot2rKXLHcnTNDcn74qBLgk0c42XTw/edit#gid=1289488521", sheet = 1)
