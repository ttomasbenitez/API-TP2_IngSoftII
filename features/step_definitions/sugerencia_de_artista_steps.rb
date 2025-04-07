When(/^se envía un mensaje indicando que debe registrarse$/) do
  expect(@respuesta.status).to eq 401
  json_response = JSON.parse(@respuesta.body)
  expect(json_response['error']).to eq 'El usuario no existe'
end

When(/^la última canción que agrego a su playlist es de "([^"]*)"$/) do |artista|
  repositorio_contenido = RepositorioContenido.new
  cancion = Cancion.new(artista, 'Just Dance', 3.5, '2009-01-01')
  cancion.registrar(repositorio_contenido)
  request_body = { id_usuario: @id_usuario, id_contenido: cancion.id }.to_json
  Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

When(/^no registró canciones en su playlist$/) do
  nil
end

When(/^recibe una sugerencia de "([^"]*)"$/) do |artista|
  expect(@respuesta.status).to eq 200
  json_response = JSON.parse(@respuesta.body)
  expect(json_response['sugerencia']).to eq artista
end

When(/^consulta por una sugerencia$/) do
  @respuesta = Faraday.get("/sugerencias/#{@id_usuario}", '', { 'Content-Type' => 'application/json' })
end

When(/^no recibe ninguna sugerencia$/) do
  expect(@respuesta.status).to eq 200
  expect(@respuesta.body).to eq '{}'
end
