Cuando('intenta obtener información') do
  @respuesta = Faraday.get("/contenido/#{@id_contenido}?id_usuario=#{@id_usuario}", { 'Content-Type' => 'application/json' })
end

Dado('el contenido con id {int} no existe') do |id_contenido|
  @id_contenido = id_contenido
  @cancion_wakawaka = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', @id_contenido)
end

Entonces('se envía un mensaje indicando que el contenido no existe') do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El contenido no existe'
end

Dado('existe una canción con id {int}') do |id_contenido|
  @id_contenido = id_contenido
  @cancion_wakawaka = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', @id_contenido)
  @cancion_wakawaka.registrar(RepositorioContenido.new)
end

Entonces('se envía un mensaje con información de la canción {int}') do |id|
  expect(@respuesta.status).to eq 200
  json_response = JSON.parse(@respuesta.body)
  expect(json_response['autor']).to eq 'Shakira'
  expect(json_response['id']).to eq id
  expect(json_response['titulo']).to eq 'Waka waka'
end

Dado('existe un episodio de podcast con id {int}') do |id_contenido|
  @id_contenido = id_contenido
  @episodio_olga = Episodio.new('Olga', 'Episodio 36', '1:30:30', '2025-05-07', @id_contenido)
  @episodio_olga.registrar(RepositorioContenido.new)
end

Entonces('se envía un mensaje con información del episodio de podcast {int}') do |id_contenido|
  expect(@respuesta.status).to eq 200
  json_response = JSON.parse(@respuesta.body)
  expect(json_response['autor']).to eq 'Olga'
  expect(json_response['id']).to eq id_contenido
  expect(json_response['titulo']).to eq 'Episodio 36'
end
