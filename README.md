# Desafio - Sistema de Contas bancárias

## Como executar o projeto
1. Baixar o código desse repositório
2. Executar o bundle install na raiz do projeto
3. Executar 'rails s'

## API endpoints (Exemplos de curls)

### Contas
1. Criar contas: URL: http://localhost:3000/accounts/ - Method: POST
```shell
curl -X POST \
  http://localhost:3000/accounts/ \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
  "id" : 1, # Parâmetro opcinal
	"name" : "Conta 1",
	"balance": 1000 # Saldo em centavos
}'
```
Resposta:
```
{
    "id": 1,
    "access_token": "mid6v4gogpmylix16fim" # token gerado pela aplicação
}
```
2. Consultar saldo de uma conta: URL: http://localhost:3000/accounts/{account_id} - Method: GET
```shell
curl -X GET \
  http://localhost:3000/accounts/1 \
  -H 'cache-control: no-cache' \
```
Resposta:
```
{
    "id": 1,
    "name": "Conta 1",
    "balance": 1000
}
```
### Transferência
1. Criar transferência: URL: http://localhost:3000/transfers/ - Method - POST
```shell
curl -X POST \
  http://localhost:3000/transfers/ \
  -H 'authorization: Token token=mid6v4gogpmylix16fim' \ # TOKEN DA CONTA DE ORIGEM
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
  "account_id": 1, # ID da conta de origem
  "destination_account_id": 2, # ID da conta de destino
  "amount": 100 # Valor, em centavos, da transfrência
}'
```
Resposta:
```
{
  "account_id": 1,
  "destination_account_id": 2, 
  "amount": 100
}
```
2. Consultar transferências: URL: http://localhost:3000/transfers/ - Method - GET
```shell
[
    {
        "id": 1,
        "source_account_id": 1,
        "destination_account_id": 2,
        "amount": 100
    }
]
```

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
