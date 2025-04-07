Dado('que el miembro del equipo de contenido tiene acceso al endpoint de alta de canciones') do
  nil
end

Cuando('envía una solicitud de agregar un contenido que es una canción') do
  request_body = { tipo: 'cancion', autor: 'Shakira', titulo: 'Waka waka', duracion: '3:30', fecha_lanzamiento: '2010-05-07' }.to_json
  @respuesta = Faraday.post('/contenido', request_body, { 'Content-Type' => 'application/json' })
end

Entonces('la canción es añadida al catálogo de la plataforma') do
  @repositorio_contenido = RepositorioContenido.new
  expect(@repositorio_contenido.all.first.tipo).to eq 'cancion'
  expect(@repositorio_contenido.all.first.titulo).to eq 'Waka waka'
end

Entonces('se recibe un mensaje de éxito') do
  expect(@respuesta.status).to eq 201
end
