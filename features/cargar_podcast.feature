# language: es
Característica: Alta de nuevos podcasts en el catálogo

  Escenario: HU12.1.1 Alta exitosa de un único episodio de podcast mediante el endpoint
    Dado que el miembro del equipo de contenido tiene acceso al endpoint de alta de contenido
    Cuando envía una solicitud de agregar un contenido que es un episodio de podcast
    Entonces el episodio es añadido al catálogo de la plataforma
    Y se recibe un mensaje de éxito
