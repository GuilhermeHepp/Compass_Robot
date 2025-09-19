*** Settings ***
Resource    ../resources/api_testing_auth.resource

*** Variables ***

*** Test Cases ***
cenario 1: criar um novo token para usuario utilizar o Restful-booking
    Criar sessão para API
    Criar um token novo
    Conferir se o token foi criado com sucesso