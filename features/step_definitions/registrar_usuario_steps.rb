Dado('que el usuario no está registrado en el sistema') do
  @id_usuario = '@test_username'
end

Cuando('el usuario se registra con un correo electrónico') do
  request_body = { email: 'juan@test.com', id: 'juan' }.to_json
  @respuesta = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('el usuario queda registrado en el sistema') do
  expect(@respuesta.status).to eq 201
  @sistema = Sistema.new(ConfiguracionSistemaConPostgres.new)
  expect(@sistema.usuarios.first.email).to eq 'juan@test.com'
  expect(@sistema.usuarios.first.username).to eq 'juan'
end
