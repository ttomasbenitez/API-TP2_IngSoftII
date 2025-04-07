Cuando(/^creo un usuario$/) do
  request_body = { email: 'juan@test.com', id: '7373732' }.to_json
  @respuesta = Faraday.post('/usuarios', request_body, { 'Content-Type' => 'application/json' })
end

Entonces(/^se le asigna un id$/) do
  parsed_respuesta = JSON.parse(@respuesta.body)
  id = parsed_respuesta['id']
  expect(id.to_i).to be > 0
end

Cuando(/^que no existen usuario$/) do
  # nada que hacer aqui
end

Cuando(/^consulto los usuarios$/) do
  @respuesta = Faraday.get('/usuarios')
end

Entonces(/^tengo un listado vacio$/) do
  parsed_respuesta = JSON.parse(@respuesta.body)
  expect(parsed_respuesta)
end
