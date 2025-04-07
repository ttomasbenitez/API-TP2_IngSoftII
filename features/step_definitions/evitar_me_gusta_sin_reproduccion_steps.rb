Dado('no reprodujo la canción {string}') do |string|
  cancion = Cancion.new('Shakira', string, '3:30', '2010-05-07', 1)
  cancion.registrar(RepositorioContenido.new)
end

Cuando('da me gusta a la canción {string}') do |_string|
  request_body = { id_usuario: @id_usuario, id_contenido: 1 }.to_json
  @respuesta = Faraday.post('/me-gusta', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se envía un mensaje indicando que para dar me gusta a un contenido debe reproducirlo') do
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El contenido no fue reproducido por este usuario'
end
