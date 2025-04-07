# language: es
Característica: Consultar novedades de contenido

  Escenario: HU03.1 Usuario consulta las novedades disponibles
    Dado que el usuario está registrado en el sistema
    Y existe contenido
    Cuando envía el comando novedades
    Entonces se muestra una lista los últimos 3 contenidos

  Escenario: HU03.2 Usuario no registrado consulta novedades disponibles
    Dado que el usuario no se encuentra registrado en el sistema
    Cuando envía el comando novedades
    Entonces recibe el mensaje de error el usuario no existe

  Escenario: HU03.3 Usuario consulta novedades disponibles pero no hay novedades
    Dado que el usuario está registrado en el sistema
    Cuando envía el comando novedades
    Entonces se envía un mensaje informativo
