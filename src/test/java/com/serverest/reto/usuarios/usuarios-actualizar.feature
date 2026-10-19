
Feature: Actualizar usuarios en ServeRest

  Background:
    * url baseUrl

  Scenario: Actualizar los datos de un usuario existente
    * def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def usuario =
      """
      {
        "nome": "Usuario Original",
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

    * def usuarioActualizado =
      """
      {
        "nome": "Usuario Actualizado",
        "email": "#(email)",
        "password": "NuevaClave123",
        "administrador": "false"
      }
      """

    Given path 'usuarios', idCreado
    And request usuarioActualizado
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response.nome == 'Usuario Actualizado'
    And match response.password == 'NuevaClave123'

    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200

  Scenario: Rechazar la actualización con un correo duplicado
    * def email1 = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def email2 = 'qa-' + java.util.UUID.randomUUID() + '@example.com'

    * def usuario1 =
      """
      {
        "nome": "Usuario Uno",
        "email": "#(email1)",
        "password": "Test1234",
        "administrador": "false"
      }
      """

    * def usuario2 =
      """
      {
        "nome": "Usuario Dos",
        "email": "#(email2)",
        "password": "Test1234",
        "administrador": "false"
      }
      """

    Given path 'usuarios'
    And request usuario1
    When method POST
    Then status 201
    * def id1 = response._id

    Given path 'usuarios'
    And request usuario2
    When method POST
    Then status 201
    * def id2 = response._id

    * def usuarioDuplicado =
      """
      {
        "nome": "Usuario Uno",
        "email": "#(email2)",
        "password": "Test1234",
        "administrador": "false"
      }
      """

    Given path 'usuarios', id1
    And request usuarioDuplicado
    When method PUT
    Then status 400
    And match response.message == 'Este email já está sendo usado'

    Given path 'usuarios', id1
    When method DELETE
    Then status 200

    Given path 'usuarios', id2
    When method DELETE
    Then status 200
