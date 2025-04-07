Dado('que el autor es un numero') do
  @request_body = { tipo: 'cancion', autor: 15, titulo: 'Waka waka', duracion: '3:30', fecha_lanzamiento: '2010-05-07' }.to_json
end

Dado('que el autor esta vacio') do
  @request_body = { tipo: 'cancion', autor: '', titulo: 'Waka waka', duracion: '3:30', fecha_lanzamiento: '2010-05-07' }.to_json
end

Cuando('envío una carga de contenido') do
  @respuesta = Faraday.post('/contenido', @request_body, { 'Content-Type' => 'application/json' })
end

Entonces('responde con un mensaje de error indicando que el autor debe ser un texto válido.') do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El autor debe ser un texto válido'
end

Dado('que el titulo es un numero') do
  @request_body = { tipo: 'cancion', autor: 'Shakira', titulo: 15, duracion: '3:30', fecha_lanzamiento: '2010-05-07' }.to_json
end

Dado('que el titulo esta vacio') do
  @request_body = { tipo: 'cancion', autor: 'Shakira', titulo: '', duracion: '3:30', fecha_lanzamiento: '2010-05-07' }.to_json
end

Dado('que la duracion esta vacia') do
  @request_body = { tipo: 'cancion', autor: 'Shakira', titulo: 'Waka waka', fecha_lanzamiento: '2010-05-07' }.to_json
end

Entonces('responde con un mensaje de error indicando que el título debe ser un texto válido.') do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El titulo debe ser un texto válido'
end

Dado('que la fecha de lanzamiento no tiene formato de fecha') do
  @request_body = { tipo: 'episodio', autor: 'Olga', titulo: 'Paren la mano', duracion: '10:21', fecha_lanzamiento: 'cancun' }.to_json
end

Entonces('responde con un mensaje de error indicando que la fecha de lanzamiento debe ser una fecha válida.') do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'La fecha de lanzamiento no es valida'
end

When(/^que la duración no sigue el formato de tiempo$/) do
  @request_body = { tipo: 'cancion', autor: 'Luis Miguel', titulo: 'Cancion de luis miguel', duracion: 'diez minutos', fecha_lanzamiento: '2024-05-12' }.to_json
end

Entonces('responde con un mensaje de error indicando que la duración debe tener un formato de tiempo válido.') do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'La duración debe tener un formato de tiempo válido'
end

When(/^que el tipo no es un tipo de contenido valido$/) do
  @request_body = { tipo: 'audiolibro', autor: 'Tolkien', titulo: 'El señor de los anillos 1', duracion: '15:52:14', fecha_lanzamiento: '2004-05-12' }.to_json
end

When(/^responde con un mensaje de error indicando que el tipo de contenido solo puede ser cancion o episodio\.$/) do
  expect(@respuesta.status).to eq 400
  expect(JSON.parse(@respuesta.body)['error']).to eq 'El tipo de contenido solo puede ser cancion o episodio'
end

When(/^que la fecha de lanzamiento esta vacia$/) do
  @request_body = { tipo: 'episodio', autor: 'Un podcast', titulo: 'Episodio 2', duracion: '1:22:14' }.to_json
end

Dado(/^que el tipo esta vacio$/) do
  @request_body = { autor: 'Shakira', titulo: 'Waka waka', duracion: '1:24', fecha_lanzamiento: '2024-02-01' }.to_json
end
