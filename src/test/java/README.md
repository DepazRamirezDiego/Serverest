<h2>
<strong>Guía de configuración y ejecución de pruebas</strong>
</h2>

<hr>

<h3>2. Configuración de IntelliJ IDEA</h3>

<h4>2.1. Configurar el JDK</h4>

<ol>
<li>Accede a <b>File → Project Structure</b>.</li>
<li>En la sección <b>Project</b>, selecciona el JDK 17 o superior.</li>
<li>Verifica que el nivel de lenguaje de Java coincida con la configuración del proyecto.</li>
<li>En <b>File → Settings → Build, Execution, Deployment → Build Tools → Maven</b>, comprueba que Maven utilice el JDK correcto.</li>
</ol>

<p>Los nombres de algunas opciones pueden variar según la versión de IntelliJ IDEA.</p>

<h4>2.2. Instalación de dependencias</h4>

<p>En <b>File → Settings → Plugins → Marketplace</b>, busca los siguientes plugins:</p>

<ul>
<li>Karate</li>
<li>Karate Chop Debugger</li>
</ul>

<p>Si modificas el archivo <code>pom.xml</code>, vuelve a cargar los cambios del proyecto Maven desde IntelliJ IDEA.</p>

<h4>2.3. Dependencias en el archivo <code>pom.xml</code></h4>

<pre style="width: 100%; box-sizing: border-box; overflow-x: auto;"><code>&lt;dependency&gt;
&lt;groupId&gt;io.karatelabs&lt;/groupId&gt;
&lt;artifactId&gt;karate-junit5&lt;/artifactId&gt;
&lt;version&gt;${karate.version}&lt;/version&gt;
&lt;scope&gt;test&lt;/scope&gt;
&lt;/dependency&gt;</code></pre>

<h4>2.5. Plugins en el archivo <code>pom.xml</code></h4>

<pre style="width: 100%; box-sizing: border-box; overflow-x: auto;"><code>&lt;plugins&gt;
&lt;plugin&gt;
&lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
&lt;artifactId&gt;maven-compiler-plugin&lt;/artifactId&gt;
&lt;version&gt;3.13.0&lt;/version&gt;
&lt;configuration&gt;
&lt;release&gt;17&lt;/release&gt;
&lt;/configuration&gt;
&lt;/plugin&gt;

&lt;plugin&gt;
&lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
&lt;artifactId&gt;maven-surefire-plugin&lt;/artifactId&gt;
&lt;version&gt;3.2.5&lt;/version&gt;
&lt;/plugin&gt;
&lt;/plugins&gt;</code></pre>

<hr>

<h3>3. Configuración del proyecto: URL base de la API</h3>

<p>Verificar que exista el archivo <code>karate-config.js</code> en la ubicación correspondiente a la estructura del proyecto. Este archivo centraliza la configuración utilizada por los escenarios de prueba.</p>

<p>Ejemplo de configuración:</p>

<pre><code>function fn() {
var config = {
baseUrl: 'https://serverest.dev'
};

return config;
}</code></pre>

<p>En los archivos <code>.feature</code>, puedes utilizar la variable <code>baseUrl</code> para configurar la dirección de las peticiones HTTP.</p>

<p>Ejemplo de un escenario de consulta de usuarios:</p>

<pre><code>Feature: Gestión de usuarios

Background:
* url baseUrl

Scenario: Consultar usuarios
Given path 'usuarios'
When method GET
Then status 200</code></pre>

<hr>

<h3>5. Ejecución de las pruebas</h3>

<h4>Opción 1. Ejecutar desde IntelliJ IDEA</h4>

<ol>
<li>Abre el proyecto en IntelliJ IDEA.</li>
<li>Localiza la clase <code>TestUsuarios.java</code>.</li>
<li>En el archivo <code>TestUsuarios.java</code>, define el archivo <code>.feature</code> que deseas ejecutar.</li>
</ol>

<p>Ejemplo:</p>

<pre><code>package com.serverest.reto;

import com.intuit.karate.junit5.Karate;

class TestUsuarios {

@Karate.Test
Karate testUsuarios() {
return Karate.run("usuarios/usuarios-crud")
.relativeTo(getClass());
}
}</code></pre>

<ol start="4">
<li>Abre la terminal de IntelliJ IDEA.</li>
</ol>

<pre><code>View → Tool Windows → Terminal</code></pre>

<ol start="5">
<li>Ejecuta el comando <code>mvn test</code> en la consola.</li>
</ol>

<p>Este comando compila el código y ejecuta las pruebas que Maven Surefire detecte de acuerdo con su configuración.</p>

<p><strong>Nota:</strong> El archivo <code>TestUsuarios.java</code> define el archivo <code>.feature</code> que deseas ejecutar.</p>

<p>Ejemplo para ejecutar la consulta de usuarios:</p>

<pre><code>package com.serverest.reto;

import com.intuit.karate.junit5.Karate;

class TestUsuarios {

@Karate.Test
Karate testUsuarios() {
return Karate.run("usuarios/usuarios-listar")
.relativeTo(getClass());
}
}</code></pre>

<p>Para ejecutar otra operación, cambia la ruta del archivo:</p>

<pre><code>return Karate.run("usuarios/usuarios-actualizar")
.relativeTo(getClass());</code></pre>

<hr>

<p>
<strong>Nota: Se debe tener instalado <code>Maven 3.10.0</code> y configurado en la variable de entorno <code>Path</code>. Asimismo,
se debe tener instalado el <code>JDK 17</code> con su respectiva configuración.</strong>
</p>