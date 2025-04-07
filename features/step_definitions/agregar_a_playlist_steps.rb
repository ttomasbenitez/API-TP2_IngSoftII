Dado('la canción con ID <id_canción> existe en el sistema') do
  @id_usuario = '72372372'
  @id_contenido = '1'
  @cancion_wakawaka = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', @id_contenido)
  @cancion_wakawaka.registrar(RepositorioContenido.new)
end

Cuando('envía el comando guardar con <id_canción>') do
  request_body = { id_usuario: @id_usuario, id_contenido: @id_contenido }.to_json
  @respuesta = Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('la canción se guarda correctamente') do
  expect(@respuesta.status).to eq 201
  respuesta_parseada = JSON.parse(@respuesta.body)
  expect(respuesta_parseada['autor']).to eq 'Shakira'
  expect(respuesta_parseada['titulo']).to eq 'Waka waka'
  expect(RepositorioColeccionContenido.new.all.size).to eq 1
end

Entonces('se envía un error {string}') do |mensaje|
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq mensaje
end

Cuando('envía el comando guardar sin incluir <id_cancion>') do
  @id_usuario = '72372372'
  request_body = { id_usuario: @id_usuario }.to_json
  @respuesta = Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

Dado('la canción con ID <id_contenido> no existe en el sistema') do
  nil
end

Cuando('envía el comando guardar con id_contenido') do
  @id_usuario = '72372372'
  id_contenido = '1'
  request_body = { id_usuario: @id_usuario, id_contenido: }.to_json
  @respuesta = Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

Dado('la canción ya está guardada') do
  @id_usuario = '72372372'
  id_contenido = '1'
  request_body = { id_usuario: @id_usuario, id_contenido: }.to_json
  Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('envía el comando guardar') do
  @id_usuario = '72372372'
  id_contenido = '1'
  request_body = { id_usuario: @id_usuario, id_contenido: }.to_json
  @respuesta = Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end
