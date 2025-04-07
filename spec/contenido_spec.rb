require 'spec_helper'
require_relative '../dominio/contenido'

class RespositorioContenidoFake
  def save(_contenido)
    true
  end
end

describe 'Contenido' do
  let(:repositorio_reproducciones) { instance_double('RepositorioReproducciones', guardar_reproduccion: []) }
  let(:usuario) { instance_double('Usuario', id: 1, username: 'pepe') }

  it 'debería devolver true si el repositorio dice que se registro bien' do
    cancion = Cancion.new('Shakira', 'titulo', 'duracion', '2008-08-08')
    expect(cancion.registrar(RespositorioContenidoFake.new)).to be true
  end

  it 'deberia devolver true al guardar un episodio de podcast' do
    episodio = Episodio.new('un podcast', 'episodio 4', '1:04:20', '2008-08-08')
    expect(episodio.registrar(RespositorioContenidoFake.new)).to eq true
  end

  it 'deberia devolver false si la fecha de lanzamiento es "cancun"' do
    expect(ValidadorContenido.fecha_valida?('cancun')).to eq false
  end

  it 'deberia devolver false si tiene mes inexistente' do
    expect(ValidadorContenido.fecha_valida?('2024-15-1')).to eq false
  end

  it 'deberia devolver true si la fecha es valida' do
    expect(ValidadorContenido.fecha_valida?('2024-10-12')).to eq true
  end

  it 'la duracion no es valida si es un string vacio ' do
    expect(ValidadorContenido.duracion_valida?('')).to eq false
  end

  it 'la duracion es valida si tiene dos miembros' do
    expect(ValidadorContenido.duracion_valida?('2:30')).to eq true
  end

  it 'la duracion es valida si tiene tres miembros' do
    expect(ValidadorContenido.duracion_valida?('2:30:14')).to eq true
  end

  it 'la duracion no es valida si tiene un solo miembro' do
    expect(ValidadorContenido.duracion_valida?('2')).to eq false
  end

  it 'la duracion no es valida si no tiene formato de tiempo' do
    expect(ValidadorContenido.duracion_valida?('hola:que:tal')).to eq false
  end

  it 'la duracion no es valida si no tiene unidades validas de tiempo' do
    expect(ValidadorContenido.duracion_valida?('1:89:12')).to eq false
  end

  it 'la duracion no es valida si tiene mas unidades que horas, minutos y segundos' do
    expect(ValidadorContenido.duracion_valida?('2:15:52:12')).to eq false
  end

  it 'el tipo deberia ser valido si se envia episodio' do
    expect(ValidadorContenido.tipo_valido?('episodio')).to eq true
  end

  it 'el tipo deberia ser valido si se envia cancion' do
    expect(ValidadorContenido.tipo_valido?('cancion')).to eq true
  end

  it 'el tipo deberia ser invalido si no es cancion ni episodio' do
    expect(ValidadorContenido.tipo_valido?('audiolibro')).to eq false
  end

  it 'el tipo deberia ser valido si es un tipo valido en mayuscula' do
    expect(ValidadorContenido.tipo_valido?('CANCION')).to eq true
  end

  it 'deberia devolver el contenido si la reproducción se realizo correctamente' do
    cancion = Cancion.new('Shakira', 'Waka waka', '3:25', '2010-08-08')
    expect(cancion.reproducir(usuario, repositorio_reproducciones).titulo).to eq 'Waka waka'
  end

  it 'episodio de podcast no debe poder agregarse a una playlist' do
    episodio = Episodio.new('un podcast', 'episodio 80', '3:25:12', '2017-02-08')
    expect(episodio.puede_agregarse_a_playlist?).to eq false
  end

  it 'cancion debe poder agregarse a una playlist' do
    cancion = Cancion.new('Shakira', 'Waka waka', '3:12', '2010-02-08')
    expect(cancion.puede_agregarse_a_playlist?).to eq true
  end
end
