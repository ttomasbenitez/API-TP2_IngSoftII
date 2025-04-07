Dado('que el usuario está registrado en el sistema') do
  @id_usuario = '72372372'
  @usuario = Usuario.new('pepe@pepito.com', @id_usuario, RepositorioContenido.new, RepositorioColeccionContenido.new)
  RepositorioUsuarios.new.save(@usuario)
end

Dado('existe contenido') do
  @repositorio_contenido = RepositorioContenido.new
  @repositorio_contenido.save(Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', '1'))
  @repositorio_contenido.save(Cancion.new('Shakira', 'Loba', '3:30', '2006-05-07', '2'))
  @repositorio_contenido.save(Cancion.new('Shakira', 'Suerte', '3:30', '2008-05-07', '3'))
end

Cuando('envía el comando novedades') do
  @respuesta = Faraday.get("/novedades/#{@id_usuario}", '', { 'Content-Type' => 'application/json' })
end

Entonces('se muestra una lista los últimos {int} contenidos') do |_cantidad|
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta[0]['titulo']).to eq 'Waka waka'
  expect(json_respuesta[1]['titulo']).to eq 'Loba'
  expect(json_respuesta[2]['titulo']).to eq 'Suerte'
end

Entonces('se envía un mensaje de error {string}') do |mensaje|
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq mensaje
end

Entonces('se envía un mensaje informativo') do
  json_respuesta = JSON.parse(@respuesta.body)
  expect(@respuesta.status).to eq 200
  expect(json_respuesta).to eq []
end

Dado('que el usuario no se encuentra registrado en el sistema') do
  @id_usuario = '5879'
end
