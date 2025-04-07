class UsuarioInexistente < StandardError
  def initialize(msg = 'El usuario no existe')
    super
  end
end

class UsuarioYaRegistrado < StandardError
  def initialize(msg = 'El usuario ya esta registrado')
    super
  end
end

class ContenidoInexistente < StandardError
  def initialize(msg = 'El contenido no existe')
    super
  end
end

class ComandoInvalido < StandardError
  def initialize(msg = 'Id de contenido no especificado')
    super
  end
end

class ValidadorSistema
  def self.existe_usuario(repositorio, username)
    raise UsuarioInexistente unless repositorio.existe?(username)
  end

  def self.existe_usuario_con_id(repositorio, username)
    raise UsuarioInexistente unless repositorio.existe_con_id?(username)
  end

  def self.existe_contenido(repositorio, id_contenido)
    raise ContenidoInexistente unless repositorio.existe?(id_contenido)
  end
end

class Sistema
  attr_reader :repositorio_usuarios, :repositorio_contenido, :repositorio_reproducciones, :repositorio_coleccion_contenido, :repositorio_autores

  def initialize(configuracion_repositorios)
    @repositorio_usuarios = configuracion_repositorios.repositorio_usuarios
    @repositorio_contenido = configuracion_repositorios.repositorio_contenido
    @repositorio_reproducciones = configuracion_repositorios.repositorio_reproducciones
    @repositorio_coleccion_contenido = configuracion_repositorios.repositorio_coleccion_contenido
    @repositorio_autores = configuracion_repositorios.repositorio_autores
  end

  def crear_usuario(email, username)
    raise UsuarioYaRegistrado if @repositorio_usuarios.existe?(username)

    usuario = Usuario.new(email, username, @repositorio_contenido, @repositorio_coleccion_contenido)
    @repositorio_usuarios.save(usuario)
    usuario
  end

  def novedades(username)
    ValidadorSistema.existe_usuario(@repositorio_usuarios, username)
    usuario = @repositorio_usuarios.find_by_username(username)
    usuario.obtener_novedades(Boletin.new(@repositorio_contenido, @repositorio_reproducciones))
  end

  def populares(username)
    ValidadorSistema.existe_usuario(@repositorio_usuarios, username)
    usuario = @repositorio_usuarios.find_by_username(username)
    usuario.obtener_populares(Boletin.new(@repositorio_contenido, @repositorio_reproducciones))
  end

  def usuarios
    @repositorio_usuarios.all
  end

  def nuevo_contenido(tipo, nombre_autor, titulo, duracion, fecha_lanzamiento)
    ValidadorContenido.valido(tipo, nombre_autor, titulo, fecha_lanzamiento, duracion)
    FabricaContenido.crear(tipo).new(nombre_autor, titulo, duracion, fecha_lanzamiento)
  end

  def registrar_contenido(contenido)
    return true if contenido.registrar(@repositorio_contenido)

    false
  end

  def registrar_reproduccion(username, id_contenido)
    ValidadorSistema.existe_usuario(@repositorio_usuarios, username)
    ValidadorSistema.existe_contenido(@repositorio_contenido, id_contenido)

    usuario = @repositorio_usuarios.find_by_username(username)
    contenido = @repositorio_contenido.find(id_contenido)
    contenido.reproducir(usuario, @repositorio_reproducciones)
  end

  def agregar_a_playlist(username, id_contenido)
    ValidadorSistema.existe_usuario(repositorio_usuarios, username)
    raise ComandoInvalido if id_contenido.nil?

    ValidadorSistema.existe_contenido(repositorio_contenido, id_contenido)

    usuario = @repositorio_usuarios.find_by_username(username)
    contenido = @repositorio_contenido.find(id_contenido)
    usuario.agregar_contenido_a_playlist(contenido)
    contenido
  end

  def obtener_canciones_en_playlist(username)
    ValidadorSistema.existe_usuario(repositorio_usuarios, username)

    usuario = @repositorio_usuarios.find_by_username(username)
    usuario.obtener_canciones_en_playlist
  end

  def obtener_informacion_contenido(id_contenido, username)
    ValidadorSistema.existe_usuario(@repositorio_usuarios, username)
    ValidadorSistema.existe_contenido(@repositorio_contenido, id_contenido)

    @repositorio_contenido.find(id_contenido)
  end

  def dar_me_gusta(username, id_contenido)
    ValidadorSistema.existe_usuario(repositorio_usuarios, username)
    ValidadorSistema.existe_contenido(repositorio_contenido, id_contenido)

    contenido = repositorio_contenido.find(id_contenido)
    usuario = @repositorio_usuarios.find_by_username(username)
    usuario.dar_me_gusta(contenido, @repositorio_reproducciones)
  end

  def sugerencias(username)
    ValidadorSistema.existe_usuario(repositorio_usuarios, username)

    usuario = @repositorio_usuarios.find_by_username(username)
    contenido = usuario.obtener_sugerencia
    contenido.autor
  rescue ContenidoInexistente
    nil
  end

  def obtener_artista_favorito(username)
    ValidadorSistema.existe_usuario(repositorio_usuarios, username)

    @repositorio_usuarios.find_by_username(username).obtener_artista_favorito
  end

  def recomendacion(artista, conector_recomendaciones)
    conector_recomendaciones.obtener_artista_similar(artista)
  end

  def resetear
    @repositorio_usuarios.delete_all
    @repositorio_contenido.delete_all
    @repositorio_reproducciones.delete_all
    @repositorio_coleccion_contenido.delete_all
    @repositorio_autores.delete_all
  end
end
