Cuando('intenta obtener el contenido más popular') do
  @respuesta = Faraday.get("/populares/#{@id_usuario}", '', { 'Content-Type' => 'application/json' })
end

Dado('no hay ninguna reproducción registrada en el sistema') do
  nil
end

Entonces('se envía un mensaje indicando que no hay reproducciones') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'No hay contenido popular'
end

Dado('sólo el contenido {string} tiene reproducciones') do |string|
  cancion = Cancion.new('Artista', string, '3:30', '1986-10-10', 1)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, RepositorioReproducciones.new)
end

Entonces('se envía un mensaje con el contenido {string}') do |string|
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta[0]['titulo']).to eq string
end

Dado('existen varios contenidos con reproducciones') do
  repo_reproducciones = RepositorioReproducciones.new
  cancion = Cancion.new('The Beatles', 'Help', '3:30', '1965-10-10', 1)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion = Cancion.new('The Beatles', 'Nowhere man', '3:30', '1965-10-10', 2)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion = Cancion.new('The Beatles', 'Strawberry fields', '3:30', '1965-10-10', 3)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion = Cancion.new('The Beatles', 'Twist and shout', '3:30', '1965-10-10', 4)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion = Cancion.new('The Beatles', 'Golden slumbers', '3:30', '1965-10-10', 5)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
  cancion = Cancion.new('The Beatles', 'Obla di obla da', '3:30', '1965-10-10', 6)
  RepositorioContenido.new.save(cancion)
  cancion.reproducir(@usuario, repo_reproducciones)
end

Entonces('se envía un mensaje con varios contenidos ordenados por cantidad de reproducciones') do
  respuesta_json = JSON.parse(@respuesta.body)
  expect(respuesta_json.size).to eq 5
  expect(respuesta_json[0]['titulo']).to eq 'Strawberry fields'
end
