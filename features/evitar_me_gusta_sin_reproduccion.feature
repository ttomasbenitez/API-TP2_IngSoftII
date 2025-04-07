#language: es

Característica: Evitar me gusta sin reproducción

  Escenario: HU23.1 Usuario da me gusta a un contenido no reproducido
        Dado que el usuario está registrado en el sistema
        Y no reprodujo la canción "Cerca de la revolución"
        Cuando da me gusta a la canción "Cerca de la revolución"
        Entonces se envía un mensaje indicando que para dar me gusta a un contenido debe reproducirlo
