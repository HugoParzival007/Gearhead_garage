# 0001. Local-first com Drift como fonte da verdade

## Contexto

O produto precisa funcionar sem internet e sem conta, e o plano grátis não pode enviar dados do carro para fora do aparelho. Em M2 haverá backup em nuvem e link público, mas só para quem assinar o Pro. As alternativas eram só local (sem link público nem uso em mais de um aparelho) ou nuvem primeiro (exige internet e tem custo desde o primeiro dia).

## Decisão

Dados ficam no aparelho, em SQLite via Drift, e a UI lê somente do Drift (por `Stream`s dos repositórios). A nuvem opcional (Supabase, no M2) é apenas espelho: sincronização em mão única, last-write-wins por registro, com um aparelho principal por vez.

## Consequências

- Uso offline completo e custo zero no plano grátis; divisão natural Grátis × Pro.
- Perda do aparelho exige backup (arquivo no M1c, nuvem no M2).
- O schema carrega desde o M1a os campos que a sincronização vai precisar (ver 0003).
