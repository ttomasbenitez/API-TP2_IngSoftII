require_relative './abstract_repository'

class RepositorioUsuarios < AbstractRepository
  self.table_name = :usuarios
  self.model_class = 'Usuario'

  def existe?(username)
    !dataset.where(username: username.to_s).first.nil?
  end

  def existe_con_id?(id)
    !dataset.where(id: id.to_s).first.nil?
  end

  def find_by_username(username)
    load_object dataset.where(username: username.to_s).first
  end

  def find_by_id(id)
    load_object dataset.where(id: id.to_s).first
  end

  protected

  def load_object(a_hash)
    Usuario.new(a_hash[:email], a_hash[:username], RepositorioContenido.new, RepositorioColeccionContenido.new, a_hash[:id])
  end

  def changeset(usuario)
    changeset = {
      email: usuario.email,
      username: usuario.username
    }
    changeset[:id] = usuario.id if usuario.id
    changeset
  end
end
