When(/^que el miembro del equipo de contenido tiene acceso al endpoint de alta de contenido$/) do
  nil
end

When(/^envía una solicitud de agregar un contenido que es un episodio de podcast$/) do
  body = { tipo: 'episodio', autor: 'un podcast', titulo: 'episodio 4', duracion: '1:30:00', fecha_lanzamiento: '2014-02-14' }.to_json
  @respuesta = Faraday.post('/contenido', body, { 'Content-Type' => 'application/json' })
end

When(/^el episodio es añadido al catálogo de la plataforma$/) do
  expect(@respuesta.status).to be 201
end
