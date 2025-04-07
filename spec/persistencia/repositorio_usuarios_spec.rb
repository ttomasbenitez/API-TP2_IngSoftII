require 'integration_helper'
require_relative '../../dominio/usuario'
require_relative '../../persistencia/repositorio_usuarios'

describe RepositorioUsuarios do
  it 'deberia guardar y asignar id si el usuario es nuevo' do
    juan = Usuario.new('juan@test.com', '7373732', nil, nil)
    described_class.new.save(juan)
    expect(juan.id).not_to be_nil
    expect(juan.username).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_usuarios_iniciales = repositorio.all.size
    juan = Usuario.new('juan@test.com', '7373732', nil, nil)
    repositorio.save(juan)
    expect(repositorio.all.size).to be(cantidad_de_usuarios_iniciales + 1)
  end

  it 'deberia buscar el usuario por chat_id' do
    repositorio = described_class.new
    juan = Usuario.new('juan@test.com', '7373732', nil, nil)
    repositorio.save(juan)

    usuario_buscado = repositorio.find_by_username('7373732')
    expect(usuario_buscado.username).to eq '7373732'
  end
end
