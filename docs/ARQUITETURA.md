# Arquitetura

## Camadas

UI (`features/`) → BLoC/Cubit → repositórios (`data/repositories/`) → Drift (`data/database/`).

- **Drift é a fonte da verdade** no aparelho. A UI lê só `Stream`s expostos pelos repositórios; BLoCs reagem a eles.
- Regras de negócio puras (custos, linha do tempo) ficam em `domain/`, testáveis sem banco nem UI.
- A nuvem (M2) nunca será lida diretamente pela UI.

## Regras

- Projeto novo, do zero: nenhum código do Gearhead nem do `app_garagem_digital` é copiado.
- Toda tabela sincronizável tem `id` (UUID v4 gerado no aparelho, texto), `createdAt`, `updatedAt` e `deletedAt` (nulo = ativo). Exclusão é sempre lógica, nunca `DELETE`.
- Dinheiro sempre em centavos (`int`); proibido `double` para valores monetários. Distância em km (`int`).
- Datas gravadas como texto ISO-8601 (`store_date_time_values_as_text: true` em `build.yaml`).
- Enums gravados como texto (`textEnum<T>()`), nunca índice inteiro.
- Textos da UI em pt-BR, direto no código no M1a (l10n depois). O `MaterialApp` fixa o locale `pt_BR` com `GlobalMaterialLocalizations.delegates` (exportado por `material_ui`, sem dependência nova): seletor de data, botões e textos do Material em português, e digitação de data no formato dd/mm/aaaa.
- A UI importa `package:material_ui/material_ui.dart`, nunca `package:flutter/material.dart`. Motivo: no Flutter 3.50 os widgets Material saíram do SDK para o pacote `material_ui`, e `package:flutter/material.dart` ficou marcado como `@Deprecated`. O próprio `flutter create` do 3.50 já gera o projeto com `material_ui`. Importar o caminho antigo gera avisos de obsolescência e quebra a regra de `flutter analyze` sem avisos. O pacote é local (sem rede), e a versão fica no `pubspec.yaml`.
- Nenhum dado sai do aparelho no M1a: sem pacotes de rede, analytics ou Firebase.
- `flutter analyze` sem avisos e `flutter test` verde ao fim de cada tarefa.
- Commits em Conventional Commits, em inglês.

## Mapa de pastas

```
lib/
  main.dart                  bootstrap
  app/                       MaterialApp, tema, providers, rotas
  core/                      Clock, IdGenerator, dinheiro (parseBrlToCents, formatBrl)
  data/database/             enums, tabelas Drift, AppDatabase, conexão
  data/models/               drafts (entrada) e records (saída com peças)
  data/repositories/         veículos, modificações, manutenções, veículo selecionado
  domain/                    CostSummary, timeline
  features/garage/           lista e cadastro de veículos
  features/vehicle_detail/   detalhe, custos, orçamento
  features/records/          formulários de modificação e manutenção, editor de peças
test/                        espelha lib/
assets/fonts/                Barlow e Barlow Condensed (OFL)
docs/decisoes/               ADRs
```

## Geração de código

Drift gera `*.g.dart`. Depois de mudar tabelas ou o banco:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Os arquivos `*.g.dart` são excluídos da análise estática.

## Direção visual

Referência: caderneta de revisão carimbada, manual de oficina, painel de instrumentos. Uso na garagem (luz ruim, mãos sujas): alvos de toque de pelo menos 48dp.

- **Paleta:** grafite `#22303A` (tinta, texto, AppBar); papel `#EEF1EC` (fundo claro, cinza-esverdeado frio); aço `#8A97A3` (texto secundário, divisores, trilho do medidor); sinal `#F2B705` (amarelo de oficina, só medidor de orçamento e botão principal); instalado `#3F7D5A` (selo "Instalada"); faixa-vermelha `#C8102E` (orçamento estourado, regularização pendente, erros). Modo escuro: fundo `#141B21`, superfície `#1E2830`, texto `#E3E8E4`.
- **Fontes:** Barlow Condensed (600/700) para títulos, apelido do veículo, valores e km (algarismos tabulares); Barlow (400/500) para corpo e formulários. Escala 32/24/20/16/14/12; sentence case.
- **Elemento-assinatura:** o medidor de orçamento no detalhe do veículo, uma barra estilo marcador de combustível com traços a cada 25%, preenchimento amarelo-sinal até o gasto e excesso em vermelho além da "linha vermelha". O resto da interface é quieto: linhas de caderneta, selos de status com cantos de 4dp, sem sombras nem gradientes.
