# Post Instagram — Inferência Estatística

---

## Slide 1: Capa (O Gancho)

**Texto visual:**
Como adivinhar a proporção real de alunas de Exatas na UFJF? 🎯

**Subtítulo:**
E por que um "chute" matemático pode dar muito errado (mesmo estando certo na média).

**Imagem sugerida:**
Ilustração simples de um alvo com vários pontos espalhados, mas cujo "centro de massa" está exatamente no meio.

---

## Slide 2: O Problema (A Amostra)

Imagine que queremos descobrir a verdadeira proporção ($p$) de mulheres matriculadas em cursos de Exatas na UFJF.

Como não podemos entrevistar todas as alunas, pegamos uma **amostra aleatória** de tamanho $n$.

Cada aluna entrevistada é um ensaio de Bernoulli:
- $X_i = 1$ (se for de Exatas)
- $X_i = 0$ (se for de outras áreas)

Como transformamos esses $0$s e $1$s em uma estimativa confiável?

---

## Slide 3: O Estimador "Enganoso" (Não-viesado, mas péssimo)

Uma ideia seria criar uma **média ponderada**. Imagine dar um peso gigante para a 1ª aluna entrevistada ($w_1 = 0.9$) e dividir o resto do peso ($0.1$) entre todas as outras.

Contanto que a soma dos pesos seja 1 ($\sum w_i = 1$), esse estimador é **não-viesado**.

O que isso significa? Se repetirmos essa pesquisa infinitas vezes, a média dos nossos chutes será exatamente a proporção real. Ele acerta na mosca... **na média**.

---

## Slide 4: Onde a mágica quebra (A Variância)

O problema desse estimador ponderado é que ele é **altamente instável**. Ao dar pesos diferentes, a variância do nosso chute explode.

Em uma única amostra real, seu resultado vai flutuar absurdamente longe da proporção verdadeira.

Ele não usa a informação contida nos dados de forma eficiente. Na prática, estamos **desperdiçando dados valiosos** em nome de um formalismo matemático.

---

## Slide 5: O Campeão Invicto (O Estimador de Máxima Verossimilhança)

É aqui que entra o estimador clássico: a **Proporção Amostral** ($\hat{p} = \frac{x}{n}$).

Ao dar peso igual ($1/n$) para cada aluna, nós não apenas mantemos o estimador não-viesado, mas garantimos a **menor variância possível** entre todos os estimadores lineares não-viesados (UMVUE).

Pelo **Teorema de Fatoração de Fisher-Neyman**, a simples contagem das alunas condensa toda a informação necessária da amostra original. Nenhuma informação é perdida.

---

## Slide 6: Call to Action (Direcionando para o Artigo)

A frequência relativa não é apenas intuitiva — ela é **matematicamente a melhor escolha**. Na inferência clássica, este estimador possui propriedades desejáveis, como ser assintoticamente não-viesado e de variância mínima.

Quer ver a prova rigorosa de como derivamos isso usando a **Função de Log-Verossimilhança** e **Multiplicadores de Lagrange**?

👉 Link na bio/nos comentários para o artigo completo com as demonstrações matemáticas e códigos em R.
