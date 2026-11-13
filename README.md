# Diário de Garagem

App Flutter para quem modifica e cuida do próprio carro ou moto registrar tudo o que o veículo já recebeu: modificações, manutenção, peças, custos e orçamento, numa linha do tempo por veículo. Funciona sem internet e sem conta; no M1a nenhum dado sai do aparelho.

Status: M1a (fundação) concluído; falta a verificação manual no emulador (abaixo). Plataforma de lançamento: Android. O projeto se mantém compilável em iOS, sem publicação configurada.

## Pré-requisitos

- Flutter 3.50 ou mais novo (Dart 3.14 ou mais novo). Confira com `flutter --version`.
- Android SDK e um emulador ou aparelho para `flutter run`.

## Comandos

```bash
flutter pub get                                              # dependências
dart run build_runner build --delete-conflicting-outputs     # gera código do Drift
flutter analyze                                              # análise estática (deve dar "No issues found!")
flutter test                                                 # testes
flutter run                                                  # roda no emulador/aparelho
```

## Verificação manual pendente

Sem emulador no ambiente de desenvolvimento do M1a; conferir num aparelho ou emulador Android:

- [ ] `flutter run`: o nome no launcher é "Diário de Garagem".
- [ ] Garagem vazia: texto, descrição e botão; modo claro e escuro seguem o sistema.
- [ ] Cadastrar um carro e uma moto: ícones, selo "Selecionado" no recém-criado, botão amarelo.
- [ ] Fechar e reabrir o app: o veículo selecionado continua o mesmo.
- [ ] Detalhe do veículo: "Editar veículo" na barra superior abre o formulário preenchido; incluir um orçamento e salvar atualiza o medidor.
- [ ] Seletor de data em português (meses, "Cancelar"/"Confirmar") e digitação no formato dd/mm/aaaa.
- [ ] Formulário de veículo: mensagens de obrigatório; orçamento "abc", "1.234,567" e "R$ 15.000,00"; apelido limitado a 60; teclado só com números no km.
- [ ] Detalhe do veículo: criar mod planejada com custo estimado (entra em "Planejado"), editar para "Instalada" com peças (sai de "Planejado" e entra em "Gasto").
- [ ] Excluir uma manutenção (com confirmação): some da linha do tempo e dos totais.
- [ ] Medidor de orçamento: dentro do orçamento, estourado (excesso em vermelho após a linha vermelha) e sem orçamento (só "Gasto R$ X").
- [ ] Ligar "Exige regularização (CSV)": "Pendente" pré-selecionado; aviso "Regularização pendente" na linha do tempo.
- [ ] Barlow e Barlow Condensed carregadas (não a fonte padrão); foco visível com teclado ou d-pad; alvos de 48dp; TalkBack lê o texto do orçamento e "Carro"/"Moto"; animação do medidor desligada com "Remover animações".

## Documentação

- [docs/ESCOPO.md](docs/ESCOPO.md): o que o app é, o que entra em cada marco e o que fica de fora.
- [docs/ARQUITETURA.md](docs/ARQUITETURA.md): camadas, regras, mapa de pastas e direção visual.
- [docs/decisoes/](docs/decisoes/): registros de decisão de arquitetura (ADRs).
- [Spec de design](docs/superpowers/specs/2026-11-12-diario-de-garagem-design.md) e [plano do M1a](docs/superpowers/plans/2026-11-12-m1a-fundacao.md).

## Fontes

Barlow e Barlow Condensed (`assets/fonts/`) são distribuídas sob a SIL Open Font License 1.1; o texto da licença está em `assets/fonts/OFL.txt`.
