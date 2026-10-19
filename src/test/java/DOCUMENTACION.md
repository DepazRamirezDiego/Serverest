DOCUMENTACION.md

<h2>
<strong>Informe de Estrategia de Automatización de Pruebas</strong>
</h2>

<p>
<b>Proyecto:</b> ServeRest - Automatización de pruebas Backend<br>
<b>Stack Tecnológico:</b> Java 17, Maven, Karate DSL 1.5.1, JUnit 5, Maven Compiler Plugin 3.13.0, Maven Surefire Plugin 3.2.5 y ServeRest.
</p>

<hr>

<h3>1. Objetivo de la automatización</h3>

<p>
Desarrollar una suite de pruebas automatizadas para validar las operaciones CRUD (Create, Read, Update, Delete) del endpoint de usuarios de la API ServeRest, verificando el comportamiento funcional de los servicios, los códigos de estado HTTP, los mensajes de respuesta y la estructura de los objetos JSON.
</p>

<p>
La estrategia busca identificar errores funcionales, validar los criterios de aceptación del reto y facilitar la ejecución repetible de pruebas de regresión.
</p>

<hr>

<h3>2. Alcance de las pruebas</h3>

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

<h3>3. Estrategia de automatización</h3>

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

<h3>4. Patrones y buenas prácticas utilizados</h3>

<h4>4.1. Organización de pruebas por funcionalidad</h4>

<p>
Los escenarios se organizan en archivos <code>.feature</code> correspondientes a las operaciones de listado, registro, consulta, actualización y eliminación. Esta separación facilita la lectura, el mantenimiento y la identificación de los casos de prueba.
</p>

<h4>4.2. Reutilización de configuración con Background</h4>

<p>
El bloque <code>Background</code> se utiliza en los archivos de pruebas para establecer la URL base de la API mediante la variable <code>baseUrl</code>.
</p>

<pre><code>Background:
* url baseUrl</code></pre>

<p>
En el archivo de listado general también se define la ruta <code>usuarios</code> dentro del bloque <code>Background</code>. En los demás archivos, las rutas se especifican en cada escenario mediante <code>Given path</code>, según la operación que se desea ejecutar.
</p>

<h4>4.3. Configuración centralizada</h4>

<p>
El archivo <code>karate-config.js</code> define la URL base de ServeRest y permite reutilizarla en los diferentes escenarios.
</p>

<pre><code>function fn() {
var config = {
baseUrl: 'https://serverest.dev'
};

return config;
}</code></pre>

<p>
Esta práctica evita repetir la dirección del servicio en cada archivo y facilita su modificación cuando se requiera utilizar otro entorno.
</p>

<h4>4.4. Generación dinámica de datos de prueba</h4>

<p>
Se utiliza <code>java.util.UUID</code> para generar correos electrónicos únicos durante la ejecución de los escenarios que registran usuarios.
</p>

<pre><code>* def email = 'qa-' + java.util.UUID.randomUUID() + '@example.com'</code></pre>

<p>
Esta técnica reduce los conflictos con registros existentes y permite ejecutar repetidamente los escenarios sin depender de correos electrónicos fijos.
</p>

<h4>4.5. Validación declarativa de respuestas JSON</h4>

<p>
Karate DSL permite comprobar la estructura y los tipos de datos mediante expresiones como <code>#string</code>, <code>#number</code> y <code>#array</code>.
</p>

<pre><code>And match response ==
"""
{
quantidade: '#number',
usuarios: '#array'
}
"""</code></pre>

<p>
También se validan los campos de los usuarios individuales, como <code>nome</code>, <code>email</code>, <code>password</code>, <code>administrador</code> y <code>_id</code>.
</p>

<p>
Estas comprobaciones permiten detectar respuestas que no cumplen la estructura esperada por los escenarios.
</p>


<h3>5. Matriz de cobertura de pruebas</h3>

<table>
<thead>
<tr>
<th>ID</th>
<th>Endpoint</th>
<th>Escenario</th>
<th>Validación principal</th>
</tr>
</thead>
<tbody>
<tr>
<td>USU-001</td>
<td>GET /usuarios</td>
<td>Listar usuarios correctamente</td>
<td>HTTP 200 y estructura de la respuesta.</td>
</tr>
<tr>
<td>USU-002</td>
<td>GET /usuarios</td>
<td>Filtrar usuarios por administrador</td>
<td>HTTP 200 y valor del campo <code>administrador</code>.</td>
</tr>
<tr>
<td>USU-003</td>
<td>POST /usuarios</td>
<td>Registrar usuario válido</td>
<td>HTTP 201, mensaje de confirmación e identificador.</td>
</tr>
<tr>
<td>USU-004</td>
<td>POST /usuarios</td>
<td>Rechazar correo duplicado</td>
<td>HTTP 400 y mensaje de duplicidad.</td>
</tr>
<tr>
<td>USU-005</td>
<td>GET /usuarios/{_id}</td>
<td>Consultar usuario existente</td>
<td>HTTP 200, esquema JSON y coincidencia de datos.</td>
</tr>
<tr>
<td>USU-006</td>
<td>GET /usuarios/{_id}</td>
<td>Consultar ID inexistente</td>
<td>HTTP 400 y respuesta de usuario no encontrado.</td>
</tr>
<tr>
<td>USU-007</td>
<td>PUT /usuarios/{_id}</td>
<td>Actualizar usuario existente</td>
<td>HTTP 200 y persistencia de los cambios.</td>
</tr>
<tr>
<td>USU-008</td>
<td>PUT /usuarios/{_id}</td>
<td>Rechazar actualización con correo duplicado</td>
<td>HTTP 400 y mensaje de duplicidad.</td>
</tr>
<tr>
<td>USU-009</td>
<td>DELETE /usuarios/{_id}</td>
<td>Eliminar usuario existente</td>
<td>HTTP 200 y verificación posterior de eliminación.</td>
</tr>
<tr>
<td>USU-010</td>
<td>DELETE /usuarios/{_id}</td>
<td>Eliminar ID inexistente</td>
<td>HTTP 200 y mensaje de que no se eliminó ningún registro.</td>
</tr>
</tbody>
</table>

<p>
La matriz representa la cobertura definida en el código compartido. No implica que todos los escenarios hayan sido ejecutados satisfactoriamente.
</p>

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

<hr>

<h3>7. Conclusión</h3>

<p>
La suite implementada proporciona una base de automatización funcional para las operaciones CRUD de la API de usuarios de ServeRest. Karate DSL permite expresar los escenarios de manera declarativa y validar las respuestas HTTP y JSON, mientras que Java, JUnit 5 y Maven facilitan la integración y ejecución de las pruebas.
</p>

<p>
El uso de configuración centralizada, datos dinámicos, validaciones de esquema y comprobaciones posteriores a las operaciones contribuye a la legibilidad y mantenibilidad de la solución.
</p>

<p>
La cobertura de escenarios positivos y negativos responde a los principales criterios de aceptación del reto y permite ampliar la suite en futuras iteraciones con validaciones adicionales, una gestión de datos más robusta e integración continua.
</p>