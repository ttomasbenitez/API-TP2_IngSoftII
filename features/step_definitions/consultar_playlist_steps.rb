Dado('el usuario tiene exactamente una canción en la playlist personal') do
  @una_cancion = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-05', 1)
  @una_cancion.registrar(RepositorioContenido.new)
  @usuario.agregar_contenido_a_playlist(@una_cancion)
end

Cuando('el usuario consulta su playlist') do
  @respuesta = Faraday.get("/playlist/#{@id_usuario}", '', { 'Content-Type' => 'application/json' })
end

Entonces('se muestra la canción') do
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta[0]['titulo']).to eq 'Waka waka'
end

Dado('el usuario tiene cinco canciones en la playlist') do
  @cancion1 = Cancion.new('Shakira', 'Waka waka', '3:30', '2010-05-05', 1)
  @cancion2 = Cancion.new('Shakira', 'Loba', '3:30', '2010-05-05', 2)
  @cancion3 = Cancion.new('Shakira', 'lalsl', '3:30', '2010-05-05', 3)
  @cancion4 = Cancion.new('Shakira', 'pepe', '3:30', '2010-05-05', 4)
  @cancion5 = Cancion.new('Shakira', 'mundial', '3:30', '2010-05-05', 5)

  @cancion1.registrar(RepositorioContenido.new)
  @cancion2.registrar(RepositorioContenido.new)
  @cancion3.registrar(RepositorioContenido.new)
  @cancion4.registrar(RepositorioContenido.new)
  @cancion5.registrar(RepositorioContenido.new)
  @usuario.agregar_contenido_a_playlist(@cancion1)
  @usuario.agregar_contenido_a_playlist(@cancion2)
  @usuario.agregar_contenido_a_playlist(@cancion3)
  @usuario.agregar_contenido_a_playlist(@cancion4)
  @usuario.agregar_contenido_a_playlist(@cancion5)
end

Entonces('se muestran cinco canciones') do
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta[0]['titulo']).to eq 'Waka waka'
  expect(json_respuesta[1]['titulo']).to eq 'Loba'
  expect(json_respuesta[2]['titulo']).to eq 'lalsl'
  expect(json_respuesta[3]['titulo']).to eq 'pepe'
  expect(json_respuesta[4]['titulo']).to eq 'mundial'
end

Dado('el usuario no tiene canciones en la playlist personal') do
  nil
end

Entonces('se muestra un mensaje de playlist vacía') do
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta.size).to eq 0
end

Entonces('se muestra un mensaje de error') do
  expect(@respuesta.status).to eq 401
  json_respuesta = JSON.parse(@respuesta.body)
  expect(json_respuesta['error']).to eq 'El usuario no existe'
end
