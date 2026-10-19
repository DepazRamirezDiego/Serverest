
Feature: Consultar usuarios por ID

  Background:
    * url baseUrl

  Scenario: Consultar un usuario existente
    * def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def usuario =
      """
      {
        "nome": "Usuario Consulta",
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

    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response ==
      """
      {
        nome: '#string',
        email: '#string',
        password: '#string',
        administrador: '#string',
        _id: '#string'
      }
      """
    And match response.nome == 'Usuario Consulta'
    And match response.email == email

    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200

  Scenario: Consultar un ID inexistente
    Given path 'usuarios', 'id-inexistente-qa'
    When method GET
    Then status 400
    * print 'RESPUESTA COMPLETA:', response
    * print 'TIPO DE RESPUESTA:', typeof response
