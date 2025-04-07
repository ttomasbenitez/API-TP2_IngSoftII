Cuando(/^el usuario intenta registrarse con un correo electrónico no válido$/) do
  @id_usuario = 'usuario'
  @request_body = { email: 'mailinvalido', id: @id_usuario }.to_json
  @respuesta = Faraday.post('/usuarios', @request_body, { 'Content-Type' => 'application/json' })
end

Entonces(/^se muestra un mensaje de error indicando que debe ingresar un email válido$/) do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El email no es valido'
end

Entonces(/^el usuario no queda registrado en el sistema$/) do
  expect(RepositorioUsuarios.new.existe?(@id_usuario)).to eq false
end

Dado('que el usuario {string} ya está registrado en el sistema') do |nombre_usuario|
  RepositorioUsuarios.new.save(Usuario.new('pepe2@pepito.com', nombre_usuario, nil, nil))
end

Cuando(/^el usuario "([^"]*)" intenta registrarse nuevamente$/) do |nombre_usuario|
  @request_body = { id: nombre_usuario, email: 'pepe@pepito.com' }.to_json
  @respuesta = Faraday.post('/usuarios', @request_body, { 'Content-Type' => 'application/json' })
end

Entonces(/^se muestra un mensaje de error indicando que el usuario ya está registrado$/) do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El usuario ya esta registrado'
end
