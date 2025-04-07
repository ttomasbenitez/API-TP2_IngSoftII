Dado('que el contenido con ID {int} existe en el sistema') do |id_contenido|
  cancion = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-07', id_contenido)
  RepositorioContenido.new.save(cancion)
end

Dado('el usuario con ID {int} existe en el sistema') do |id_usuario|
  usuario = Usuario.new('pepe@pepito.com', '1234', nil, nil, id_usuario)
  RepositorioUsuarios.new.save(usuario)
end

Cuando('llega un pedido a reproducciones con {int} y {int}') do |id_contenido, _id_usuario|
  request_body = { id_contenido:, id_usuario: '1234' }.to_json
  @respuesta = Faraday.post('/reproducciones', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('se registra una reproducción del usuario con {int} de contenido con {int}') do |_id_usuario, id_contenido|
  contenidos = RepositorioReproducciones.new.all

  expect(contenidos.first.id).to eq(id_contenido)
end

Entonces('recibe un mensaje de exito') do
  expect(@respuesta.status).to be 201
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['id_usuario']).to eq '1234'
  expect(json_respuesta['id_contenido']).to eq 1
end

Dado('el usuario con ID {int} no existe en el sistema') do |_id_usuario|
  # nada que hacer aqui
end

When(/^que el contenido con ID (\d+) no existe en el sistema$/) do |_arg|
  # nada que hacer aqui
end

When(/^recibe el mensaje de error "([^"]*)"$/) do |mensaje|
  expect(@respuesta.status).to eq 400
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq mensaje
end

Entonces('recibe el mensaje de error el usuario no existe') do
  expect(@respuesta.status).to eq 401
end
