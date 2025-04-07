# language: es

Característica: Validación de campos en carga de contenido

  Escenario: HU11.2.1 Autor debe ser string  
    Dado que el autor es un numero
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el autor debe ser un texto válido.

  Escenario: HU11.2.2 Titulo debe ser string  
    Dado que el titulo es un numero
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el título debe ser un texto válido.

  Escenario: HU11.2.3 Fecha de lanzamiento debe ser una fecha  
    Dado que la fecha de lanzamiento no tiene formato de fecha 
    Cuando envío una carga de contenido  
    Entonces responde con un mensaje de error indicando que la fecha de lanzamiento debe ser una fecha válida.

  Escenario: HU11.2.4 Duración debe tener formato de tiempo  
    Dado que la duración no sigue el formato de tiempo
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que la duración debe tener un formato de tiempo válido.

  Escenario: HU11.2.5 Tipo sólo puede ser "cancion" o "episodio"
    Dado que el tipo no es un tipo de contenido valido
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el tipo de contenido solo puede ser cancion o episodio.

  Escenario: HU11.3.2 Titulo no debe estar vacío  
    Dado que el titulo esta vacio
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el título debe ser un texto válido.

  Escenario: HU11.3.3 Fecha de lanzamiento no debe estar vacía  
    Dado que la fecha de lanzamiento esta vacia
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que la fecha de lanzamiento debe ser una fecha válida.

  Escenario: HU11.3.4 Duración no debe estar vacía  
    Dado que la duracion esta vacia
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que la duración debe tener un formato de tiempo válido.

  Escenario: HU11.3.5 Tipo no debe estar vacío
    Dado que el tipo esta vacio
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el tipo de contenido solo puede ser cancion o episodio.

  Escenario: HU11.3.6 Autor no debe estar vacío
    Dado que el autor esta vacio
    Cuando envío una carga de contenido
    Entonces responde con un mensaje de error indicando que el autor debe ser un texto válido.
