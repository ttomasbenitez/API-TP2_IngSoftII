class ContenidoDuplicadoEnColeccion < StandardError
  def initialize(msg = 'El contenido ya se encuentra en la coleccion')
    super
  end
end

class ContenidoNoAgregable < StandardError
  def initialize(msg = 'El contenido no puede agregarse a una playlist')
    super
  end
end

class UsuarioSinFavoritos < StandardError
  def initialize(msg = 'El usuario no tiene favoritos')
    super
  end
end

class ColeccionContenido
  POSICION_ARTISTA_FAVORITO = 1
  POSICION_CONTENIDO_ARTISTA_FAVORITO = 0

  def initialize(nombre, usuario, repositorio_coleccion_contenido)
    @nombre = nombre
    @usuario = usuario
    @repositorio_coleccion_contenido = repositorio_coleccion_contenido
  end

  def agregar_contenido(contenido)
    raise ContenidoDuplicadoEnColeccion if @repositorio_coleccion_contenido.existe?(@nombre, @usuario.username, contenido)

    contenidos = obtener_contenidos

    nuevo_contenidos = contenidos + [contenido]

    @repositorio_coleccion_contenido.guardar(@nombre, @usuario, nuevo_contenidos)
  end

  def obtener_contenidos
    @repositorio_coleccion_contenido.obtener_contenidos(@nombre, @usuario)
  end

  def obtener_ultimo_contenido_aniadido(usuario)
    @repositorio_coleccion_contenido.ultimo_contenido_agregado(@nombre, usuario)
  end

  def tamanio
    @repositorio_coleccion_contenido.obtener_contenidos(@nombre, @usuario).size
  end

  def obtener_artista_favorito
    contenidos = obtener_contenidos
    artista_con_mas_favoritos = contenidos
                                .group_by(&:nombre_autor)
                                .min_by { |nombre_artista, contenidos_artista| [-contenidos_artista.size, nombre_artista.downcase] }

    raise UsuarioSinFavoritos if artista_con_mas_favoritos.nil?

    artista_con_mas_favoritos.fetch(POSICION_ARTISTA_FAVORITO)
                             .fetch(POSICION_CONTENIDO_ARTISTA_FAVORITO)
                             .autor
  end
end

class Playlist < ColeccionContenido
  def agregar_contenido(contenido)
    raise ContenidoNoAgregable unless contenido.puede_agregarse_a_playlist?

    super(contenido)
  end
end
