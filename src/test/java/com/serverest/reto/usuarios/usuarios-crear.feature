
Feature: Registrar usuarios en ServeRest

  Background:
    * url baseUrl

  Scenario: Registrar un usuario con datos válidos
    * def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def usuario =
      """
      {
        "nome": "Usuario QA",
        "email": "#(email)",
        "password": "Test1234",
        "administrador": "false"
      }
      """

    Given path 'usuarios'
    And request usuario
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#string'
    * def idCreado = response._id

    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response.email == email
    And match response.nome == 'Usuario QA'

    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200

  Scenario: Rechazar un correo electrónico duplicado
    * def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def usuario =
      """
      {
        "nome": "Usuario QA",
        "email": "#(email)",
        "password": "Test1234",
        "administrador": "false"
      }
      """

    Given path 'usuarios'
    And request usuario
    When method POST
    Then status 201
    * def idCreado = response._id

    Given path 'usuarios'
    And request usuario
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200
