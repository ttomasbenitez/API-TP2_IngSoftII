#language: es
Característica: Obtener recomendaciones basadas en mis me gusta

  Escenario: HU04.1 Usuario con varios me gusta intenta obtener recomendaciones
    Dado que el usuario está registrado en el sistema
    Y su artista con más me gusta es "Charly Garcia"
    Cuando obtiene una recomendación
    Entonces recibe una recomendación de un artista similar a "Charly Garcia"

  Escenario: HU04.2 Usuario no registrado intenta obtener recomendaciones
    Dado que el usuario no está registrado en el sistema
    Cuando obtiene una recomendación
    Entonces se envía un mensaje indicando que debe registrarse

  Escenario: HU04.3 Usuario sin me gusta intenta obtener recomendaciones
    Dado que el usuario está registrado en el sistema
    Y no le dio me gusta a ninguna canción
    Cuando obtiene una recomendación
    Entonces recibe un mensaje indicando que no hay recomendaciones disponibles
