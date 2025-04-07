require 'spec_helper'
require_relative '../dominio/boletin'

describe 'Boletin' do
  let(:repo_sin_novedades) { instance_double('RepositorioContenido', obtener_ultimos_n_agregados: []) }
  let(:repo_con_novedades) do
    instance_double('RepositorioContenido', obtener_ultimos_n_agregados: [
                      Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10'),
                      Cancion.new('The Beatles', 'Nowhere man', '2:30', '1966-10-10'),
                      Cancion.new('The Beatles', 'Strawberry fields', '2:30', '1966-10-10')
                    ])
  end
  let(:repo_reproducciones) do
    instance_double('RepositorioContenido', all: [
                      Cancion.new('The Beatles', 'Nowhere man', '2:30', '1966-10-10'),
                      Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10'),
                      Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10')
                    ])
  end

  it 'debería devolver un array vacio si no hay novedades' do
    expect(Boletin.new(repo_sin_novedades, nil).obtener_novedades).to eq []
  end

  it 'debería devolver un array de largo 3 si hay novedades' do
    expect(Boletin.new(repo_con_novedades, nil).obtener_novedades.size).to eq 3
  end

  it 'debería leventar un error si no hay populares' do
    repo_reproducciones_sin_reproducciones = instance_double('RepositorioReproducciones', all: [])
    expect { Boletin.new(nil, repo_reproducciones_sin_reproducciones).obtener_populares }.to raise_error(SinReproducciones)
  end

  it 'deberia devolver el contenido mas escuchado primero si consulto populares' do
    expect(Boletin.new(RepositorioContenido.new, repo_reproducciones).obtener_populares[0].titulo).to eq 'Help'
  end
end
