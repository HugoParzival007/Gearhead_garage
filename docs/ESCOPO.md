# Escopo

## Produto

Diário de Garagem é o diário do projeto do carro (ou moto) do entusiasta brasileiro: modificações, manutenção, peças, custos e fotos numa linha do tempo por veículo, em português. Funciona sem internet e sem conta. Não é um app de controle de gastos genérico.

Spec completo: [design](superpowers/specs/2026-11-12-diario-de-garagem-design.md) (a seção 0, "Revisão 2", prevalece). Versão viva: https://claude.ai/artifact/8PqxgcEdXuG5KEsgERq16Y

## Marcos

| Marco | Entrega |
|---|---|
| M1a | Fundação: schema Drift com UUID e campos de sync; garagem de veículos (carro ou moto); modificações e manutenções com peças (LineItem); custos por categoria; status de mod (planejada/instalada/removida); orçamento do projeto por veículo; campos de regularização (CSV) |
| M1b | Lembretes por km ou data (o que vier primeiro) + notificações locais; KmLog |
| M1c | Anexos (fotos e nota fiscal) + backup e restauração por arquivo; anexo CSV de regularização |
| M1d | Telemetria opt-in, onboarding, limite de 2 veículos ativos, polimento para o beta |
| M2 | Conta, backup em nuvem, perfil público por link, IA de nota fiscal, relatório PDF, veículos ilimitados, assinatura Pro |
| M3 | Comunidade (só se as métricas do M2 forem atingidas) |

Primeiro corte se o M1 atrasar: arquivar veículo e filtros da linha do tempo.

## Não-objetivos

- Feed social, curtidas, seguidores, comentários e chat (só no M3).
- Leitura OBD2 e hardware.
- Gestão de frota, motoristas de aplicativo e empresas.
- Integração com oficinas.
- Consulta de débitos, multas, IPVA e documentos do Detran.
- Marketplace de peças ou serviços.
- iOS no lançamento (o código permite; publicação e testes ficam para depois).
- No M1a: rede, analytics, Firebase e qualquer envio de dados para fora do aparelho.
- Abastecimento e consumo (backlog).
