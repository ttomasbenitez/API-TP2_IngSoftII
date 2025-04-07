# language: es

Característica: Dar me_gusta a una canción

  Escenario: HU07.1 Usuario registrado da me_gusta a una canción existente
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_cancion> existe en el sistema
    Cuando envía el comando me_gusta con <id_cancion>
    Entonces la canción se marca como me_gusta correctamente

  Escenario: HU07.2 Usuario no registrado da me_gusta a una canción
    Dado que el usuario no está registrado en el sistema
    Cuando envía el comando me_gusta con <id_cancion>
    Entonces se envía un mensaje de error indicando que debe registrarse
    
  Escenario: HU07.3 Usuario registrado da me_gusta a una canción sin especificar ID
    Dado que el usuario está registrado en el sistema
    Cuando envía el comando me_gusta sin incluir <id_cancion>
    Entonces se envía un mensaje de error indicando que debe proporcionar el ID de la canción

  Escenario: HU07.4 Usuario registrado da me_gusta a una canción inexistente
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_cancion> no existe en el sistema
    Cuando envía el comando me_gusta con <id_cancion>
    Entonces se envía un mensaje de error indicando que la canción no existe
  
  Escenario: HU07.5 Usuario registrado da me_gusta a una canción que ya le dio me_gusta
    Dado que el usuario está registrado en el sistema
    Y la canción con ID <id_cancion> existe en el sistema
    Y la canción ya está marcada como me_gusta
    Cuando envía el comando me_gusta con <id_cancion>
    Entonces se envía un mensaje indicando que ya le ha dado me_gusta a esta canción

