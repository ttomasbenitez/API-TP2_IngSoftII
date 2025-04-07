Dado('el episodio con ID <id_episodio> existe en el sistema') do
  @id_usuario = '72372372'
  @id_contenido = '1'
  @episodio_olga = Episodio.new('Olga', 'Episodio 1', '1:33:30', '2010-05-07', @id_contenido)
  @episodio_olga.registrar(RepositorioContenido.new)
  @episodio_olga.reproducir(@usuario, RepositorioReproducciones.new)
end

Cuando('envía el comando me_gusta con <id_episodio>') do
  request_body = { id_usuario: @id_usuario, id_contenido: @id_contenido }.to_json
  @respuesta = Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('el episodio se marca como me_gusta correctamente') do
  expect(@respuesta.status).to eq 201
  respuesta_parseada = JSON.parse(@respuesta.body)
  expect(respuesta_parseada['autor']).to eq 'Olga'
  expect(respuesta_parseada['titulo']).to eq 'Episodio 1'
end

Cuando('envía el comando me_gusta sin incluir <id_episodio>') do
  request_body = { id_usuario: @id_usuario }.to_json
  @respuesta = Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se envía un mensaje de error indicando que debe proporcionar el ID del episodio') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no existe'
end

Dado('el episodio con ID <id_episodio> no existe en el sistema') do
  nil
end

Entonces('se envía un mensaje de error indicando que el episodio no existe') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no existe'
end

Dado('el episodio ya está marcado como me_gusta') do
  request_body = { id_usuario: @id_usuario, id_contenido: @id_contenido }.to_json
  Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se envía un mensaje indicando que ya le ha dado me_gusta a este episodio') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido ya se encuentra en la coleccion'
end
