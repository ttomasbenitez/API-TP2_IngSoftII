#language: es
Característica: Evitar agregar episodios de podcasts en playlist

  Escenario: HU21.1 Carga de podcast en una playlist
    Dado que el usuario está registrado en el sistema
    Y existe un episodio de podcast con id de contenido 1
    Cuando intenta agregar un episodio de podcast a su playlist
    Entonces se envía un mensaje indicando que no puede cargar un podcast a su playlist
