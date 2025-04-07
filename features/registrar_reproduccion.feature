# language: es
Característica: Registrar reproducción

  Escenario: HU10.1 Se registra una reproducción de contenido
    Dado que el contenido con ID 1 existe en el sistema
    Y el usuario con ID 1 existe en el sistema
    Cuando llega un pedido a reproducciones con 1 y 1234
    Entonces se registra una reproducción del usuario con 1234 de contenido con 1
    Y recibe un mensaje de exito

  Escenario: HU10.2 Se registra una reproducción con usuario inexistente
    Dado que el contenido con ID 1 existe en el sistema
    Y el usuario con ID 10 no existe en el sistema
    Cuando llega un pedido a reproducciones con 1 y 10
    Entonces recibe el mensaje de error el usuario no existe

  Escenario: HU10.3 Se registra una reproducción de contenido inexistente
    Dado que el contenido con ID 15 no existe en el sistema
    Y el usuario con ID 10 existe en el sistema
    Cuando llega un pedido a reproducciones con 15 y 10
    Entonces recibe el mensaje de error "El contenido no existe"
