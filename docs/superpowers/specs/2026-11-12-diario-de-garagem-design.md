# Diário de Garagem — Documento de Design

**Nome proposto:** Diário de Garagem (evolução do app hoje chamado Gearhead Garage). Ver seção 16.
**Data:** 12/11/2026
**Status:** rascunho para aprovação
**Direção escolhida:** A — garagem do entusiasta
**Arquitetura de dados escolhida:** local-first (Drift) com nuvem opcional (Supabase)

---

## 0. Revisão 2 (12/11/2026) — prevalece sobre o texto abaixo

Versão viva: https://claude.ai/artifact/8PqxgcEdXuG5KEsgERq16Y

1. **Projeto novo, do zero.** Novo app Flutter `diario_de_garagem`. O Gearhead Garage e o repositório antigo `app_garagem_digital` (GetX + Firebase + OBD2) servem só de referência; nenhum código é migrado. Onde o texto abaixo diz "evolução do Gearhead", leia "projeto novo".
2. **Link público grátis com selo:** grátis publica snapshot com até 10 fotos e selo "feito com Diário de Garagem", via login anônimo; Pro tem galeria completa, sem selo, personalização. Privacidade: nenhum dado sai do aparelho sem o usuário publicar o link. Continua na fase 2 (M2).
3. **Tipo de veículo:** carro ou moto (`vehicle_type`), no M1a.
4. **Orçamento do projeto:** `project_budget` por veículo; mostra gasto e quanto falta. No M1a.
5. **Regularização (CSV):** mod tem `requires_regularization` e `regularization_status` (pendente/regularizado); anexo do tipo `csv`. Checklist informativo, sem orientação jurídica. Campos no M1a; anexo no M1c.
6. **Abastecimento** segue no backlog; pergunta de frequência adicionada às conversas de validação.

---

## 1. Resumo

App Flutter para quem modifica e cuida do próprio carro registrar **tudo o que o carro já recebeu**: modificações, manutenção, peças, custos e fotos, numa linha do tempo por veículo. Funciona sem internet e sem conta. O plano **Pro** adiciona backup em nuvem, **perfil público do carro por link** e **IA que lê nota fiscal** e preenche o registro.

Não é um app de controle de gastos genérico (mercado dominado pelo Drivvo). É o **diário do projeto do carro**, em português, para o entusiasta brasileiro.

---

## 2. Por que este produto

### 2.1 Contexto de mercado
- Frota circulante brasileira: 48,8 milhões de autoveículos em 2025; idade média dos automóveis 11 anos e 5 meses (Sindipeças, Relatório da Frota Circulante 2026). Carro mais velho = mais manutenção, mais troca de peças, mais projetos.
- Histórico tem valor na revenda: anúncios da OLX com Histórico Veicular geram até 47% mais contatos. Lojistas estimam desconto de 10% a 20% para carro sem histórico de manutenção (estimativa de blog, não estudo).
- Nos EUA, 2025–2026 viu uma leva de apps independentes para entusiastas (CarJourney, Builds, The Pit Log, Drivegram, ModProAI, TorqVault). No Brasil existem apps recentes de garagem digital (CarM3, iGarage, Mec Box), mas focados em manutenção e gastos do carro comum; a pesquisa não encontrou nenhum em português centrado em modificações e no projeto do entusiasta. Busca limitada.

### 2.2 Problema do usuário
O entusiasta guarda a história do carro espalhada: notas fiscais numa pasta ou no WhatsApp, fotos no rolo da câmera, valores na cabeça, quilometragem de troca de óleo num adesivo no para-brisa. Consequências:
- não sabe quanto já investiu no projeto;
- não lembra qual peça/marca usou e quando;
- perde prazos de manutenção de itens que trocou fora do padrão (ex.: óleo de outra especificação, velas de outra faixa térmica);
- na hora de vender ou mostrar o carro, não tem como provar o que foi feito.

### 2.3 Por que agora (pessoal)
Em aberto — Hugo não detalhou a motivação. Não bloqueia o design.

---

## 3. Público-alvo

### 3.1 Persona primária — entusiasta "faça você mesmo"
- 20–40 anos, tem 1–3 carros, ao menos um é "projeto" (rebaixado, remapeado, restaurado, preparado para track day ou só cuidado com capricho).
- Faz parte da manutenção em casa ou acompanha de perto na oficina de confiança.
- Participa de grupos de WhatsApp/Facebook de modelo/marca, segue páginas de encontros no Instagram, vai a encontros.
- Dor principal: perder o controle do que foi feito e quanto custou.

### 3.2 Personas secundárias (não são foco do MVP)
- Restaurador de clássico: precisa de linhagem de peças e muitas fotos.
- Dono "zeloso" de carro comum: quer histórico para revenda. Atendido pelo mesmo produto, mas não guia decisões.

### 3.3 Mercado inicial
Goiânia e região (onde o Hugo está e pode ir a encontros), depois Brasil. App em pt-BR desde o início.

---

## 4. Concorrência e diferenciais

| Concorrente | O que faz | Onde é fraco para o nosso público |
|---|---|---|
| Drivvo (BR) | Gastos, abastecimento, lembretes, frota. Grátis + Pro. Nota 4,8 com 114 mil avaliações. | Foco em custo/km e frota; mods não são cidadãos de primeira classe; sem perfil do carro para mostrar. |
| Fuelio, Simply Auto | Consumo e gastos. Simply Auto: pagamento único a partir de R$ 19,99. | Mesmo foco em consumo. |
| CarM3, iGarage, Mec Box (BR, recentes) | "Garagem digital" com ficha técnica, manutenção, gastos; Mec Box transfere o histórico ao novo dono. | Foco no carro comum; mods e projeto não são o centro; pouca tração visível. |
| CARFAX Car Care (EUA) | Histórico preenchido por oficinas parceiras, recall, lembretes. | Não opera no Brasil. |
| CarJourney, Builds, Pit Log, Drivegram (EUA) | Mods + manutenção, alguns com IA de nota e comunidade. | Em inglês, sem foco no Brasil, unidades e realidade locais. |
| FIXD (OBD) | Leitura de falhas via dongle + assinatura (US$ 8,99/mês ou US$ 69,99/ano). | Reclamações dominantes sobre cobrança; hardware fora do escopo. |

### Diferenciais (em ordem de importância)
1. **Mods como cidadãos de primeira classe:** status (planejada → instalada → removida), peças, marca, custo, mão de obra, antes/depois, nota de desempenho. Separados da manutenção, mas na mesma linha do tempo.
2. **Custo total do projeto** sempre visível, por categoria (motor, suspensão, estética, som, rodas/pneus…).
3. **Perfil público do carro por link** (Pro): a "ficha" do projeto para compartilhar em grupo, Instagram ou com comprador. O dono escolhe o que aparece (custos e placa ocultos por padrão).
4. **IA lê a nota fiscal** (Pro): foto da nota → registro pré-preenchido para confirmar.
5. **Offline e sem conta no plano grátis:** funciona dentro da garagem sem sinal; privacidade como argumento.
6. **Feito para o Brasil:** pt-BR, R$, km, flex (etanol/gasolina), termos locais.

---

## 5. Objetivos, não-objetivos e anti-objetivos

### Objetivos
- Registrar um mod ou manutenção em menos de 30 segundos (sem IA) no fluxo mais comum.
- Mostrar o custo total do projeto e a linha do tempo de cada carro.
- Lembrar manutenções por km **ou** data, o que vier primeiro.
- Permitir ao usuário mostrar o projeto a terceiros (link público, Pro).
- Validar que entusiastas brasileiros usam e pagam pelo Pro antes de investir em comunidade.

### Não-objetivos (fora do escopo até nova decisão)
- Feed social, curtidas, seguidores, comentários, chat (só depois de validar o núcleo — fase 3).
- Leitura OBD2 / hardware.
- Gestão de frota, motoristas de aplicativo, empresas.
- Integração com oficinas (direção C — fica como possibilidade futura com o AutoFlow IA).
- Consulta de débitos, multas, IPVA, documentos do Detran.
- Marketplace de peças ou serviços.
- iOS no lançamento (o código Flutter permite, mas publicação e testes ficam para depois).

### Anti-objetivos (o que faria o produto falhar mesmo "funcionando")
- Virar mais um app de gastos genérico que compete de frente com o Drivvo.
- Exigir conta ou internet para o uso básico.
- IA gravar dados sem confirmação do usuário.
- Cobrança confusa ou difícil de cancelar (o erro que marcou a reputação do FIXD).
- Expor placa, custos ou localização do usuário no link público sem ele escolher.
- Perder dados do usuário (troca de celular, falha de sincronização).

---

## 6. Funcionalidades por fase

### Fase 0 — Validação (antes de programar o que é novo)
Ver seção 9.

### Fase 1 — MVP local (evolução do Gearhead atual, plano Grátis)
Base atual conhecida do Gearhead: Flutter + Drift, veículos, modificações, manutenção e histórico; veículo selecionado persistido; registros isolados por veículo; `flutter analyze` sem problemas. Abastecimento, consumo e custos estavam planejados para marcos seguintes.

1. **Garagem**
   - Cadastro de veículo: apelido, marca, modelo, versão, ano, motor, combustível (gasolina/etanol/flex/diesel/elétrico/híbrido), km atual, foto de capa, placa (opcional, privada).
   - Lista de veículos; seleção do veículo ativo (já existe).
   - Arquivar veículo vendido (mantém histórico, sai da lista principal).
   - Limite do plano grátis: 2 veículos ativos.
2. **Modificações**
   - Campos: título, categoria, status (planejada / instalada / removida), data, km, peças (nome, marca, código opcional, quantidade, valor unitário), mão de obra (valor, quem fez: eu / oficina + nome), fotos (antes/depois), notas, nota de desempenho opcional (texto livre).
   - "Planejada" funciona como lista de desejos do projeto, com custo estimado.
3. **Manutenção**
   - Campos: tipo (troca de óleo, filtros, freios, pneus, correia, fluidos, alinhamento, revisão, outro), data, km, peças e mão de obra (mesmo formato dos mods), local, fotos, notas.
   - Tipos pré-cadastrados com intervalo sugerido editável.
4. **Linha do tempo**
   - Mods e manutenções juntos, ordenados por data/km, filtro por tipo e categoria.
5. **Custos**
   - Total investido no carro; total por categoria; total por período; separação mods × manutenção.
6. **Lembretes**
   - Por km, por data ou ambos ("o que vier primeiro"); criados a partir de um registro ("lembrar a próxima troca de óleo em 5.000 km ou 6 meses").
   - Notificação local agendada para lembretes por data.
   - Lembrete por km avaliado quando o usuário atualiza o km (ao cadastrar registro ou pelo botão "atualizar km").
7. **Anexos**
   - Fotos da galeria/câmera e foto de nota fiscal guardadas localmente, ligadas ao registro.
8. **Exportar / importar**
   - Exportar backup completo (arquivo único: dados + fotos) e restaurar a partir dele. É a rede de segurança do plano grátis contra troca de celular.
   - (Relatório PDF movido para a fase 2, para caber no tempo disponível — ver seção 13.)
9. **Onboarding curto**
   - Criar primeiro carro → registrar primeiro mod ou manutenção → ver custo total. Sem cadastro de conta.

### Fase 2 — Nuvem e Pro
1. **Conta** (Supabase Auth: e-mail + Google). Só necessária para recursos Pro.
2. **Backup em nuvem**
   - Fonte da verdade continua no Drift, no celular.
   - Envio automático de alterações para a nuvem (mão única: celular → nuvem) quando houver internet.
   - Restaurar em novo aparelho: baixa tudo da nuvem para o Drift.
   - Regra de conflito: prevalece o registro com `updated_at` mais recente (last-write-wins por registro). Edição simultânea em dois aparelhos **não é suportada** nesta fase; o app avisa ao entrar num segundo aparelho que ele passa a ser o principal.
   - Exclusões propagadas por marcação (`deleted_at`), não por remoção física imediata.
3. **Perfil público do carro (link)**
   - Usuário publica um "snapshot" do carro: foto de capa, ficha, lista de mods instalados, linha do tempo resumida, galeria.
   - Controles de privacidade por publicação: mostrar/ocultar custos (oculto por padrão), placa (sempre oculta, sem opção de mostrar no MVP), notas, manutenções.
   - Link do tipo `garagem.app/c/<slug>`; despublicar a qualquer momento.
   - Página web leve (sem login) para quem recebe o link.
4. **IA de nota fiscal**
   - Foto da nota → envio para função no servidor → modelo de visão extrai: estabelecimento, data, itens (descrição, quantidade, valor), mão de obra, total.
   - App mostra o registro pré-preenchido; o usuário escolhe se é mod ou manutenção, ajusta e confirma. Nada é gravado sem confirmação.
   - Cota mensal no Pro (hipótese: 30 leituras/mês) para controlar custo.
5. **Veículos ilimitados** e **relatório PDF completo** do projeto (com fotos).
6. **Assinatura** via Google Play Billing.

### Fase 3 — Comunidade (só se as métricas da fase 2 forem atingidas)
- Perfil do usuário com garagem pública, seguir carros, feed de atualizações de builds.
- Busca de builds por modelo ("quem já instalou esta suspensão neste carro?").
- Integração com oficinas via AutoFlow IA (registro verificado) — avaliar.

### Backlog (sem fase definida)
- Abastecimento e consumo (já previsto no Gearhead; útil, mas não diferencia).
- Medições de desempenho (0–100, potência em dinamômetro) antes/depois de mods.
- Inventário de peças guardadas.
- Linhagem de peças (de qual carro doador veio).
- Widgets e compartilhamento rápido de "card" do carro para stories do Instagram.
- Versão iOS.

---

## 7. Modelo de dados (conceitual)

Todas as tabelas sincronizáveis precisam de: `id` (UUID estável, gerado no aparelho), `created_at`, `updated_at`, `deleted_at` (nulo se ativo). Se o Gearhead atual usa IDs inteiros autoincrementais, a troca para UUID acontece **na fase 1**, antes de existir sincronização. O Gearhead **não tem usuários reais publicados**, então o schema pode ser recriado do zero em vez de migrado.

- **Vehicle**: id, nickname, make, model, version, year, engine, fuel_type, current_km, cover_photo_id, plate (privado), archived_at.
- **Modification**: id, vehicle_id, title, category, status (planned/installed/removed), date, km, labor_cost, labor_by, notes, performance_notes, estimated_cost (para planejadas).
- **MaintenanceRecord**: id, vehicle_id, type, date, km, labor_cost, labor_by, place, notes.
- **LineItem** (peças de um mod ou manutenção): id, parent_type (modification/maintenance), parent_id, name, brand, part_code, quantity, unit_price.
- **Reminder**: id, vehicle_id, title, source_record_id (opcional), due_km, due_date, rule (km/date/first_of), done_at.
- **Attachment**: id, owner_type, owner_id, kind (photo/receipt), local_path, remote_path (fase 2), width, height.
- **KmLog**: id, vehicle_id, km, date (histórico de atualizações de km; alimenta lembretes).
- **PublicProfile** (fase 2, só nuvem): id, vehicle_id, slug, published_at, show_costs, show_maintenance, show_notes, snapshot (JSON).

Valores monetários em centavos (inteiro). Distância em km (inteiro).

---

## 8. Arquitetura

### 8.1 App
- Flutter, gerenciamento de estado com BLoC (padrão do Hugo), arquitetura em camadas (UI → BLoC → repositórios → fontes de dados).
- **Drift** como única fonte da verdade no aparelho. Toda a UI lê do Drift; a nuvem nunca é lida diretamente pela UI.
- Repositórios expõem `Stream`s do Drift; BLoCs reagem a eles.
- Notificações locais para lembretes por data.
- Fotos salvas no diretório do app; caminho relativo no banco.

### 8.2 Nuvem (fase 2)
- **Supabase**: Auth, Postgres (espelho das tabelas com `user_id` e RLS por usuário), Storage (fotos e notas), Edge Functions (IA de nota, publicação de perfil).
- **Fila de sincronização** local: cada alteração no Drift marca o registro como pendente; um serviço envia pendentes em lote quando há rede; sucesso limpa a marca.
- **IA de nota**: Edge Function recebe a imagem (já comprimida no app), chama um modelo de visão com saída em JSON estruturado, valida o esquema e devolve ao app. Provedor do modelo fica a cargo do construtor, com requisito de custo por leitura que caiba na cota do Pro.
- **Página pública**: renderizada a partir do `snapshot` publicado (não consulta dados vivos do usuário). Pode ser Edge Function servindo HTML ou site Next.js separado; escolha do construtor.

### 8.3 Privacidade e LGPD
- Plano grátis: nenhum dado do carro (registros, fotos, valores, placa) sai do aparelho.
- Telemetria: eventos anônimos de uso (ex.: "registro criado", "lembrete criado", tipo de tela), sem conteúdo dos registros, sem placa, sem localização. **Opt-in** no primeiro uso da versão pública; obrigatória e explicada no termo do beta fechado. Ferramenta a cargo do construtor. É o que alimenta os critérios da seção 9.5 e as métricas da seção 11.
- Pro: termo de consentimento e política de privacidade antes de ativar a nuvem; exclusão de conta apaga dados e fotos da nuvem.
- Fotos publicadas: avisar que podem conter placa e remover metadados EXIF (localização) antes do envio.
- Nota fiscal enviada à IA: não armazenar no provedor do modelo além do necessário; guardar só no Storage do usuário.

---

## 9. Validação de mercado (antes de programar a fase 2)

O Gearhead já existe, então a validação mede **duas coisas**: se a dor é real e frequente, e se alguém paga pelo Pro.

### 9.1 Etapa 1 — 10 conversas (1 semana)
- Público: entusiastas de grupos de modelo/marca e encontros em Goiânia.
- Sem apresentar o app. Perguntas-guia:
  1. Como você registra hoje o que fez no carro?
  2. Conte a última vez que precisou de uma informação do carro (peça, data, valor) e não achou.
  3. Quanto você acha que já investiu no projeto? Como sabe?
  4. Você já mostrou o histórico do carro para alguém (grupo, comprador)? Como?
  5. Já pagou por algum app relacionado a carro? Qual e quanto?
- Sinal positivo: a maioria descreve a dor espontaneamente e com exemplo concreto.

### 9.2 Etapa 2 — landing page com lista de espera e "porta falsa" do Pro (2–3 semanas)
- Landing em Next.js (stack já dominada pelo Hugo) explicando o app, com prints do Gearhead.
- Botão "Quero testar" (lista de espera, e-mail + modelo do carro) e seção de planos com preço do Pro visível e botão "Quero o Pro" que registra intenção e avisa que ainda não está disponível.
- Divulgação: grupos de WhatsApp/Facebook de clubes, páginas de encontros no Instagram, encontros presenciais com QR code.

### 9.3 Etapa 3 — beta fechado (paralelo à etapa 2)
- Teste fechado na Play Console com 15–20 inscritos da lista.
- Usa o build do **M1** (com custos, lembretes e UUID já migrados), não o Gearhead atual, para medir o produto que será lançado.
- Testers começam com banco vazio; não há migração de dados de beta.
- Medir uso real por 3–4 semanas via telemetria anônima (seção 8.3) + 2 perguntas rápidas por WhatsApp no fim de cada semana.

### 9.4 Etapa 4 — concierge da IA (opcional, barata)
- 5 beta testers mandam fotos de notas por WhatsApp; Hugo extrai manualmente (ou com um LLM) e devolve o registro pronto. Mede se a "IA de nota" é desejada antes de construir a função.

### 9.5 Critérios de decisão (hipóteses a calibrar)
| Métrica | Seguir | Repensar |
|---|---|---|
| Conversas com dor espontânea | ≥ 6 de 10 | ≤ 3 de 10 |
| Inscritos na lista em 3 semanas | ≥ 150 | < 50 |
| Inscritos que clicam "Quero o Pro" | ≥ 15% | < 5% |
| Beta: usuários com ≥ 3 registros na semana 3 | ≥ 40% | < 15% |

Se "repensar": voltar às direções B (passaporte para revenda) ou C (rede com oficinas via AutoFlow IA), reaproveitando o núcleo construído.

---

## 10. Monetização

| Plano | Preço (hipótese a validar) | Inclui |
|---|---|---|
| Grátis | R$ 0 | Até 2 veículos ativos, tudo local, lembretes, custos, backup por arquivo |
| Pro | R$ 9,90/mês ou R$ 79,90/ano | Veículos ilimitados, backup em nuvem, perfil público por link, IA de nota (cota mensal), PDF completo com fotos |

- Assinatura (não pagamento único) porque o Pro tem custo recorrente (armazenamento + IA).
- Teste grátis de 7 dias do Pro, cancelamento pelo próprio Google Play, aviso claro antes da renovação.
- **Ao cancelar ou ao fim do teste** (nada é apagado sem aviso):
  - veículos além do limite grátis ficam **somente leitura** (visíveis, exportáveis, sem novos registros) até o usuário arquivar algum ou voltar ao Pro;
  - links públicos saem do ar (podem ser republicados ao voltar);
  - sincronização para; os dados locais continuam completos no aparelho;
  - dados na nuvem ficam guardados por 90 dias, com aviso por e-mail aos 60 dias; depois são apagados;
  - backup por arquivo segue disponível no plano grátis.
- Receitas futuras (fase 3+, não no MVP): afiliados com lojas de peças nos mods planejados; destaque de oficinas/preparadoras.
- Referências de preço: FIXD US$ 69,99/ano; Simply Auto a partir de R$ 19,99 (único).

---

## 11. Métricas do produto (após lançamento)
- **Ativação:** novo usuário cadastra 1 carro e ≥ 3 registros em 7 dias.
- **Retenção:** % de ativos que registram algo no dia 30.
- **Conversão Pro:** % de ativos que assinam em 30 dias.
- **Uso da IA:** leituras/mês por assinante e % de leituras confirmadas sem edição grande.
- **Viralidade:** visitas por link público e instalações vindas dele.

---

## 12. Riscos e mitigação

| Risco | Impacto | Mitigação |
|---|---|---|
| Nicho pequeno ou pouco disposto a pagar | Alto | Validação da seção 9 antes da fase 2; critérios de repensar |
| Usuário desiste de registrar (atrito) | Alto | Fluxo de registro curto, IA de nota, lembretes que geram registros |
| Perda de dados na troca de celular (plano grátis) | Alto | Backup por arquivo na fase 1; lembrete periódico de backup |
| Conflitos de sincronização | Médio | Mão única, um aparelho principal, last-write-wins, `deleted_at` |
| Custo da IA maior que a receita | Médio | Cota mensal, compressão de imagem, medir custo por leitura no concierge |
| Vazamento de dados no link público | Alto | Snapshot com privacidade por padrão, placa nunca exibida, EXIF removido |
| Concorrente grande (Drivvo) copiar mods | Médio | Foco em comunidade e perfil público, que o Drivvo não prioriza |

---

## 13. Marcos

| Marco | Entrega | Pré-requisito |
|---|---|---|
| M0 | Validação parte 1: conversas + landing com lista de espera | — |
| M1 | MVP local (seção 6, fase 1) em incrementos M1a–M1d abaixo | Em paralelo com M0 |
| M1.5 | Beta fechado com o build do M1 (seção 9.3) | M1 pronto e lista de espera com ≥ 20 inscritos |
| M2 | Conta, backup em nuvem, perfil público, IA de nota, assinatura | Critérios da seção 9.5 atingidos |
| M3 | Comunidade | Métricas da seção 11 saudáveis por 2–3 meses |

### 13.1 Ritmo e tamanho
- Disponibilidade: só à noite, sem data-alvo. Estimativa de trabalho: ~7–8 h/semana (hipótese de Claude; recalibrar após o primeiro incremento).
- Cada incremento deve terminar com o app funcionando, `flutter analyze` limpo e testes do que mudou — nada de incremento pela metade parado.
- Ordem recomendada: M0 nas duas primeiras semanas junto com M1a (conversas e landing não dependem de código novo).

| Incremento | Conteúdo | Estimativa (a ~8 h/semana) |
|---|---|---|
| M1a | Schema recriado com UUID e campos de sync; LineItem (peças) e custos por categoria; status de mod (planejada/instalada/removida) | ~2 semanas |
| M1b | Lembretes por km/data + notificações locais; KmLog | ~2 semanas |
| M1c | Anexos (fotos e nota) + backup/restauração por arquivo | ~2 semanas |
| M1d | Telemetria opt-in, onboarding, limite de 2 veículos, polimento para o beta | ~1–2 semanas |

Total estimado do M1: ~7–8 semanas. Primeiro corte se atrasar: arquivar veículo e filtros da linha do tempo.

---

## 14. Abordagens consideradas

### Direção de produto
- **A — Garagem do entusiasta** (escolhida por Hugo): nicho apaixonado, sem concorrente em pt-BR, reaproveita o Gearhead. Risco: tamanho e disposição a pagar.
- B — Passaporte do carro para revenda: compete com o Drivvo no básico; histórico autodeclarado tem pouca credibilidade para o comprador.
- C — Rede dono + oficina com o AutoFlow IA: mais defensável, mas exige dois lados, backend com login e venda presencial para oficinas. Fica como evolução futura.

### Onde os dados ficam
- 1 — Só local: zero custo, mas sem link público nem uso em mais de um aparelho.
- **2 — Local-first com nuvem opcional** (escolhida por Hugo, recomendada por Claude): funciona offline e cria a divisão natural Grátis × Pro.
- 3 — Nuvem primeiro: descarta o modelo Drift atual, exige internet e tem custo desde o primeiro dia.

---

## 15. Decisões

### Tomadas por Hugo
- Direção A (garagem do entusiasta).
- Dados local-first com nuvem opcional (Drift + Supabase).
- Nome: qualquer um que não seja de produto já existente (ver seção 16).
- Gearhead não tem usuários reais: banco pode ser zerado.
- Trabalho só à noite, sem data-alvo.

### Propostas por Claude (Hugo pode corrigir)
- Sem feed social no MVP; perfil público só por link.
- IA de nota exclusiva do Pro, no servidor, sempre com confirmação do usuário.
- Lançamento só Android.
- Plano grátis com limite de 2 veículos ativos.
- Preço do Pro R$ 9,90/mês ou R$ 79,90/ano (hipótese a validar na landing).
- Sincronização em mão única com last-write-wins; um aparelho principal por vez.
- Migração para UUID na fase 1.
- Valores em centavos, distâncias em km inteiro.
- Placa nunca exibida no link público.
- Critérios numéricos de validação da seção 9.5 (hipóteses).
- Telemetria anônima opt-in, sem conteúdo dos registros.
- Beta fechado usa o build do M1, com banco zerado.
- Regras de cancelamento do Pro (somente leitura, link fora do ar, nuvem por 90 dias).
- Nome "Diário de Garagem" (seção 16).
- PDF movido da fase 1 para a fase 2.
- Ritmo de ~8 h/semana e divisão do M1 em M1a–M1d.

### Deixado para o construtor
- Pacotes Flutter específicos (notificações, câmera, PDF, billing).
- Provedor do modelo de visão da IA de nota.
- Página pública como Edge Function ou site Next.js separado.
- Formato do arquivo de backup local.
- Estrutura de pastas e nomes internos, desde que siga camadas + BLoC.

---

## 16. Nome do produto

- **"Gearhead Garage" foi descartado:** já é nome de produto existente — o jogo de PC *Snap-on Gearhead Garage: The Virtual Mechanic* (1999, Activision, endossado pela Snap-on). Risco de marca e de confusão; também é em inglês.
- **"Garagista" foi descartado:** em partes do Brasil (ex.: RS) significa revendedor de carros usados, conotação oposta à do entusiasta.
- **Proposto: "Diário de Garagem".** Em português, descreve exatamente o produto (o diário do projeto do carro) e não apareceu como app ou marca nas buscas feitas em 12/11/2026.
- **Verificar antes do primeiro upload na Play Console (bloqueante para o M1.5):**
  1. busca de marca no INPI (classe 9 — software; classe 42 — serviços de TI);
  2. busca na Play Store e na App Store;
  3. disponibilidade de domínio no registro.br (ex.: `diariodegaragem.com.br`) e @ no Instagram.
- Se qualquer verificação falhar, alternativa de reserva: "Prontuário do Carro" (também sem resultados nas buscas).
- `applicationId` definido junto com o nome, antes do primeiro upload — não pode mudar depois. Formato a cargo do construtor (ex.: domínio invertido do desenvolvedor + `.diariodegaragem`).
- O link público usa o domínio escolhido (substitui o `garagem.app` usado como exemplo na seção 6).

---

## Fontes
- Sindipeças / Jornal do Brás — frota 2025: https://jornaldobras.com.br/noticia/124190/frota-envelhecida-exige-atencao-na-compra-de-usados
- AutoPapo — histórico na revenda (OLX): https://autopapo.com.br/noticia/carro-usado-quem-ama-lucra-na-revenda/
- Comprecar — desvalorização: https://www.comprecar.com.br/blog/o-que-mais-desvaloriza-um-carro-na-hora-da-venda/
- Drivvo: https://drivvo.com/
- Canaltech — apps de gastos: https://canaltech.com.br/apps/melhores-apps-gerenciar-gastos-carro/
- CARFAX Car Care: https://apps.apple.com/us/app/-/id552472249
- CarJourney: https://www.producthunt.com/p/carjourney
- The Pit Log: https://apps.apple.com/app/id6761210335
- Builds: https://apps.apple.com/us/app/builds-car-enthusiast-hub/id6747994891
- FIXD — preço: https://www.consumeraffairs.com/automotive/fixd.html
- FIXD — reclamações: https://www.sikayetvar.com/en/fixd-us
- CarM3: https://apps.apple.com/cl/app/carm3/id6755984980
- iGarage: https://apps.apple.com/us/app/igarage/id6755206240
- Mec Box: https://apps.apple.com/us/app/id1625709361
- Gearhead Garage (jogo de 1999): https://www.chise.org/ipns/en.wikipedia-on-ipfs.org/wiki/Gearhead_Garage
