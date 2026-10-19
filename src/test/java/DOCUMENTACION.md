DOCUMENTACION.md

<h2>
<strong>Informe de Estrategia de Automatización de Pruebas</strong>
</h2>

<p>
<b>Proyecto:</b> ServeRest - Automatización de pruebas Backend<br>
<b>Stack Tecnológico:</b> Java 17, Maven, Karate DSL 1.5.1, JUnit 5, Maven Compiler Plugin 3.13.0, Maven Surefire Plugin 3.2.5 y ServeRest.
</p>

<hr>

<h3>1. Alcance de las pruebas</h3>

<p>
La suite cubre las siguientes operaciones de la API:
</p>

<ul>
<li><b>GET /usuarios:</b> listar usuarios y filtrar los registros por el campo <code>administrador</code>.</li>
<li><b>POST /usuarios:</b> registrar usuarios con datos válidos y comprobar el rechazo de correos electrónicos duplicados.</li>
<li><b>GET /usuarios/{_id}:</b> consultar un usuario existente y verificar la respuesta ante un identificador inexistente.</li>
<li><b>PUT /usuarios/{_id}:</b> actualizar los datos de un usuario y validar el rechazo de una actualización con un correo electrónico duplicado.</li>
<li><b>DELETE /usuarios/{_id}:</b> eliminar un usuario existente y comprobar el comportamiento ante identificadores inexistentes.</li>
</ul>

<p>
La suite combina escenarios positivos y negativos para verificar tanto las operaciones exitosas como el manejo de errores de la API.
</p>
<ul>
<li><b>Escenarios positivos:</b> validan el listado, el registro, la consulta, la actualización y la eliminación de usuarios con datos válidos.</li>
<li><b>Escenarios negativos:</b> validan el rechazo de correos duplicados, la consulta de identificadores inexistentes y el intento de eliminar usuarios que no existen.</li>
</ul>


<hr>

<h3>2. Estrategia de automatización</h3>

<p>
Se aplica una estrategia de pruebas funcionales de API basada en caja negra. Karate DSL permite ejecutar solicitudes HTTP y validar las respuestas del servicio sin depender de su implementación interna.
</p>

<p>Las principales validaciones implementadas son:</p>

<ul>
<li><b>Códigos de estado HTTP:</b> se comprueban respuestas como HTTP 200, HTTP 201 y HTTP 400, según el escenario.</li>
<li><b>Mensajes de respuesta:</b> se validan los mensajes asociados al registro, actualización y eliminación de usuarios, así como los errores por duplicidad.</li>
<li><b>Estructura JSON:</b> se comprueba la presencia de campos y sus tipos de datos mediante las expresiones de validación de Karate.</li>
<li><b>Integridad funcional:</b> después de registrar o actualizar un usuario, se realizan consultas para verificar que los datos sean correctos.</li>
<li><b>Validación de eliminación:</b> después de eliminar un usuario, se consulta nuevamente el recurso para comprobar que ya no se encuentre disponible.</li>
</ul>

<hr>

<h3>3. Patrones y buenas prácticas utilizados</h3>

<ul>
  <li><strong>Organización por funcionalidad:</strong> los escenarios se distribuyen en archivos .feature para facilitar su lectura y mantenimiento.</li>
  <li><strong>Configuración reutilizable:</strong> karate-config.js centraliza la URL base de la API, mientras que Background permite establecer configuraciones comunes a los escenarios.</li>
  <li><strong>Datos dinámicos:</strong> se utiliza java.util.UUID para generar correos electrónicos únicos y reducir conflictos entre ejecuciones.</li>
  <li><strong>Validaciones declarativas:</strong> Karate permite comprobar los códigos HTTP, los mensajes, la estructura JSON y los valores esperados mediante expresiones match.</li>
</ul>


<h3>5. Cobertura de pruebas</h3>
<ul>
<li><b>USU-001:</b> Listar usuarios correctamente (<code>GET /usuarios</code>). Validación principal: HTTP 200 y estructura de la respuesta.</li>
<li><b>USU-002:</b> Filtrar usuarios por administrador (<code>GET /usuarios</code>). Validación principal: HTTP 200 y valor del campo <code>administrador</code>.</li>
<li><b>USU-003:</b> Registrar usuario válido (<code>POST /usuarios</code>). Validación principal: HTTP 201, mensaje de confirmación e identificador.</li>
<li><b>USU-004:</b> Rechazar correo duplicado (<code>POST /usuarios</code>). Validación principal: HTTP 400 y mensaje de duplicidad.</li>
<li><b>USU-005:</b> Consultar usuario existente (<code>GET /usuarios/{_id}</code>). Validación principal: HTTP 200, esquema JSON y coincidencia de datos.</li>
<li><b>USU-006:</b> Consultar ID inexistente (<code>GET /usuarios/{_id}</code>). Validación principal: HTTP 400 y respuesta de usuario no encontrado.</li>
<li><b>USU-007:</b> Actualizar usuario existente (<code>PUT /usuarios/{_id}</code>). Validación principal: HTTP 200 y persistencia de los cambios.</li>
<li><b>USU-008:</b> Rechazar actualización con correo duplicado (<code>PUT /usuarios/{_id}</code>). Validación principal: HTTP 400 y mensaje de duplicidad.</li>
<li><b>USU-009:</b> Eliminar usuario existente (<code>DELETE /usuarios/{_id}</code>). Validación principal: HTTP 200 y verificación posterior de eliminación.</li>
<li><b>USU-010:</b> Intentar eliminar un ID inexistente (<code>DELETE /usuarios/{_id}</code>). Validación principal: HTTP 200 y mensaje de que no se eliminó ningún registro.</li>
</ul>
<hr>
<h3>6. Ejecución y generación de reportes</h3>

<p>
La clase <code>TestUsuarios.java</code> integra Karate DSL con JUnit 5 y permite seleccionar el archivo <code>.feature</code> que se desea ejecutar.
</p>

<pre><code>@Karate.Test
Karate testUsuarios() {
return Karate.run("usuarios/usuarios-crud")
.relativeTo(getClass());
}</code></pre>

<p>
La ruta de <code>Karate.run()</code> debe coincidir con el archivo que se desea ejecutar, sin incluir la extensión <code>.feature</code>.
</p>

<p>
La ejecución mediante Maven se realiza con el siguiente comando:
</p>

<pre><code>mvn test</code></pre>

<p>
Karate genera reportes HTML con información de los escenarios y sus validaciones. Maven Surefire también genera reportes de ejecución.
</p>

<pre><code>target/karate-reports/
target/surefire-reports/</code></pre>