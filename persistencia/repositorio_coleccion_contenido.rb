require_relative './abstract_repository'
require_relative './repositorio_contenido'
require_relative '../dominio/contenido'

class RepositorioColeccionContenido < AbstractRepository
  self.table_name = :coleccion_contenidos

  def guardar(nombre_coleccion, usuario, contenidos)
    contenidos.each do |contenido|
      next if existe?(nombre_coleccion, usuario.username, contenido)

      dataset.insert(
        nombre: nombre_coleccion,
        id_usuario: usuario.username,
        id_contenido: contenido.id,
        created_on: Time.now,
        updated_on: Time.now
      )
    end
    true
  end

  def ultimo_contenido_agregado(nombre_coleccion, usuario)
    record = dataset.where(nombre: nombre_coleccion, id_usuario: usuario.username).order(:created_on).last
    raise ContenidoInexistente if record.nil?

    RepositorioContenido.new.find(record[:id_contenido])
  end

  def obtener_contenidos(nombre_coleccion, usuario)
    username = usuario.username
    items = dataset.where(nombre: nombre_coleccion, id_usuario: username).to_a

    return [] if items.empty?

    items.map do |item|
      RepositorioContenido.new.find(item[:id_contenido])
    end
  end

  def existe?(nombre_coleccion, username, contenido)
    dataset.where(nombre: nombre_coleccion, id_usuario: username, id_contenido: contenido.id).count.positive?
  end

  protected

  def load_object(a_hash)
    RepositorioContenido.new.find(a_hash[:id_contenido])
  end

  def changeset(row)
    {
      nombre: row[:nombre],
      id_usuario: row[:id_usuario],
      id_contenido: row[:id_contenido]
    }
  end
end
