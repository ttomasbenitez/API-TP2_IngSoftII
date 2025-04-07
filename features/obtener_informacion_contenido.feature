#language: es

Característica: Obtener información de un contenido

  Escenario: HU06.1 Usuario no registrado intenta obtener información
    Dado que el usuario no está registrado en el sistema
    Y existe una canción con id 15
    Cuando intenta obtener información
    Entonces se envía un mensaje indicando que debe registrarse

  Escenario: HU06.2 Usuario registrado intenta obtener información de contenido no existente
    Dado que el usuario está registrado en el sistema
    Y el contenido con id 15 no existe
    Cuando intenta obtener información
    Entonces se envía un mensaje indicando que el contenido no existe

  Escenario: HU06.3 Usuario registrado intenta obtener información de una canción existente
    Dado que el usuario está registrado en el sistema
    Y existe una canción con id 15
    Cuando intenta obtener información
    Entonces se envía un mensaje con información de la canción 15

  Escenario: HU06.4 Usuario registrado intenta obtener información de un podcast existente
    Dado que el usuario está registrado en el sistema
    Y existe un episodio de podcast con id 15
    Cuando intenta obtener información
    Entonces se envía un mensaje con información del episodio de podcast 15

