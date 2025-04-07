#language: es

Característica: Consulta de playlist personal

  Escenario: HU19.1 Consulta con una cancion en la playlist
    Dado que el usuario está registrado en el sistema
    Y el usuario tiene exactamente una canción en la playlist personal
    Cuando el usuario consulta su playlist
    Entonces se muestra la canción

  Escenario: HU19.2 Consulta de playlist con varias canciones
    Dado que el usuario está registrado en el sistema
    Y el usuario tiene cinco canciones en la playlist
    Cuando el usuario consulta su playlist
    Entonces se muestran cinco canciones

  Escenario: HU19.3 Consulta de playlist vacia
    Dado que el usuario está registrado en el sistema
    Y el usuario no tiene canciones en la playlist personal
    Cuando el usuario consulta su playlist
    Entonces se muestra un mensaje de playlist vacía

  Escenario: HU19.4 Consulta de playlist sin usuario registrado
    Dado que el usuario no está registrado en el sistema
    Cuando el usuario consulta su playlist
    Entonces se muestra un mensaje de error
