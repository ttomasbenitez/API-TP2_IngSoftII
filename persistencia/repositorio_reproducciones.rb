require_relative './abstract_repository'

class RepositorioReproducciones < AbstractRepository
  self.table_name = :reproducciones

  def guardar_reproduccion(usuario, contenido)
    dataset.insert(id_usuario: usuario.username, id_contenido: contenido.id, created_on: Time.now, updated_on: Time.now)
  end

  def buscar_por_usuario_y_contenido(usuario, contenido)
    record = dataset.where(id_usuario: usuario.username, id_contenido: contenido.id).first
    record.nil? ? nil : load_object(record)
  end

  protected

  def load_object(a_hash)
    RepositorioContenido.new.find(a_hash[:id_contenido])
  end

  def changeset(reproduccion)
    {
      id_usuario: reproduccion[:id_usuario],
      id_contenido: reproduccion[:id_contenido]
    }
  end
end
