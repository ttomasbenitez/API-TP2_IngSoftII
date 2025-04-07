class Contenido
  attr_reader :tipo, :autor, :titulo, :duracion, :fecha_lanzamiento, :updated_on, :created_on
  attr_accessor :id

  def initialize(_autor, titulo, duracion, fecha_lanzamiento, id = nil)
    @id = id
    @titulo = titulo
    @duracion = duracion
    @fecha_lanzamiento = fecha_lanzamiento
  end

  def nombre_autor
    @autor.nombre
  end

  def registrar(repositorio)
    repositorio.save(self)
  end

  def reproducir(usuario, repositorio)
    repositorio.guardar_reproduccion(usuario, self)
    self
  end
end

class Cancion < Contenido
  def initialize(autor, titulo, duracion, fecha_lanzamiento, id = nil)
    super(autor, titulo, duracion, fecha_lanzamiento, id)
    @autor = Artista.new(autor)
    @tipo = 'cancion'.freeze
  end

  def puede_agregarse_a_playlist?
    true
  end
end

class Episodio < Contenido
  def initialize(autor, titulo, duracion, fecha_lanzamiento, id = nil)
    super(autor, titulo, duracion, fecha_lanzamiento, id)
    @autor = Podcast.new(autor)
    @tipo = 'episodio'.freeze
  end

  def puede_agregarse_a_playlist?
    false
  end
end

class TituloInvalido < StandardError
  def initialize(msg = 'El titulo debe ser un texto válido')
    super
  end
end

class AutorInvalido < StandardError
  def initialize(msg = 'El autor debe ser un texto válido')
    super
  end
end

class FechaLanzamientoInvalida < StandardError
  def initialize(msg = 'La fecha de lanzamiento no es valida')
    super
  end
end

class DuracionInvalida < StandardError
  def initialize(msg = 'La duración debe tener un formato de tiempo válido')
    super
  end
end

class TipoContenidoInvalido < StandardError
  def initialize(msg = 'El tipo de contenido solo puede ser cancion o episodio')
    super
  end
end

class ValidadorContenido
  CANTIDAD_UNIDADES_TIEMPO = 3
  TIPO_CANCION = 'cancion'.freeze
  TIPO_PODCAST = 'episodio'.freeze
  def self.valido(tipo, autor, titulo, fecha_lanzamiento, duracion)
    raise AutorInvalido unless autor_valido?(autor)
    raise TituloInvalido unless titulo.is_a?(String) && !titulo.empty?
    raise FechaLanzamientoInvalida unless fecha_valida?(fecha_lanzamiento)
    raise DuracionInvalida unless duracion_valida?(duracion)
    raise TipoContenidoInvalido unless tipo_valido?(tipo)
  end

  def self.autor_valido?(autor)
    autor.is_a?(String) && !autor.empty?
  end

  def self.fecha_valida?(fecha)
    return false if fecha.nil? || fecha.empty?

    return true if fecha.is_a?(Date)

    Date.parse(fecha)
    true
  rescue ArgumentError
    false
  end

  def self.duracion_valida?(una_duracion)
    return false if una_duracion.nil? || una_duracion.empty?
    return false if una_duracion.split(':').size > CANTIDAD_UNIDADES_TIEMPO

    Time.parse(una_duracion)
    true
  rescue ArgumentError
    false
  end

  def self.tipo_valido?(un_tipo)
    return false if un_tipo.nil? || un_tipo.empty?

    [TIPO_PODCAST, TIPO_CANCION].include?(un_tipo.downcase)
  end
end
