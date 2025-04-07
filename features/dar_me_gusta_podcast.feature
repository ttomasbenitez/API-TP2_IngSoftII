#language: es

Característica: Dar "me gusta" a un episodio de podcast

  Escenario: HU18.1 Usuario registrado da "me gusta" a un episodio existente
    Dado que el usuario está registrado en el sistema
    Y el episodio con ID <id_episodio> existe en el sistema
    Cuando envía el comando me_gusta con <id_episodio>
    Entonces el episodio se marca como me_gusta correctamente

  Escenario: HU18.2 Usuario no registrado da "me gusta" a un episodio
    Dado que el usuario no está registrado en el sistema
    Cuando envía el comando me_gusta con <id_episodio>
    Entonces se envía un mensaje de error indicando que debe registrarse

  Escenario: HU18.3 Usuario registrado da "me gusta" a un episodio sin especificar ID
    Dado que el usuario está registrado en el sistema
    Cuando envía el comando me_gusta sin incluir <id_episodio>
    Entonces se envía un mensaje de error indicando que debe proporcionar el ID del episodio

  Escenario: HU18.4 Usuario registrado da "me gusta" a un episodio inexistente
    Dado que el usuario está registrado en el sistema
    Y el episodio con ID <id_episodio> no existe en el sistema
    Cuando envía el comando me_gusta con <id_episodio>
    Entonces se envía un mensaje de error indicando que el episodio no existe

  Escenario: HU18.5 Usuario registrado da "me gusta" a un episodio que ya le dio "me gusta"
    Dado que el usuario está registrado en el sistema
    Y el episodio con ID <id_episodio> existe en el sistema
    Y el episodio ya está marcado como me_gusta
    Cuando envía el comando me_gusta con <id_episodio>
    Entonces se envía un mensaje indicando que ya le ha dado me_gusta a este episodio
