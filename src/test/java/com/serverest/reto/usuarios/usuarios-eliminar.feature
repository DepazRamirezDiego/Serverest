Feature: Eliminar usuarios en ServeRest

  Background:
    * url baseUrl

  Scenario: Eliminar un usuario existente
    * def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'
    * def usuario =
      """
      {
        "nome": "Usuario Para Eliminar",
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
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    Given path 'usuarios', idCreado
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  Scenario: Intentar eliminar un usuario inexistente
    Given path 'usuarios', 'id-inexistente-qa'
    When method DELETE
    Then status 200
    And match response.message == 'Nenhum registro excluído'
