class Autor
  attr_reader :tipo, :nombre, :created_on, :updated_on
  attr_accessor :id

  def initialize(nombre)
    @nombre = nombre
  end

  def registrar(repositorio)
    repositorio.save(self)
  end
end

class Artista < Autor
  def initialize(nombre, id = nil)
    super(nombre)
    @id = id
    @tipo = 'artista'.freeze
  end
end

class Podcast < Autor
  def initialize(nombre, id = nil)
    super(nombre)
    @id = id
    @tipo = 'podcast'.freeze
  end
end
