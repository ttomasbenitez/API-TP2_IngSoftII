When(/^un episodio de podcast se acaba de publicar$/) do
  body = { tipo: 'episodio', autor: 'un podcast', titulo: 'episodio 5', duracion: '1:30:00', fecha_lanzamiento: '2014-02-14' }.to_json
  Faraday.post('/contenido', body, { 'Content-Type' => 'application/json' })
end

When(/^el episodio de podcast está incluido en las novedades$/) do
  respuesta_json = JSON.parse(@respuesta.body)
  expect(respuesta_json[0]['autor']).to eq 'un podcast'
  expect(respuesta_json[0]['titulo']).to eq 'episodio 5'
end

When(/^una canción se acaba de publicar$/) do
  body = { tipo: 'cancion', autor: 'metallica', titulo: 'master of puppets', duracion: '5:00', fecha_lanzamiento: '1985-02-14' }.to_json
  Faraday.post('/contenido', body, { 'Content-Type' => 'application/json' })
end

When(/^la canción está incluida en las novedades$/) do
  respuesta_json = JSON.parse(@respuesta.body)
  expect(respuesta_json[1]['autor']).to eq 'metallica'
  expect(respuesta_json[1]['titulo']).to eq 'master of puppets'
end
