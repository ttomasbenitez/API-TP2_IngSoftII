#language: es

Característica: Obtener información de un contenido

  Escenario: HU22.1 Usuario no registrado obtiene contenido popular
        Dado que el usuario no está registrado en el sistema
        Cuando intenta obtener el contenido más popular
        Entonces se envía un mensaje indicando que debe registrarse

  Escenario: HU22.2 Usuario registrado obtiene contenido popular sin reproducciones
        Dado que el usuario está registrado en el sistema
        Y no hay ninguna reproducción registrada en el sistema
        Cuando intenta obtener el contenido más popular
        Entonces se envía un mensaje indicando que no hay reproducciones

  Escenario: HU22.3 Usuario registrado obtiene contenido popular cuando hay un solo contenido con me gusta
        Dado que el usuario está registrado en el sistema
        Y sólo el contenido "Nos siguen pegando abajo" tiene reproducciones
        Cuando intenta obtener el contenido más popular
        Entonces se envía un mensaje con el contenido "Nos siguen pegando abajo"

  Escenario: HU22.4 Usuario registrado obtiene contenido popular
        Dado que el usuario está registrado en el sistema
        Y existen varios contenidos con reproducciones
        Cuando intenta obtener el contenido más popular
        Entonces se envía un mensaje con varios contenidos ordenados por cantidad de reproducciones
