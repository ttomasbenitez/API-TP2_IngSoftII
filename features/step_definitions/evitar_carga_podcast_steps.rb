Cuando('intenta agregar un episodio de podcast a su playlist') do
  request_body = { id_usuario: @id_usuario, id_contenido: @id_contenido }.to_json
  @respuesta = Faraday.post('/playlist', request_body, { 'Content-Type' => 'application/json' })
end

Cuando('existe un episodio de podcast con id de contenido {int}') do |id_contenido|
  @id_contenido = id_contenido
  episodio_podcast = Episodio.new('un podcast', 'episodio 4', '3:30:20', '2020-01-5', id_contenido)
  RepositorioContenido.new.save(episodio_podcast)
end

Entonces('se envía un mensaje indicando que no puede cargar un podcast a su playlist') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no puede agregarse a una playlist'
end
