require_relative './abstract_repository'

class RepositorioAutores < AbstractRepository
  self.table_name = :autores
  self.model_class = 'Autor'

  def find_by_nombre(nombre)
    record = dataset.where(nombre:).first
    return nil if record.nil?

    load_object(record)
  end

  def obtener_id_con_nombre(nombre)
    record = dataset.where(nombre:).first
    return nil if record.nil?

    record[:id]
  end

  protected

  def load_object(a_hash)
    return Artista.new(a_hash[:nombre]) if a_hash[:tipo] == 'artista'

    Podcast.new(a_hash[:nombre]) if a_hash[:tipo] == 'podcast'
  end

  def changeset(autor)
    changeset = {
      tipo: autor.tipo,
      nombre: autor.nombre
    }
    changeset[:id] = autor.id if autor.id
    changeset
  end
end
