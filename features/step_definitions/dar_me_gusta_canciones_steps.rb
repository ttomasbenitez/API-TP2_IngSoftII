Dado('la canción con ID <id_cancion> existe en el sistema') do
  @id_usuario = '72372372'
  @id_contenido = '1'
  @cancion_wakawaka = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', @id_contenido)
  @cancion_wakawaka.registrar(RepositorioContenido.new)
  @cancion_wakawaka.reproducir(@usuario, RepositorioReproducciones.new)
end

Cuando('envía el comando me_gusta con <id_cancion>') do
  request_body = { id_usuario: @id_usuario, id_contenido: @id_contenido }.to_json
  @respuesta = Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('la canción se marca como me_gusta correctamente') do
  expect(@respuesta.status).to eq 201
  respuesta_parseada = JSON.parse(@respuesta.body)
  expect(respuesta_parseada['autor']).to eq 'Shakira'
  expect(respuesta_parseada['titulo']).to eq 'Waka waka'
end

Entonces('se envía un mensaje de error indicando que debe registrarse') do
  expect(@respuesta.status).to eq 401
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El usuario no existe'
end

Cuando('envía el comando me_gusta sin incluir <id_cancion>') do
  @id_usuario = '72372372'
  request_body = { id_usuario: @id_usuario }.to_json
  @respuesta = Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se envía un mensaje de error indicando que debe proporcionar el ID de la canción') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no existe'
end

Dado('la canción con ID <id_cancion> no existe en el sistema') do
  nil
end

Entonces('se envía un mensaje de error indicando que la canción no existe') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no existe'
end

Dado('la canción ya está marcada como me_gusta') do
  id_contenido = '1'
  request_body = { id_usuario: @id_usuario, id_contenido: }.to_json
  Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se envía un mensaje indicando que ya le ha dado me_gusta a esta canción') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido ya se encuentra en la coleccion'
end
