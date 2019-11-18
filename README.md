# proyectoRuby

# Funcionamiento:

Ejecutar primero executeServer.rb. Luego executeClient.rb (Se pueden ejecutar varios clientes)

Desde el cliente se especifica el comando primero y luego el trabajo, separado por espacio en blanco.(perform_now nombreTrabajo)

Uno de los trabajos tiene parametros, tambien se separan por espacios (perform_now nombreTrabajo param1 param2)

En el caso de perform_in, se especifica el tiempo de la misma manera que los parametros (perform_in tiempo nombreTrabajo)

### Trabajos:
HelloWorld: No lleva parametros. Retorna Hello World!

HelloMeJob: Tiene dos parametros. Retorna un String personalizado con dichos parametros.

### Comandos:
perform_now: Se salta la Queue y ejecuta directamente, retorna el resultado del trabajo.

perform_later: Se agrega a la Queue del servidor, retorna al cliente un identificador de objeto.

perform_in: Se agrega a la Queue despues del tiempo especificado, retorna al cliente un identificador de objeto.

# Archivos:
### server.rb
Es el servidor y clases relacionadas, al ejecutar por consola se inicia en 'localhost 2345'

### server_spec.rb
Es el test para todas las clases en server.rb con RSpec

### client.rb
Simula un cliente. Ejecutar luego del servidor.

### jobs.rb
Contiene todos los trabajos que maneja el servidor (2 en este caso).

### jobs_spec.rb
Es el test para jobs.rb con RSpec.
