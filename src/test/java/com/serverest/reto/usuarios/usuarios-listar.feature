Feature: Listar usuarios de ServeRest

  Background:
    * url baseUrl
    * path 'usuarios'

  Scenario: Listar usuarios correctamente
    When method GET
    Then status 200
    And match response ==
      """
      {
        quantidade: '#number',
        usuarios: '#array'
      }
      """
    And match each response.usuarios ==
      """
      {
        nome: '#string',
        email: '#string',
        password: '#string',
        administrador: '#string',
        _id: '#string'
      }
      """

  Scenario: Filtrar usuarios por administrador
    Given param administrador = 'true'
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'
    And match each response.usuarios[*].administrador == 'true'
