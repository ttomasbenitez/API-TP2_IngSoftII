# language: es
Característica: : Registro de usuarios en el bot

  Escenario: HU01.1.1 Registro exitoso de un nuevo usuario
    Dado que el usuario no está registrado en el sistema
    Cuando el usuario se registra con un correo electrónico
    Entonces el usuario queda registrado en el sistema
