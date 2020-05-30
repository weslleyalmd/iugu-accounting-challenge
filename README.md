# Desafio - Sistema de Contas bancárias

## Objetivo

Desenvolver um sistema que irá gerenciar contas bancárias de clientes, permitindo fazer transferências de um cliente para outro e expor o saldo atual da conta, sempre em reais.

## Execução

### Funcionalidade #1 - Criar Conta

Entrada: `<id da conta: opcional>, <nome da conta>, <saldo inicial>`

Fluxo principal:

1. Cliente envia informações da conta
2. O sistema valida todos os dados
3. O sistema responde com as informações da conta criada e um token de autenticação

*Fluxo excepcional*: id da conta já existe

1. Retornar que o id já foi utilizado

Saída: `<id da conta>, <token>`

### Funcionalidade #2 - Transferir dinheiro

Entrada: ​ `<source_account_id>, <destination_account_id>, <amount>`

Fluxo principal:

1. O cliente faz uma requisição com os dados descritos acima
2. O sistema valida todos os dados
3. O sistema computa um débito na conta de origem
4. O sistema computa um crédito na conta de destino

**Fluxo excepcional**: a conta de origem não possui saldo suficiente

1. O sistema cancela a transferência

### Funcionalidade #3 - Consultar saldo
Entrada: ​ `<account_id>`

Fluxo principal:
1. O cliente faz uma requisição com os dados descritos acima
2. O sistema calcula o saldo atual da conta baseado no histórico de transferências
da conta

**Fluxo excepcional**: Conta inexistente
1. O sistema responde que a conta informada não existe
