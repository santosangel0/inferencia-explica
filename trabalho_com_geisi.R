# 1. Preparação dos Dados
df <- read.csv("UFJF_observatorio_ingressantegrad.csv")
df_ativa <- subset(df, SITUACAO == "ATIVO")

# Agrupamento
exatas_eng <- c("CIÊNCIAS EXATAS E DA TERRA", "ENGENHARIAS")
df_ativa$AREA <- ifelse(df_ativa$GRANDEAREATEXTO %in% exatas_eng, "Exatas", "Outras")

# Parâmetro Populacional Real
p_real <- mean(df_ativa$AREA == "Exatas")

# 2. Configuração do Experimento
n_amostras <- c(25, 50, 75, 100)
par(mfrow=c(2,2), mar=c(4,4,2,1))

for(n in n_amostras) {
  set.seed(42) # Reprodutibilidade
  amostra <- sample(df_ativa$AREA, n)
  k <- sum(amostra == "Exatas")
  
  # Estimadores
  p_emv <- k / n
  p_laplace <- (k + 1) / (n + 2)
  
  # Grid e Log-Verossimilhança
  p_grid <- seq(0.01, 0.6, length.out=500)
  log_vero <- k*log(p_grid) + (n-k)*log(1-p_grid)
  log_vero_rel <- log_vero - max(log_vero) # Normalizando o pico em 0
  
  # Plot
  plot(p_grid, log_vero_rel, type="l", lwd=2, 
       main=paste("n =", n, "| Mulheres em Exatas =", k),
       xlab="Proporção (p)", ylab="Log-Vero Relativa", ylim=c(-5, 0.5))
  
  # Intervalo de Confiança (Wald)
  se <- sqrt(p_emv * (1 - p_emv) / n)
  ic <- c(max(0, p_emv - 1.96*se), min(1, p_emv + 1.96*se))
  
  # Sombreado do IC
  grid_ic <- p_grid[p_grid >= ic[1] & p_grid <= ic[2]]
  poly_y <- log_vero_rel[p_grid >= ic[1] & p_grid <= ic[2]]
  polygon(c(grid_ic, rev(grid_ic)), c(poly_y, rep(-10, length(grid_ic))), 
          col=rgb(0,0,1,0.2), border=NA)
  
  # Linhas dos Estimadores
  abline(v = p_emv, col="blue", lwd=2, label="EMV")
  abline(v = p_laplace, col="darkgreen", lwd=2, lty=2)
  abline(v = p_real, col="red", lwd=2, lty=3)
  
  legend("topright", legend=c("Log-Vero", "IC 95%", "EMV", "Laplace", "Real"),
         col=c("black", "blue", "blue", "darkgreen", "red"),
         lty=c(1, NA, 1, 2, 3), pch=c(NA, 15, NA, NA, NA), 
         pt.cex=1.5, bty="n", cex=0.8)
}

