class SinReproducciones < StandardError
  def initialize(msg = 'No hay contenido popular')
    super
  end
end

class Boletin
  NOVEDADES_A_TRAER = 3
  POPULARES_A_TRAER = 5

  def initialize(repositorio_contenido, repositorio_reproducciones)
    @repositorio_contenido = repositorio_contenido
    @repositorio_reproducciones = repositorio_reproducciones
  end

  def obtener_novedades
    @repositorio_contenido.obtener_ultimos_n_agregados(NOVEDADES_A_TRAER)
  end

  def obtener_populares
    canciones = @repositorio_reproducciones.all
    raise SinReproducciones if canciones.empty?

    conteo = conteo_canciones(canciones)
    canciones_populares(conteo, canciones, POPULARES_A_TRAER)
  end

  private

  def conteo_canciones(canciones)
    canciones.each_with_object(Hash.new(0)) do |cancion, conteo|
      clave = [cancion.nombre_autor, cancion.titulo]
      conteo[clave] += 1
    end
  end

  def canciones_populares(conteo, canciones, limite)
    canciones_ordenadas = conteo.sort_by { |_clave, frecuencia| -frecuencia }

    canciones_ordenadas.first(limite).map do |(nombre_autor, titulo), _frecuencia|
      canciones.find { |c| c.nombre_autor == nombre_autor && c.titulo == titulo }
    end
  end
end
