require 'spec_helper'
require_relative '../dominio/contenido'
require_relative '../dominio/usuario'

ID_CANCION = 1
describe 'Usuario' do
  let(:una_cancion) { Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-11', ID_CANCION) }
  let(:repo_playlist_con_canciones) do
    instance_double(
      'RepositorioColeccionContenido',
      guardar: una_cancion,
      obtener_contenidos: [Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10')],
      existe?: false
    )
  end
  let(:repo_favoritos_con_canciones) do
    instance_double('RepositorioColeccionContenido', obtener_contenidos:
      [Cancion.new('Shakira', 'Loba', '2:30', '2001-10-10'),
       Cancion.new('Shakira', 'Tu', '2:30', '2000-10-10'),
       Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10')])
  end
  let(:repo_favoritos_empatados) do
    instance_double('RepositorioColeccionContenido', obtener_contenidos:
      [Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10'),
       Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10'),
       Cancion.new('Shakira', 'Loba', '2:30', '2001-10-10'),
       Cancion.new('Shakira', 'Tu', '2:30', '2000-10-10')])
  end

  it 'debería obtener cancion si pudo guardarselo en la playlist' do
    usuario = Usuario.new('pepe@pepito.com', '1_2_3', 1, repo_playlist_con_canciones)
    expect(usuario.agregar_contenido_a_playlist(una_cancion).nombre_autor).to eq 'Shakira'
  end

  it 'deberia tener playlist de longitud 1 luego de agregar una cancion' do
    usuario = Usuario.new('pepe@pepito.com', '1_2_3', 1, repo_playlist_con_canciones)
    usuario.agregar_contenido_a_playlist(una_cancion)

    expect(usuario.obtener_canciones_en_playlist.size).to eq 1
  end

  it 'el email no deberia ser valido si viene nulo' do
    expect { Usuario.new(nil, '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si viene vacio' do
    expect { Usuario.new('', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si no tiene un arroba' do
    expect { Usuario.new('holaquetal', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si no tiene mas de un arroba' do
    expect { Usuario.new('hola@que@tal', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario es vacio' do
    expect { Usuario.new('@quetal', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el dominio es vacio' do
    expect { Usuario.new('hola@', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario empieza con un punto' do
    expect { Usuario.new('.hola@fi.uba.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario termina con un punto' do
    expect { Usuario.new('hola.@fi.uba.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario tiene caracteres invalidos' do
    expect { Usuario.new('(hola)@fi.uba.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario tiene 2 caracteres especiales consecutivos' do
    expect { Usuario.new('ho..la@fi.uba.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el nombre de usuario tiene un caracter especial no está seguido de una letra' do
    expect { Usuario.new('hola-@fi.uba.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el domino no tiene un punto' do
    expect { Usuario.new('hola@fi', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si la ultima parte del dominio tiene un solo caracter' do
    expect { Usuario.new('hola@uba.a', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el dominio tiene partes del dominio vacias' do
    expect { Usuario.new('hola@uba..ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si el dominio tiene un caracter invalido' do
    expect { Usuario.new('hola@fi.(uba).ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si una parte del dominio comienza con guion' do
    expect { Usuario.new('hola@-fi.ar', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'el email no deberia ser valido si una parte del dominio termina con guion' do
    expect { Usuario.new('hola@fi.ar-', '1_2_3', nil, nil) }.to raise_error(EmailInvalido)
  end

  it 'reprodujo? debería ser true si se reprodujo el contenido' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', nil, nil)
    contenido = Cancion.new('Charly Garcia', 'Cerca de la revolucion', '3:30', '2005-09-12')
    RepositorioContenido.new.save(contenido)
    contenido.reproducir(usuario, RepositorioReproducciones.new)
    expect(usuario.reprodujo?(contenido, RepositorioReproducciones.new)).to eq true
  end

  it 'dar_me_gusta debería fallar si la canción no fue reproducida' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', RepositorioContenido.new, RepositorioColeccionContenido.new)
    contenido = Cancion.new('Charly Garcia', 'Cerca de la revolucion', '3:30', '2005-09-12')
    RepositorioContenido.new.save(contenido)

    expect { usuario.dar_me_gusta(contenido, RepositorioReproducciones.new) }.to raise_error(ContenidoSinReproducir)
  end

  it 'obtener_artista_favorito debería devolver UsuarioSinFavoritos si el usuario no tiene favoritos' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', RepositorioContenido.new, instance_double('RepositorioColeccionContenido', obtener_contenidos: []))

    expect { usuario.obtener_artista_favorito }.to raise_error(UsuarioSinFavoritos)
  end

  it 'obtener_artista_favorito debería devolver un artista si el usuario tiene un solo favorito de ese artista' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', RepositorioContenido.new,
                          instance_double('RepositorioColeccionContenido', obtener_contenidos: [Cancion.new('The Beatles', 'Help', '2:30', '1966-10-10')]))

    expect(usuario.obtener_artista_favorito.nombre).to eq 'The Beatles'
  end

  it 'obtener_artista_favorito debería devolver el artista favorito si el usuario tiene varios artistas favoritos' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', RepositorioContenido.new, repo_favoritos_con_canciones)

    expect(usuario.obtener_artista_favorito.nombre).to eq 'Shakira'
  end

  it 'obtener_artista_favorito debería desempatar por orden alfabetico si el usuario tiene varios artistas con la misma cantidad de me gustas' do
    usuario = Usuario.new('hola@fi.uba.ar', '1_2_3', RepositorioContenido.new, repo_favoritos_empatados)

    expect(usuario.obtener_artista_favorito.nombre).to eq 'Shakira'
  end
end
