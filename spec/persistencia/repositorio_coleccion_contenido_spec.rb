require 'integration_helper'
require_relative '../../dominio/contenido'
require_relative '../../dominio/usuario'
require_relative '../../dominio/autor'
require_relative '../../persistencia/repositorio_coleccion_contenido'
require_relative '../../persistencia/repositorio_usuarios'

HANDLE_USUARIO = '@miusuario'.freeze
ID_CONTENIDO = 1

describe RepositorioColeccionContenido do
  it 'existe? deberia devolver true si para un usuario, el contenido ya existe' do
    repositorio_coleccion = described_class.new
    usuario = Usuario.new('pepe@pepito.com', HANDLE_USUARIO, nil, repositorio_coleccion)
    una_cancion = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-05', ID_CONTENIDO)
    repositorio_coleccion.guardar('favoritos', usuario, [una_cancion])
    expect(repositorio_coleccion.existe?('favoritos', HANDLE_USUARIO, una_cancion)).to eq true
  end
end
