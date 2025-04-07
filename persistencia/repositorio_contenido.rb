require_relative './abstract_repository'
require_relative '../dominio/fabrica_contenido'
require_relative './repositorio_autores'

class RepositorioContenido < AbstractRepository
  self.table_name = :contenido
  self.model_class = 'Contenido'

  def existe?(id)
    return false if dataset.where(id:).first.nil?

    true
  end

  def obtener_ultimos_n_agregados(cantidad)
    records = dataset.order(Sequel.desc(:created_on)).limit(cantidad).all

    contenidos_recientes = []
    records.each do |record|
      contenidos_recientes.push(load_object(record))
    end

    contenidos_recientes
  end

  protected

  def load_object(a_hash)
    autor = RepositorioAutores.new.find(a_hash[:autor_id])
    FabricaContenido.crear(a_hash[:tipo])
                    .new(autor.nombre, a_hash[:titulo], a_hash[:duracion], a_hash[:fecha_lanzamiento], a_hash[:id])
  end

  def changeset(contenido)
    crear_autor_si_no_existe(contenido.autor)

    changeset = {
      tipo: contenido.tipo,
      autor_id: RepositorioAutores.new.obtener_id_con_nombre(contenido.nombre_autor),
      titulo: contenido.titulo,
      duracion: contenido.duracion,
      fecha_lanzamiento: contenido.fecha_lanzamiento
    }
    changeset[:id] = contenido.id if contenido.id
    changeset
  end

  def crear_autor_si_no_existe(autor)
    registro = RepositorioAutores.new.find_by_nombre(autor.nombre)
    RepositorioAutores.new.save(autor) if registro.nil?
  end
end
