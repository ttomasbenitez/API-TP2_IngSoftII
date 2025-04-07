require_relative 'coleccion_contenido'

CANTIDAD_PARTES_EMAIL = 2
class EmailInvalido < StandardError
  def initialize(msg = 'El email no es valido')
    super
  end
end

class ContenidoSinReproducir < StandardError
  def initialize(msg = 'El contenido no fue reproducido por este usuario')
    super
  end
end

class Usuario
  attr_reader :email, :updated_on, :created_on, :username
  attr_accessor :id

  def initialize(email, username, repositorio_contenido, repositorio_coleccion, id = nil)
    ValidadorEmail.validar(email)
    @email = email
    @id = id
    @username = username
    @repositorio_contenido = repositorio_contenido
    @playlist = Playlist.new('playlist', self, repositorio_coleccion)
    @favoritos = ColeccionContenido.new('favoritos', self, repositorio_coleccion)
  end

  def agregar_contenido_a_playlist(contenido)
    @playlist.agregar_contenido(contenido)
    contenido
  end

  def obtener_canciones_en_playlist
    @playlist.obtener_contenidos
  end

  def dar_me_gusta(contenido, repositorio_reproducciones)
    raise ContenidoSinReproducir unless reprodujo?(contenido, repositorio_reproducciones)

    @favoritos.agregar_contenido(contenido)
    contenido
  end

  def obtener_novedades(boletin)
    boletin.obtener_novedades
  end

  def obtener_populares(boletin)
    boletin.obtener_populares
  end

  def obtener_sugerencia
    @playlist.obtener_ultimo_contenido_aniadido(self)
  end

  def obtener_artista_favorito
    @favoritos.obtener_artista_favorito
  end

  def reprodujo?(contenido, repositorio_reproducciones)
    !repositorio_reproducciones.buscar_por_usuario_y_contenido(self, contenido).nil?
  end
end

class ValidadorEmail
  POSICION_NOMBRE_USUARIO = 0
  POSICION_NOMBRE_DOMINIO = 1
  PARTES_MINIMAS_DOMINIO = 1
  TAMANIO_MINIMO_ULTIMO_DOMINIO = 2
  SEPARADOR_EMAIL = '@'.freeze
  REGEX_NOMBRE_USUARIO_VALIDO = /^[a-zA-Z0-9_.-]+$/
  REGEX_DOMINIO_VALIDO = /^[a-zA-Z0-9.-]+$/
  REGEX_CARACTERES_ESPECIALES = /[._-]{2,}/
  REGEX_DOMINIO_PUNTOS = /[.]{2,}/
  def self.validar(un_email)
    validar_email_no_vacio(un_email)
    partes_email = un_email.split(SEPARADOR_EMAIL)
    validar_estructura(partes_email)
    validar_usuario(partes_email[POSICION_NOMBRE_USUARIO])
    validar_dominio(partes_email[POSICION_NOMBRE_DOMINIO])
  end

  def self.validar_email_no_vacio(un_email)
    raise EmailInvalido if un_email.nil? || un_email.empty?
  end

  def self.validar_estructura(partes_email)
    raise EmailInvalido if partes_email.size != CANTIDAD_PARTES_EMAIL
    raise EmailInvalido if partes_email[POSICION_NOMBRE_USUARIO].empty? || partes_email[POSICION_NOMBRE_DOMINIO].empty?
  end

  def self.validar_usuario(un_nombre_de_usuario)
    raise EmailInvalido if un_nombre_de_usuario.start_with?('.') || un_nombre_de_usuario.end_with?('.', '-', '_')
    raise EmailInvalido unless un_nombre_de_usuario =~ REGEX_NOMBRE_USUARIO_VALIDO && un_nombre_de_usuario !~ REGEX_CARACTERES_ESPECIALES
  end

  def self.validar_dominio(un_dominio)
    raise EmailInvalido unless un_dominio =~ REGEX_DOMINIO_VALIDO && un_dominio !~ REGEX_DOMINIO_PUNTOS

    partes_dominio = un_dominio.split('.')

    partes_dominio.each do |parte_dominio|
      raise EmailInvalido unless parte_dominio_valida?(parte_dominio)
    end

    raise EmailInvalido if partes_dominio.size <= PARTES_MINIMAS_DOMINIO || partes_dominio.last.size < TAMANIO_MINIMO_ULTIMO_DOMINIO
  end

  def self.parte_dominio_valida?(una_parte_de_dominio)
    !una_parte_de_dominio.start_with?('-') && !una_parte_de_dominio.end_with?('-')
  end
end
