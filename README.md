# Diário de Garagem

App Flutter para quem modifica e cuida do próprio carro ou moto registrar tudo o que o veículo já recebeu: modificações, manutenção, peças, custos e orçamento, numa linha do tempo por veículo. Funciona sem internet e sem conta; no M1a nenhum dado sai do aparelho.

Status: M1a (fundação) em construção. Plataforma de lançamento: Android. O projeto se mantém compilável em iOS, sem publicação configurada.

## Pré-requisitos

- Flutter stable (Dart 3). Confira com `flutter --version`.
- Android SDK e um emulador ou aparelho para `flutter run`.

## Comandos

```bash
flutter pub get                                              # dependências
dart run build_runner build --delete-conflicting-outputs     # gera código do Drift
flutter analyze                                              # análise estática (deve dar "No issues found!")
flutter test                                                 # testes
flutter run                                                  # roda no emulador/aparelho
```

## Documentação

- [docs/ESCOPO.md](docs/ESCOPO.md): o que o app é, o que entra em cada marco e o que fica de fora.
- [docs/ARQUITETURA.md](docs/ARQUITETURA.md): camadas, regras, mapa de pastas e direção visual.
- [docs/decisoes/](docs/decisoes/): registros de decisão de arquitetura (ADRs).
- [Spec de design](docs/superpowers/specs/2026-11-12-diario-de-garagem-design.md) e [plano do M1a](docs/superpowers/plans/2026-11-12-m1a-fundacao.md).

## Fontes

Barlow e Barlow Condensed (`assets/fonts/`) são distribuídas sob a SIL Open Font License 1.1; o texto da licença está em `assets/fonts/OFL.txt`.
