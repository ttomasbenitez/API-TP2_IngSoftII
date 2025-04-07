# language: es
Característica: Alta de nuevas canciones en el catálogo

  Escenario: HU11.1.1 Alta exitosa de una única canción mediante el endpoint
    Dado que el miembro del equipo de contenido tiene acceso al endpoint de alta de canciones
    Cuando envía una solicitud de agregar un contenido que es una canción
    Entonces la canción es añadida al catálogo de la plataforma
    Y se recibe un mensaje de éxito
