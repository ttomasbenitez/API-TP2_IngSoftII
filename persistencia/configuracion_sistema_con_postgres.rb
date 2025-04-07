class ConfiguracionSistemaConPostgres
  attr_accessor :repositorio_usuarios, :repositorio_contenido, :repositorio_reproducciones, :repositorio_coleccion_contenido, :repositorio_autores

  def initialize
    @repositorio_usuarios = RepositorioUsuarios.new
    @repositorio_autores = RepositorioAutores.new
    @repositorio_contenido = RepositorioContenido.new
    @repositorio_reproducciones = RepositorioReproducciones.new
    @repositorio_coleccion_contenido = RepositorioColeccionContenido.new
  end
end
