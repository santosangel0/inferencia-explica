library(ggplot2)
library(dplyr)

# =========================
# Dados
# =========================

df <- read.csv("UFJF_observatorio_ingressantegrad.csv")

# Criando variável binária
df$EXATAS <- ifelse(
  df$GRANDEAREATEXTO %in%
    c("CIÊNCIAS EXATAS E DA TERRA",
      "ENGENHARIAS"),
  "Exatas",
  "Outras"
)
## valor do p real 
p_real <- mean(df$GRANDEAREATEXTO %in% c("CIÊNCIAS EXATAS E DA TERRA", "ENGENHARIAS"))
# =========================
# Tamanhos amostrais
# =========================

n_vals <- c(5, 10, 100, 500)

lista_amostras <- list()

set.seed(123)

for(n in n_vals){
  
  # sorteando amostra
  amostra <- sample_n(df, n)
  
  # proporção
  p_hat <- mean(amostra$EXATAS == "Exatas")
  
  # criando label
  amostra$Painel <- paste0(
    "n = ", n,
    "\nProp = ",
    round(p_hat, 3))
  
  lista_amostras[[as.character(n)]] <- amostra
}

# juntando tudo
dados_plot <- bind_rows(lista_amostras)

# Adicione esta nova linha para travar a ordem dos gráficos:
dados_plot$Painel <- factor(dados_plot$Painel, levels = unique(dados_plot$Painel))
# =========================
# Gráfico
# =========================
ggplot(
  dados_plot,
  aes(
    x = EXATAS,
    y = 0,
    color = EXATAS
  )
) +
  geom_jitter(
    width = 0.25,
    height = 0.2,
    size = 3,
    alpha = 0.7
  ) +
  facet_wrap(~Painel) +
  labs(
    title = "Estimativa da proporção de mulheres em Exatas",
    subtitle = "Amostras aleatórias de diferentes tamanhos",
    x = "",
    y = "",
    # Aqui nós inserimos o valor do p_real no título da legenda:
    color = paste0("Área\n(Proporção real = ", round(p_real, 3), ")")
  ) +
  # Aplicando as cores institucionais para dar um aspecto mais profissional:
  scale_color_manual(
    values = c("Exatas" = "#003366", "Outras" = "#990033")
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )

