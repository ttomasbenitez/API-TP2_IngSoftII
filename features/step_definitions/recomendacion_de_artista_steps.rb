require_relative '../support/stubs'

Dado('su artista con más me gusta es {string}') do |artista|
  @id_usuario = '72372372'
  @cancion1 = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07')
  @cancion2 = Cancion.new(artista, 'Tu vicio', '3:30', '1990-05-07')
  @cancion3 = Cancion.new(artista, 'cancion1', '3:30', '1980-05-07')
  @cancion1.registrar(RepositorioContenido.new)
  @cancion2.registrar(RepositorioContenido.new)
  @cancion3.registrar(RepositorioContenido.new)
  @cancion1.reproducir(@usuario, RepositorioReproducciones.new)
  @cancion2.reproducir(@usuario, RepositorioReproducciones.new)
  @cancion3.reproducir(@usuario, RepositorioReproducciones.new)
  @repo_reproducciones = RepositorioReproducciones.new
  @usuario.dar_me_gusta(@cancion1, @repo_reproducciones)
  @usuario.dar_me_gusta(@cancion2, @repo_reproducciones)
  @usuario.dar_me_gusta(@cancion3, @repo_reproducciones)
  expect(@usuario.obtener_artista_favorito.nombre).to eq artista
end

Cuando('obtiene una recomendación') do
  @artista_similar = 'Pedro Aznar'
  obtengo_token
  obtengo_id_de_artista('fake', 'Charly Garcia', 'unId')
  obtengo_artista_similar('fake', 'unId', @artista_similar)
  @respuesta = Faraday.get("/recomendaciones/#{@id_usuario}", '', { 'Content-Type' => 'application/json' })
end

Entonces('recibe una recomendación de un artista similar a {string}') do |artista|
  expect(@respuesta.status).to eq 200
  json_response = JSON.parse(@respuesta.body)
  expect(json_response['favorito']).to eq artista
  expect(json_response['recomendacion']).to eq @artista_similar
end

Dado('no le dio me gusta a ninguna canción') do
  nil
end

Entonces('recibe un mensaje indicando que no hay recomendaciones disponibles') do
  expect(@respuesta.status).to eq 200
  json_response = JSON.parse(@respuesta.body)
  expect(json_response.size).to eq 0
end
