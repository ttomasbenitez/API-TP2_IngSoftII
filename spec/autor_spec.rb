require 'spec_helper'
require_relative '../dominio/autor'

class RespositorioAutorFake
  def save(_contenido)
    true
  end
end

describe 'Autor' do
  it 'debería devolver true si el repositorio dice que se registro bien' do
    artista = Artista.new('Shakira')
    expect(artista.registrar(RespositorioAutorFake.new)).to be true
  end
end
