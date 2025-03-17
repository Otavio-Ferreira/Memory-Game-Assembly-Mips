# Jogo da Memória - Assembly Mips

## 1. Descrição do Circuito

Este projeto consiste na implementação de um jogo da memória, com um tauleiro 4x4. O jogo foi desenvolvido em Assembly Mips durante as aulas de Arquitetura e Organização de Computadores na Universidade Federal do Cariri (UFCA) pelo aluno Otavio da Silva Ferreira.

### Funcionamento
O jogo da memória consiste em um tabuleiro 4x4 onde será pedido ao usuário para digitar números conforme a ordem da tabela a seguir:

| Ordem | Menssagem | Significado |
|---|---|---|
| 1 | Enter the row coordinate of first card | Linha do primeiro card |
| 2 | Enter the column coordinate of first card | Coluna do primeiro card |
| 3 | Enter the row coordinate of second card | Linha do segundo card |
| 4 | Enter the column coordinate of second card | Coluna do segundo card |

Durante o processo os números digitados estão sujeitos à validações e caso digitados errados terá que iniciar o processo de escolher o card novamente, para obter sucesso ao escolher o card deve levar em consideração as seguintes regras:

1. Digitar entre 0 e 3 pois o tabuleiro é 4x4
2. Escolher posições que ainda não foram reveladas

## 2. Explicação do código

### Armazenamento de varáveis em .data:

#### Código:

```
.data

board: .word 1,2,3,4,1,2,3,4,5,6,7,8,5,6,7,8

revealed: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

msg_first_row: .asciiz "Enter the row coordinate of first card: "
msg_first_column: .asciiz "Enter the column coordinate of first card: "
msg_second_row: .asciiz "Enter the row coordinate of second card: "
msg_second_column: .asciiz "Enter the column coordinate of second card: "
msg_match: .asciiz "Match found! \n\n"
msg_dont_match: .asciiz "No match! \n\n"
msg_all_pairs_find: .asciiz "Congratulations! You found all pairs!"
msg_already_exists: .asciiz "\nThe entered pair has already been chosen! Try again! \n\n"
msg_invalid_input: .asciiz "\nThe number must be between 0 and 3! Try again! \n\n"

hidden_symbol: .ascii "*"

pairsLeft: .word 8

cl: .asciiz "\n"
cl2: .asciiz "\n\n"
space: .asciiz " "

```

#### Tabela de variáveis:

| Variável | Significado |
|-|-|
| board | Tabuleiro com os números para os cards |
| revealed | Tabuleiro auxiliar para imprimir e armazenar as posições escolhidas |
| msg_first_row | Menssagem para a linha do primeiro dígito |
| msg_first_column | Menssagem para a coluna do primeiro dígito |
| msg_second_row | Menssagem para a linha do segundo dígito |
| msg_second_column | Menssagem para a coluna do segundo dígito |
| msg_match | Menssagem para caso o par seja encontrado |
| msg_dont_match | Menssagem para caso o par não seja encontrado |
| msg_all_pairs_find | Menssagem para caso todos os pares sejam encontrados |
| msg_already_exists | Menssagem para caso o card ja tenha sido revelado |
| msg_invalid_input | Menssagem para caso o número seja inválido |
| hidden_symbol | Caractere "*"
| pairsLeft | Número de pares restantes
| cl | Quebra de linha "\n"
| cl2 | Quebra de linha dupla "\n\n"
| space | Espaçamento

### Explicação das funções em .text:

| Função | Significado |
|-|-|
| main | Função principal que engloba todas as outras funções |
| While | Função While é onde está o loop principal |
| PrintBoard | Função que mostra o tabuleiro no console |
| IfNumberValidationFirstCase | Função de condição para validar se os números do primeiro card foram digitados corretamente |
| IfNumberValidationSecondCase | Função de condição para validar se os números do segundo card foram digitados corretamente |
| IfNumberIsAlreadySelectedFirstCase | Função de condição para validar se o primeiro card escolhido ainda não foi revelado |
| IfNumberIsAlreadySelectedSecondCase | Função de condição para validar se o segundo card escolhido ainda não foi revelado |
| checkMatch | Função que verifica se os números das posições escolhidas de 'baoard' são iguais |
| NotMatchCheck | Função que retirna 0 caso os números das posições escolhidas de 'baoard' não sejam iguais |
| MatchFound | Função que decrementa 'pairsLeft' caso um par seja encontrado |
| NotMatch | Função que coloca 0 novamente nas posições escolhidas em 'revealed' caso o par não seja igual |
| Continue | Funlção que retorna ao início do loop |
| Exit | Função caso todos os pares sejam encontrados |