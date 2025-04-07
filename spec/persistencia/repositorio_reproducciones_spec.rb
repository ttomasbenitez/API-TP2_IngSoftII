require 'integration_helper'
require_relative '../../persistencia/repositorio_reproducciones'

describe RepositorioReproducciones do
  let(:usuario) { instance_double('Usuario', id: 1, username: 'pepe') }

  it 'deberia guardar y asignar id si la reproduccion es nueva' do
    contenido = Cancion.new('Shakira', 'Waka waka', '3:25', '2010-08-08')

    id_contenido_guardado = described_class.new.guardar_reproduccion(usuario, contenido)
    expect(id_contenido_guardado).not_to be_nil
  end

  it 'metodo buscar_por_usuario_y_contenido deberia devolver una reproduccion si esta registrada' do
    contenido = Cancion.new('Shakira', 'Waka waka', '3:25', '2010-08-08')
    RepositorioContenido.new.save(contenido)
    described_class.new.guardar_reproduccion(usuario, contenido)
    contenidos_reproducidos = described_class.new.buscar_por_usuario_y_contenido(usuario, contenido)
    expect(contenidos_reproducidos.nombre_autor).to eq 'Shakira'
  end
end
