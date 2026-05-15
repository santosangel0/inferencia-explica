library(ggplot2)
library(dplyr)

# =====================================================
# Estimador Ruim: média ponderada com w1 = 0.9
# =====================================================

df <- read.csv("UFJF_observatorio_ingressantegrad.csv")
df_ativa <- subset(df, SITUACAO == "ATIVO")
df_ativa$EXATAS <- as.integer(
  df_ativa$GRANDEAREATEXTO %in% c("CIÊNCIAS EXATAS E DA TERRA", "ENGENHARIAS")
)

p_real <- mean(df_ativa$EXATAS)

estimador_ruim <- function(amostra) {
  n <- length(amostra)
  if (n == 1) return(amostra[1])
  pesos <- c(0.9, rep(0.1 / (n - 1), n - 1))
  sum(pesos * amostra)
}

n_vals <- seq(10, 200, by = 10)
n_sim  <- 10

set.seed(42)

resultados <- do.call(rbind, lapply(n_vals, function(n) {
  do.call(rbind, lapply(seq_len(n_sim), function(sim) {
    amostra    <- sample(df_ativa$EXATAS, n)
    estimativa <- estimador_ruim(amostra)
    data.frame(n = n, simulacao = factor(sim), estimativa = estimativa)
  }))
}))

medias <- resultados %>%
  group_by(n) %>%
  summarise(media = mean(estimativa), .groups = "drop")

ggplot() +
  geom_line(
    data  = resultados,
    aes(x = n, y = estimativa, group = simulacao),
    color = "#E05C5C", alpha = 0.35, linewidth = 0.6
  ) +
  geom_point(
    data  = resultados,
    aes(x = n, y = estimativa),
    color = "#E05C5C", alpha = 0.35, size = 1.2
  ) +
  geom_line(
    data      = medias,
    aes(x = n, y = media),
    color     = "#8B0000", linewidth = 1.4
  ) +
  geom_point(
    data  = medias,
    aes(x = n, y = media),
    color = "#8B0000", size = 2.5
  ) +
  geom_hline(
    yintercept = p_real,
    linetype   = "dashed",
    color      = "black",
    linewidth  = 0.9
  ) +
  annotate(
    "text",
    x     = max(n_vals) - 5,
    y     = p_real + 0.025,
    label = paste0("p real = ", round(p_real, 3)),
    hjust = 1,
    size  = 3.5
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  labs(
    title    = "Estimador Ruim — Ponderado (w₁ = 0.9)",
    subtitle = "Linhas claras: 10 simulações por n  |  Linha escura: média das 10 simulações",
    x        = "Tamanho da amostra (n)",
    y        = "Estimativa de p"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.subtitle = element_text(size = 10, color = "gray40"))

ggsave("graficos/grafico_estimador_ruim.png", width = 10, height = 6, dpi = 150)
message("Salvo: graficos/grafico_estimador_ruim.png")
