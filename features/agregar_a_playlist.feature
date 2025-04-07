# language: es

Característica: Agregar canción a playlist

  Escenario: HU09.1 Usuario registrado agrega canción a playlist
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_canción> existe en el sistema
    Cuando envía el comando guardar con <id_canción>
    Entonces la canción se guarda correctamente

  Escenario: HU09.2 Usuario no registrado agrega canción a playlist
    Dado que el usuario no está registrado en el sistema
    Cuando envía el comando guardar con <id_canción>
    Entonces recibe el mensaje de error el usuario no existe

  Escenario: HU09.3 Usuario registrado agrega canción a playlist sin id
    Dado que el usuario está registrado en el sistema
    Cuando envía el comando guardar sin incluir <id_cancion>
    Entonces se envía un error "Id de contenido no especificado"

  Escenario: HU09.4 Usuario registrado agrega canción inexistente a playlist
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_contenido> no existe en el sistema
    Cuando envía el comando guardar con id_contenido
    Entonces se envía un error "El contenido no existe"
  
  Escenario: HU09.5 Usuario registrado agrega canción a playlist por segunda vez
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_canción> existe en el sistema
    Y la canción ya está guardada
    Cuando envía el comando guardar
    Entonces se envía un error "El contenido ya se encuentra en la coleccion"

