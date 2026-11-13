# M1a — Fundação do Diário de Garagem — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Criar do zero o app Flutter `diario_de_garagem`, documentado, com banco local (Drift), garagem de veículos (carro/moto), modificações e manutenções com peças, custos por categoria e orçamento do projeto.

**Architecture:** Local-first: Drift é a única fonte da verdade; a UI lê só `Stream`s dos repositórios. Camadas UI → BLoC/Cubit → repositórios → Drift. Regras de custo ficam numa função pura testável (`CostSummary.compute`), fora do banco e da UI.

**Tech Stack:** Flutter (stable), Dart 3, `flutter_bloc`, `equatable`, `drift` + `drift_flutter`, `uuid`, `shared_preferences`, `intl` (datas); dev: `drift_dev`, `build_runner`, `bloc_test`, `mocktail`, `flutter_lints`.

**Spec:** `docs/superpowers/specs/2026-11-12-diario-de-garagem-design.md` (seção 0 "Revisão 2" prevalece). Versão viva: https://claude.ai/artifact/8PqxgcEdXuG5KEsgERq16Y

## Global Constraints

- Projeto novo, do zero. Nenhum código do Gearhead nem do repositório `app_garagem_digital` é copiado.
- Nome do pacote Dart: `diario_de_garagem`. Org provisória: `br.com.diariodegaragem` → `applicationId` provisório `br.com.diariodegaragem.diario_de_garagem`. **Trocar antes do primeiro upload na Play Console** se a verificação de nome (INPI, lojas, registro.br) mudar algo.
- Plataforma: só Android no lançamento; manter o projeto compilável em iOS sem configurar publicação.
- Toda tabela sincronizável tem `id` (UUID v4 gerado no aparelho, texto), `createdAt`, `updatedAt`, `deletedAt` (nulo = ativo). Exclusão é sempre lógica (`deletedAt`), nunca `DELETE`.
- Dinheiro sempre em centavos (`int`). Proibido `double` para valores monetários. Distância em km (`int`).
- Datas gravadas como texto ISO-8601 (`store_date_time_values_as_text: true` no `build.yaml` do Drift).
- Enums gravados como texto (`textEnum<T>()`), nunca índice inteiro.
- Textos da UI em pt-BR, escritos direto no código no M1a (l10n fica para depois).
- Nenhum dado sai do aparelho no M1a: sem pacotes de rede, analytics ou Firebase.
- `flutter analyze` sem avisos e `flutter test` verde ao fim de cada tarefa.
- Commits: Conventional Commits em inglês. **Commit e push só com autorização explícita do Hugo**; sem ela, o passo "Commit" vira "preparar o comando e mostrar".

## Review Focus

1. **Entrada de dinheiro no formato brasileiro** ("1.234,56", "R$ 10", "0,5"): vira centavos exatos; texto inválido ou negativo é recusado com mensagem, nunca vira 0 em silêncio. → Task 2.
2. **Registro excluído (soft delete) não aparece** em listas, linha do tempo nem totais, inclusive peças de um registro excluído. → Tasks 4, 5 e 6.
3. **Mod planejada não conta como gasto:** entra só em "planejado"; mod removida continua contando como gasto (o dinheiro foi gasto). Orçamento estourado mostra valor negativo de "falta", sem quebrar. → Task 6.
4. **Registro antigo com km menor que o km atual** é aceito e não reduz o `currentKm` do veículo; km maior atualiza. → Task 4.
5. **Editar uma mod troca a lista de peças inteira** sem deixar peças órfãs nem duplicadas nos totais. → Task 5.

---

## Estrutura de arquivos

```
diario_de_garagem/
  README.md                         como rodar, comandos, estrutura
  CHANGELOG.md
  build.yaml                        opções do drift_dev
  analysis_options.yaml
  docs/
    ESCOPO.md                       o que o app é e não é, por fase
    ARQUITETURA.md                  camadas, regras, pastas
    decisoes/0001-local-first-drift.md
    decisoes/0002-bloc.md
    decisoes/0003-uuid-soft-delete.md
    decisoes/0004-dinheiro-em-centavos.md
    superpowers/specs/…  superpowers/plans/…
  lib/
    main.dart                       bootstrap: abre DB, prefs, roda App
    app/app.dart                    MaterialApp + RepositoryProviders + rotas
    core/clock.dart                 typedef Clock
    core/id_generator.dart          IdGenerator
    core/money.dart                 parseBrlToCents, formatBrl
    data/database/enums.dart        enums de domínio + rótulos pt-BR
    data/database/tables.dart       tabelas Drift + SyncColumns
    data/database/app_database.dart @DriftDatabase
    data/database/connection.dart   openConnection()
    data/models/drafts.dart         VehicleDraft, ModificationDraft, MaintenanceDraft, LineItemDraft
    data/models/records.dart        ModificationWithItems, MaintenanceWithItems
    data/repositories/vehicle_repository.dart
    data/repositories/modification_repository.dart
    data/repositories/maintenance_repository.dart
    data/repositories/selected_vehicle_store.dart
    domain/cost_summary.dart
    domain/timeline.dart
    features/garage/garage_bloc.dart, garage_page.dart, vehicle_form_page.dart
    features/vehicle_detail/vehicle_detail_bloc.dart, vehicle_detail_page.dart
    features/records/save_record_cubit.dart, modification_form_page.dart,
                     maintenance_form_page.dart, line_items_editor.dart
  test/  (espelha lib/)
```

---

### Task 1: Esqueleto do projeto e documentação

**Files:**
- Create: projeto via `flutter create`, `README.md`, `CHANGELOG.md`, `build.yaml`, `analysis_options.yaml`, `docs/ESCOPO.md`, `docs/ARQUITETURA.md`, `docs/decisoes/0001…0004`
- Modify: `lib/main.dart`, `test/widget_test.dart` (substituir o contador)

**Interfaces:**
- Produces: projeto que compila; pastas da estrutura acima (vazias onde ainda não há código).

- [ ] **Step 1:** Pré-requisito: Flutter stable instalado (`flutter --version`). No ambiente de nuvem do Claude não há Flutter; executar na máquina do Hugo.
- [ ] **Step 2:** `flutter create --org br.com.diariodegaragem --project-name diario_de_garagem --platforms android,ios .` na raiz do repositório (onde já estão `docs/superpowers/`).
- [ ] **Step 3:** Dependências com versões atuais resolvidas pelo pub (não fixar à mão):
  `flutter pub add flutter_bloc equatable drift drift_flutter uuid shared_preferences intl`
  `flutter pub add --dev drift_dev build_runner bloc_test mocktail`
- [ ] **Step 4:** `build.yaml` com `drift_dev` → `options: { store_date_time_values_as_text: true }`. `analysis_options.yaml`: `include: package:flutter_lints/flutter.yaml` + `analyzer.language: { strict-casts: true, strict-raw-types: true }` + exclusão de `**/*.g.dart`.
- [ ] **Step 5:** Escrever a documentação:
  - `docs/ESCOPO.md`: resumo do produto; o que entra em M1a, M1b, M1c, M1d, M2, M3 (copiar a divisão do spec); não-objetivos; link para o spec e para a versão viva.
  - `docs/ARQUITETURA.md`: camadas; "Drift é a fonte da verdade"; regras da seção Global Constraints; mapa de pastas acima; como gerar código (`dart run build_runner build --delete-conflicting-outputs`).
  - ADRs 0001–0004 no formato Contexto / Decisão / Consequências, com a justificativa do spec (seções 8, 14 e 15).
  - `README.md`: o que é, pré-requisitos, comandos (`flutter pub get`, build_runner, `flutter test`, `flutter run`), link para `docs/`.
  - `CHANGELOG.md`: seção `## [Não lançado]` com "Estrutura inicial do projeto e documentação de escopo".
- [ ] **Step 6:** `lib/main.dart` mostra um `MaterialApp` com título "Diário de Garagem" e tela vazia "Sua garagem está vazia". Teste `test/widget_test.dart`: `testWidgets('abre com garagem vazia')` → `expect(find.text('Sua garagem está vazia'), findsOneWidget)`.
- [ ] **Step 7:** `flutter analyze` → "No issues found!"; `flutter test` → todos passam.
- [ ] **Step 8:** Commit: `chore: bootstrap diario_de_garagem project and docs`.

---

### Task 2: Núcleo — dinheiro, IDs e relógio

**Files:**
- Create: `lib/core/money.dart`, `lib/core/id_generator.dart`, `lib/core/clock.dart`
- Test: `test/core/money_test.dart`, `test/core/id_generator_test.dart`

**Interfaces:**
- Produces:
  - `int parseBrlToCents(String input)` — lança `FormatException` (mensagem em pt-BR) para vazio, negativo, letras, mais de 2 casas decimais.
  - `String formatBrl(int cents)` — formatação manual, sem `intl`: `R$ 1.234,56`, espaço comum após `R$`; negativo `-R$ 10,00`.
  - `abstract interface class IdGenerator { String newId(); }` + `class UuidIdGenerator implements IdGenerator` (UUID v4).
  - `typedef Clock = DateTime Function();` e `DateTime systemClock() => DateTime.now().toUtc();`

- [ ] **Step 1: Testes que falham** (`money_test.dart`):
  - `parseBrlToCents('1.234,56') == 123456`; `('1234,5') == 123450`; `('R$ 10') == 1000`; `('0,05') == 5`; `(' 7 ') == 700`
  - `parseBrlToCents('')`, `('-5')`, `('abc')`, `('1,234')` → `throwsFormatException`
  - `formatBrl(123456) == 'R\$ 1.234,56'`; `formatBrl(5) == 'R\$ 0,05'`; `formatBrl(0) == 'R\$ 0,00'`; `formatBrl(-1000) == '-R\$ 10,00'`; `formatBrl(100000000) == 'R\$ 1.000.000,00'`
  - `id_generator_test.dart`: dois `newId()` são diferentes e casam com `^[0-9a-f-]{36}$`.
- [ ] **Step 2:** `flutter test test/core` → FAIL (funções não existem).
- [ ] **Step 3:** Implementar as interfaces acima. Parse: remover `R$` e espaços, remover pontos de milhar, trocar vírgula por ponto, validar com regex `^\d+(\.\d{1,2})?$`, converter sem `double` (separar parte inteira e decimal).
- [ ] **Step 4:** `flutter test test/core` → PASS.
- [ ] **Step 5:** Commit: `feat(core): add money parsing/formatting, id generator and clock`.

---

### Task 3: Schema Drift

**Files:**
- Create: `lib/data/database/enums.dart`, `tables.dart`, `app_database.dart`, `connection.dart`
- Test: `test/data/database/app_database_test.dart`

**Interfaces:**
- Produces:
  - Enums (`enums.dart`), cada um com `String get label` em pt-BR:
    - `VehicleType { car, motorcycle }` → "Carro", "Moto"
    - `FuelType { gasoline, ethanol, flex, diesel, electric, hybrid }`
    - `ModCategory { engine, intakeExhaust, suspension, brakes, wheelsTires, aesthetics, interior, audio, electrical, other }` → "Motor", "Admissão e escape", "Suspensão", "Freios", "Rodas e pneus", "Estética", "Interior", "Som", "Elétrica", "Outros"
    - `ModificationStatus { planned, installed, removed }` → "Planejada", "Instalada", "Removida"
    - `RegularizationStatus { pending, regularized }` → "Pendente", "Regularizado"
    - `MaintenanceType { oilChange, filters, brakes, tires, belt, fluids, alignment, service, other }` → "Troca de óleo", "Filtros", "Freios", "Pneus", "Correia", "Fluidos", "Alinhamento e balanceamento", "Revisão", "Outro"
    - `LineItemParent { modification, maintenance }`
  - `mixin SyncColumns on Table`: `id` (text, PK), `createdAt`, `updatedAt` (dateTime), `deletedAt` (dateTime nullable).
  - Tabelas → classes geradas:
    - `Vehicles` → `Vehicle`: `vehicleType`, `nickname` (1–60), `make`, `model`, `version?`, `year?`, `engine?`, `fuelType`, `currentKm` (default 0), `coverPhotoId?`, `plate?`, `projectBudgetCents?`, `archivedAt?`
    - `Modifications` → `Modification`: `vehicleId` (FK Vehicles), `title` (1–80), `category`, `status`, `date`, `km?`, `laborCostCents` (default 0), `laborBy?`, `notes?`, `performanceNotes?`, `estimatedCostCents?`, `requiresRegularization` (default false), `regularizationStatus?`
    - `MaintenanceRecords` → `MaintenanceRecord`: `vehicleId`, `type`, `date`, `km?`, `laborCostCents` (default 0), `laborBy?`, `place?`, `notes?`
    - `LineItems` → `LineItem`: `parentType`, `parentId`, `name` (1–80), `brand?`, `partCode?`, `quantity` (default 1), `unitPriceCents`
  - `class AppDatabase extends _$AppDatabase` com `schemaVersion => 1`, construtor `AppDatabase(QueryExecutor e)` e `beforeOpen` com `PRAGMA foreign_keys = ON`.
  - `QueryExecutor openConnection()` usando `driftDatabase(name: 'diario_de_garagem')`.

- [ ] **Step 1: Teste que falha:** com `AppDatabase(NativeDatabase.memory())`, inserir um `Vehicle` (`vehicleType: VehicleType.motorcycle`), uma `Modification` e um `LineItem` ligados; ler de volta e conferir `vehicleType == VehicleType.motorcycle`, `requiresRegularization == false`, `currentKm == 0`. Segundo teste: inserir `Modification` com `vehicleId` inexistente → lança (`SqliteException`, FK ativa).
- [ ] **Step 2:** `flutter test test/data/database` → FAIL.
- [ ] **Step 3:** Escrever tabelas e banco; rodar `dart run build_runner build --delete-conflicting-outputs`.
- [ ] **Step 4:** Testes → PASS; `flutter analyze` limpo.
- [ ] **Step 5:** Commit: `feat(data): add drift schema v1 with sync columns`.

---

### Task 4: Repositório de veículos e veículo selecionado

**Files:**
- Create: `lib/data/models/drafts.dart` (parte de veículo), `lib/data/repositories/vehicle_repository.dart`, `selected_vehicle_store.dart`
- Test: `test/data/repositories/vehicle_repository_test.dart`, `selected_vehicle_store_test.dart`

**Interfaces:**
- Consumes: `AppDatabase`, `IdGenerator`, `Clock` (Tasks 2–3).
- Produces:
  - `class VehicleDraft` (Equatable): `vehicleType, nickname, make, model, version?, year?, engine?, fuelType, currentKm, plate?, projectBudgetCents?`
  - `VehicleRepository(AppDatabase db, {required IdGenerator ids, required Clock clock})`:
    - `Stream<List<Vehicle>> watchActive()` — `deletedAt` e `archivedAt` nulos, ordem `createdAt` asc
    - `Stream<Vehicle?> watchById(String id)` — nulo se excluído
    - `Future<String> create(VehicleDraft d)`
    - `Future<void> update(String id, VehicleDraft d)` — atualiza `updatedAt`
    - `Future<void> raiseKm(String id, int km)` — só grava se `km > currentKm`
    - `Future<void> softDelete(String id)` — marca o veículo e todos os seus registros e peças com o mesmo `deletedAt`, numa transação
  - `SelectedVehicleStore(SharedPreferences prefs)`: `String? read()`, `Future<void> write(String? id)` (chave `selected_vehicle_id`)

- [ ] **Step 1: Testes que falham** (relógio falso que avança 1 min por chamada; IDs sequenciais falsos):
  - `create` → aparece em `watchActive`; `createdAt == updatedAt`
  - `update` → `updatedAt` > `createdAt`
  - `raiseKm(id, 50000)` com `currentKm 60000` → continua 60000; `raiseKm(id, 70000)` → 70000 (Review Focus 4)
  - `softDelete` → some de `watchActive`, `watchById` emite `null`, e mods/manutenções/peças do veículo ficam com `deletedAt` preenchido (Review Focus 2)
  - `create` com `nickname` vazio → `throwsArgumentError`
  - Store: `write('a')` e `read() == 'a'`; `write(null)` e `read() == null` (usar `SharedPreferences.setMockInitialValues({})`)
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar.
- [ ] **Step 4:** Rodar → PASS.
- [ ] **Step 5:** Commit: `feat(data): add vehicle repository and selected vehicle store`.

---

### Task 5: Repositórios de modificações e manutenções (com peças)

**Files:**
- Create: `lib/data/models/drafts.dart` (completar), `lib/data/models/records.dart`, `lib/data/repositories/modification_repository.dart`, `maintenance_repository.dart`
- Test: `test/data/repositories/modification_repository_test.dart`, `maintenance_repository_test.dart`

**Interfaces:**
- Consumes: `VehicleRepository.raiseKm` (Task 4).
- Produces:
  - `LineItemDraft(name, {brand, partCode, quantity = 1, required unitPriceCents})`
  - `ModificationDraft(vehicleId, title, category, status, date, {km, laborCostCents = 0, laborBy, notes, performanceNotes, estimatedCostCents, requiresRegularization = false, regularizationStatus})`
  - `MaintenanceDraft(vehicleId, type, date, {km, laborCostCents = 0, laborBy, place, notes})`
  - `class ModificationWithItems(Modification modification, List<LineItem> items)` e `class MaintenanceWithItems(MaintenanceRecord record, List<LineItem> items)`, ambos com `int get partsTotalCents` e `int get totalCents` (peças + mão de obra)
  - `ModificationRepository(AppDatabase db, VehicleRepository vehicles, {required IdGenerator ids, required Clock clock})`:
    - `Stream<List<ModificationWithItems>> watchByVehicle(String vehicleId)` — sem excluídos (registro e peças)
    - `Future<String> save(ModificationDraft d, List<LineItemDraft> items, {String? id})` — numa transação: cria ou atualiza; marca as peças antigas com `deletedAt` e insere as novas; chama `vehicles.raiseKm` se `d.km != null`
    - `Future<void> softDelete(String id)` — registro + peças
  - `MaintenanceRepository` com a mesma forma (`watchByVehicle`, `save(MaintenanceDraft, items, {id})`, `softDelete`).
  - Validação em `save` → `ArgumentError`: título vazio; `quantity < 1`; `unitPriceCents < 0`; `laborCostCents < 0`; `regularizationStatus != null` com `requiresRegularization == false`. Se `requiresRegularization == true` e status nulo → grava `RegularizationStatus.pending`.

- [ ] **Step 1: Testes que falham:**
  - salvar mod com 2 peças (2 × R$ 150,00 e 1 × R$ 80,00) + mão de obra R$ 100,00 → `totalCents == 48000`
  - editar a mesma mod com 1 peça (1 × R$ 200,00) → `items.length == 1`, `totalCents == 30000` (Review Focus 5)
  - `softDelete` da mod → some de `watchByVehicle` (Review Focus 2)
  - `requiresRegularization: true` sem status → grava `pending`; status com `requiresRegularization: false` → `throwsArgumentError`
  - `quantity: 0` ou `unitPriceCents: -1` → `throwsArgumentError`
  - `km: 80000` com veículo em 60000 → veículo vai a 80000
  - manutenção: mesmos casos de peças, edição e exclusão
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar.
- [ ] **Step 4:** Rodar → PASS.
- [ ] **Step 5:** Commit: `feat(data): add modification and maintenance repositories with line items`.

---

### Task 6: Regras de custo e linha do tempo

**Files:**
- Create: `lib/domain/cost_summary.dart`, `lib/domain/timeline.dart`
- Test: `test/domain/cost_summary_test.dart`, `timeline_test.dart`

**Interfaces:**
- Consumes: `ModificationWithItems`, `MaintenanceWithItems` (Task 5).
- Produces:
  - `class CostSummary` (Equatable): `int spentCents`, `int plannedCents`, `int modsSpentCents`, `int maintenanceSpentCents`, `Map<ModCategory, int> spentByCategory` (só categorias com valor > 0), `int? budgetCents`, `int? remainingCents` (= budget − spent; nulo sem orçamento; pode ser negativo)
  - `static CostSummary compute({required List<ModificationWithItems> mods, required List<MaintenanceWithItems> maintenance, int? budgetCents})`
  - Regras: mods `installed` e `removed` entram no gasto; `planned` entra só em `plannedCents`, usando `totalCents` se o custo registrado for maior que zero (peças vivas + mão de obra > 0, função única `hasRecordedCost` em `lib/domain/cost_summary.dart`, usada também pela linha do tempo), senão `estimatedCostCents ?? 0`. Peças cadastradas sem preço contam como mod ainda não orçada (decisão da revisão final: tela e total precisam concordar); toda manutenção entra no gasto.
  - `sealed class TimelineEntry` com `ModificationEntry(ModificationWithItems)` e `MaintenanceEntry(MaintenanceWithItems)`; `List<TimelineEntry> buildTimeline(mods, maintenance)` — ordem `date` desc, empate por `km` desc (nulo por último).

- [ ] **Step 1: Testes que falham:**
  - mod instalada R$ 300 (suspensão) + mod removida R$ 100 (som) + mod planejada sem peças com estimativa R$ 2.000 + manutenção R$ 250, orçamento R$ 500 → `spentCents 65000`, `plannedCents 200000`, `spentByCategory {suspension: 30000, audio: 10000}`, `remainingCents -15000` (Review Focus 3)
  - sem orçamento → `budgetCents` e `remainingCents` nulos
  - listas vazias → tudo 0, `spentByCategory` vazio
  - timeline: três registros com datas diferentes → ordem desc; dois na mesma data → maior km primeiro
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar (funções puras, sem Flutter nem Drift além dos tipos).
- [ ] **Step 4:** Rodar → PASS.
- [ ] **Step 5:** Commit: `feat(domain): add cost summary and timeline`.

---

### Task 7: Garagem (BLoC + telas de lista e cadastro de veículo)

**Files:**
- Create: `lib/app/app.dart`, `lib/features/garage/garage_bloc.dart`, `garage_page.dart`, `vehicle_form_page.dart`
- Modify: `lib/main.dart` (abre `AppDatabase(openConnection())`, `SharedPreferences`, injeta repositórios via `MultiRepositoryProvider`)
- Test: `test/features/garage/garage_bloc_test.dart`, `garage_page_test.dart`

**Interfaces:**
- Consumes: `VehicleRepository`, `SelectedVehicleStore`.
- Produces:
  - Eventos: `GarageStarted()`, `GarageVehicleSelected(String id)`, `GarageVehicleCreated(VehicleDraft draft)`
  - `GarageState(status: GarageStatus {loading, ready, failure}, vehicles: List<Vehicle>, selectedId: String?, errorMessage: String?)`
  - Seleção: ao iniciar, usa o id salvo se ainda estiver ativo; senão o primeiro veículo; senão nulo. Ao criar, o novo veículo vira o selecionado.
  - Telas: `GaragePage` (lista com apelido, marca/modelo, ícone carro/moto; vazio = "Sua garagem está vazia" + botão "Adicionar veículo"; tocar abre o detalhe da Task 8), `VehicleFormPage` (campos do `VehicleDraft`; orçamento e km usam `parseBrlToCents`/inteiro; obrigatórios: tipo, apelido, marca, modelo, combustível).

- [ ] **Step 1: Testes que falham** (`bloc_test` + `mocktail`):
  - `GarageStarted` com 2 veículos e id salvo do segundo → `ready`, `selectedId` = segundo
  - id salvo inexistente → seleciona o primeiro e grava no store
  - `GarageVehicleCreated` → chama `create` e seleciona o id retornado
  - repositório lança → `failure` com `errorMessage`
  - widget: garagem vazia mostra o texto e o botão; formulário com apelido vazio mostra "Informe o apelido"; orçamento "abc" mostra a mensagem do `FormatException`
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar.
- [ ] **Step 4:** Rodar → PASS; `flutter run` no emulador: cadastrar carro e moto, fechar e reabrir o app, seleção mantida.
- [ ] **Step 5:** Commit: `feat(garage): add garage bloc, list and vehicle form`.

---

### Task 8: Detalhe do veículo, formulários de registro e fechamento do M1a

**Files:**
- Create: `lib/features/vehicle_detail/vehicle_detail_bloc.dart`, `vehicle_detail_page.dart`, `lib/features/records/save_record_cubit.dart`, `modification_form_page.dart`, `maintenance_form_page.dart`, `line_items_editor.dart`
- Modify: `CHANGELOG.md`, `docs/ESCOPO.md` (marcar M1a como concluído)
- Test: `test/features/vehicle_detail/vehicle_detail_bloc_test.dart`, `test/features/records/save_record_cubit_test.dart`, `modification_form_page_test.dart`

**Interfaces:**
- Consumes: repositórios (Tasks 4–5), `CostSummary.compute`, `buildTimeline` (Task 6), `formatBrl`/`parseBrlToCents` (Task 2).
- Produces:
  - `VehicleDetailBloc(String vehicleId, …repos)`: evento `VehicleDetailStarted()`; estado `VehicleDetailState(status: VehicleDetailStatus {loading, ready, notFound, failure}, vehicle: Vehicle?, timeline: List<TimelineEntry>, summary: CostSummary?)`. Junta os três streams; veículo excluído → status `notFound`.
  - `SaveRecordCubit(…repos)`: `saveModification(ModificationDraft, List<LineItemDraft>, {String? id})`, `saveMaintenance(MaintenanceDraft, List<LineItemDraft>, {String? id})`, `delete…`; estados `idle | saving | saved | failure(message)`; `ArgumentError` vira mensagem em pt-BR.
  - Tela de detalhe: cabeçalho (apelido, tipo, km atual); bloco de orçamento ("Gasto R$ X de R$ Y — falta R$ Z" ou "Acima do orçamento em R$ Z"; sem orçamento: só "Gasto R$ X"); "Planejado: R$ P"; lista por categoria; linha do tempo (mods com selo do status e aviso "Regularização pendente" quando aplicável; manutenções com tipo); botão para nova mod / nova manutenção; tocar num item abre edição.
  - Formulário de mod: título, categoria, status, data, km, peças (`LineItemsEditor`: adicionar/remover linhas nome, marca, qtd, valor), mão de obra, quem fez, notas, nota de desempenho, custo estimado (só quando planejada), chave "Exige regularização (CSV)" + status. Formulário de manutenção análogo, sem status nem regularização.

- [ ] **Step 1: Testes que falham:**
  - bloc: veículo com 1 mod instalada e 1 manutenção → `timeline.length == 2` e `summary.spentCents` igual à soma
  - bloc: veículo excluído → `notFound`
  - cubit: repositório lança `ArgumentError` → `failure` com mensagem não vazia
  - widget: ligar "Exige regularização" mostra o seletor de status com "Pendente" pré-selecionado; status "Planejada" mostra o campo "Custo estimado"; status "Instalada" esconde
  - widget: adicionar duas peças e remover uma → resta uma linha
- [ ] **Step 2:** Rodar → FAIL.
- [ ] **Step 3:** Implementar.
- [ ] **Step 4:** `flutter test` completo → PASS; `flutter analyze` limpo; no emulador: criar mod planejada → instalar → conferir que sai de "Planejado" e entra em "Gasto"; excluir manutenção → some dos totais.
- [ ] **Step 5:** Atualizar `CHANGELOG.md` (garagem com carros e motos, modificações e manutenções com peças, custos por categoria, orçamento do projeto, marcação de regularização) e marcar M1a como concluído em `docs/ESCOPO.md`.
- [ ] **Step 6:** Commit: `feat(records): add vehicle detail, record forms and cost overview`.
