require 'spec_helper'
require_relative '../dominio/contenido'
require_relative '../dominio/coleccion_contenido'

class RespositorioColeccionFake
  def initialize
    @contenido = []
  end

  def guardar(_nombre_coleccion, _usuario, contenidos)
    @contenido = contenidos
    contenidos
  end

  def obtener_contenidos(_nombre_coleccion, _usuario)
    @contenido
  end

  def existe?(_nombre, _usuario, _contenido)
    false
  end
end

describe 'ColeccionContenidos' do
  let(:repositorio) { RespositorioColeccionFake.new }

  it 'se inicia vacía si no hay canciones guardadas' do
    usuario = Usuario.new('pepe@pepito.com', 'test_username', nil, repositorio)
    coleccion = ColeccionContenido.new('favoritos', usuario, repositorio)

    expect(coleccion.tamanio).to eq 0
  end

  it 'tiene tamanio 1 despues de agregar la primera cancion' do
    usuario = Usuario.new('pepe@pepito.com', 'test_username', nil, repositorio)
    coleccion = ColeccionContenido.new('favoritos', usuario, repositorio)

    una_cancion = Cancion.new('Shakira', 'Waka waka', '3:30', '2014-05-05')
    coleccion.agregar_contenido(una_cancion)

    expect(coleccion.tamanio).to eq 1
  end

  it 'obtenego contenido cuando tiene una cancion' do
    usuario = Usuario.new('pepe@pepito.com', 'test_username', nil, repositorio)
    coleccion = ColeccionContenido.new('favoritos', usuario, repositorio)

    coleccion.agregar_contenido(Cancion.new('Shakira', 'Waka waka', '3:30', '2014-05-05'))
    contenido_coleccion = coleccion.obtener_contenidos

    expect(contenido_coleccion[0].titulo).to eq 'Waka waka'
  end

  it 'deberia levantar error cuando intento agregar episodio de podcast a playlist' do
    episodio = Episodio.new('un podcast', 'episodio 80', '3:25:12', '2017-02-08')
    mi_playlist = Playlist.new('mi playlist', Usuario.new('pepe@pepito.com', 'test_username', nil, repositorio), repositorio)
    expect { mi_playlist.agregar_contenido(episodio) }.to raise_error(ContenidoNoAgregable)
  end
end
