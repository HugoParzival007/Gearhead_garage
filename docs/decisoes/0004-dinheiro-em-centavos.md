# 0004. Dinheiro em centavos, distância em km inteiro

## Contexto

Valores monetários em `double` acumulam erro de arredondamento e quebram somas de custos. O usuário digita no formato brasileiro ("1.234,56", "R$ 10", "0,5").

## Decisão

Dinheiro é sempre `int` em centavos; `double` é proibido para valores monetários. Distância é `int` em km. A entrada é convertida por `parseBrlToCents`, que recusa texto inválido ou negativo com mensagem, nunca transformando em 0 em silêncio; `formatBrl` faz o caminho inverso para exibição.

## Consequências

- Somas exatas e comparáveis (orçamento, "falta", totais por categoria).
- A UI precisa sempre passar por `parseBrlToCents` e `formatBrl`.
- Moeda única (BRL) no M1a; outras moedas exigiriam nova decisão.
