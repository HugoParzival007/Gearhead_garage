# 0003. UUID no aparelho e exclusão lógica

## Contexto

A sincronização do M2 (mão única, last-write-wins) precisa de identificadores que não colidam entre aparelhos e de uma forma de propagar exclusões. IDs inteiros autoincrementados e `DELETE` físico impedem as duas coisas. O Gearhead anterior não tem usuários reais, então o banco pode ser recriado.

## Decisão

Toda tabela sincronizável tem `id` (UUID v4 em texto, gerado no aparelho), `createdAt`, `updatedAt` e `deletedAt` (nulo = ativo). Excluir é sempre preencher `deletedAt`; nunca se usa `DELETE`. Listas, linha do tempo e totais ignoram registros excluídos. Datas são gravadas como texto ISO-8601.

## Consequências

- Sincronização futura sem migração de IDs; exclusões propagam por marcação.
- Toda consulta precisa filtrar `deletedAt IS NULL`; isso é coberto por testes nos repositórios e nos custos.
- O banco cresce com registros excluídos; limpeza física fica para depois, se necessário.
