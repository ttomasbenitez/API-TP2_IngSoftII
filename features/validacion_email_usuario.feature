#language: es
Característica: Registro de usuarios en el bot

  Escenario: HU01.2.1 Registro fallido debido a un email inválido
    Dado que el usuario no está registrado en el sistema
    Cuando el usuario intenta registrarse con un correo electrónico no válido
    Entonces se muestra un mensaje de error indicando que debe ingresar un email válido
    Y el usuario no queda registrado en el sistema

  Escenario: HU01.2.2 Registro fallido debido a un usuario ya registrado
    Dado que el usuario "pepe" ya está registrado en el sistema
    Cuando el usuario "pepe" intenta registrarse nuevamente
    Entonces se muestra un mensaje de error indicando que el usuario ya está registrado
