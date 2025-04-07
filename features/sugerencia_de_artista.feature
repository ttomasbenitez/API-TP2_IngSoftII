#language: es
Característica: Obtener sugerencias de artistas

  Escenario: HU20.1 Usuario no registrado intenta obtener sugerencias
    Dado que el usuario no está registrado en el sistema
    Cuando consulta por una sugerencia
    Entonces se envía un mensaje indicando que debe registrarse

  Escenario: HU20.2 Usuario con canciones en playlist intenta obtener sugerencias
    Dado que el usuario está registrado en el sistema
    Y la última canción que agrego a su playlist es de "Lady Gaga"
    Cuando consulta por una sugerencia
    Entonces recibe una sugerencia de "Lady Gaga"

  Escenario: HU20.3 Usuario con canciones en playlist intenta obtener sugerencias
    Dado que el usuario está registrado en el sistema
    Y no registró canciones en su playlist
    Cuando consulta por una sugerencia
    Entonces no recibe ninguna sugerencia
