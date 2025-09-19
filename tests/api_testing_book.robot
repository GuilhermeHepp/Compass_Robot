*** Settings ***
Resource    ../resources/api_testing_book.resource
Suite Setup    Criar sessão para API
  

*** Test Cases ***
cenario 1: criar um novo booking
    Criar um novo booking
    Conferir se o booking foi criado com sucesso

cenario 2: consultar um booking existente
    Consultar um booking existente
    Conferir se o booking foi consultado com sucesso

cenario 3: atualizar um booking existente
    Atualizar um booking existente
    Conferir se o booking foi atualizado com sucesso

cenario 4: deletar um booking existente
    Deletar um booking existente
    Conferir se o booking foi deletado com sucesso

