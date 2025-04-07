#language: es
Característica: Consulta de novedades de podcasts

  Escenario: HU16.1 Usuario consulta novedades y hay episodios de podcasts nuevos
    Dado que el usuario está registrado en el sistema
    Y un episodio de podcast se acaba de publicar
    Cuando envía el comando novedades
    Entonces el episodio de podcast está incluido en las novedades

  Escenario: HU16.2 Usuario consulta novedades y hay episodios de podcasts y canciones nuevas
    Dado que el usuario está registrado en el sistema
    Y un episodio de podcast se acaba de publicar
    Y una canción se acaba de publicar
    Cuando envía el comando novedades
    Entonces el episodio de podcast está incluido en las novedades
    Y la canción está incluida en las novedades
