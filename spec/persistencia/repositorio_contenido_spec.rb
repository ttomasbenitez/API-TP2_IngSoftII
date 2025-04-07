require 'integration_helper'
require_relative '../../dominio/contenido'
require_relative '../../persistencia/repositorio_contenido'

describe RepositorioContenido do
  it 'deberia guardar y asignar id si el contenido es nuevo' do
    cancion = Cancion.new('Shakira', 'untitulo', '3:30', '2010-05-05')
    described_class.new.save(cancion)
    expect(cancion.id).not_to be_nil
  end
end
