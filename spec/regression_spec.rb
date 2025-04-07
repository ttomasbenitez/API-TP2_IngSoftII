require 'faraday'
require 'json'
require 'webmock/rspec'

def random_string(length = 10)
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  Array.new(length) { chars.sample }.join
end

describe 'API::TestRegresion', regression: true do
  let(:base_url) { ENV.fetch('URL_API', 'http://localhost:3000') }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  it 'Registra, carga canción, busca novedades, reproduce canción y da me gusta a novedad' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    WebMock.disable!
    begin
      # Registración de usuario
      user_handle = random_string
      request_body = { email: "#{user_handle}@regresion.com", id: user_handle }.to_json
      respuesta_registracion = Faraday.post("#{base_url}/usuarios", request_body, headers)
      expect(respuesta_registracion.status).to eq(201)

      # Cargar una canción
      nombre_cancion = random_string
      request_body = {
        tipo: 'cancion',
        autor: 'Shakira',
        titulo: nombre_cancion,
        duracion: '3:30',
        fecha_lanzamiento: '2010-05-07'
      }.to_json
      respuesta_carga_cancion = Faraday.post("#{base_url}/contenido", request_body, headers)
      expect(respuesta_carga_cancion.status).to eq(201)

      # Usuario busca novedades
      respuesta_novedades = Faraday.get("#{base_url}/novedades/#{user_handle}", headers)
      expect(respuesta_novedades.status).to eq(200)
      novedades = JSON.parse(respuesta_novedades.body)
      expect(novedades.size).to be > 0

      una_novedad = novedades[0]
      id_novedad = una_novedad['id']

      # Usuario reproduce canción
      request_body = { id_contenido: id_novedad, id_usuario: user_handle }.to_json
      respuesta_reproduccion = Faraday.post("#{base_url}/reproducciones", request_body, headers)
      expect(respuesta_reproduccion.status).to eq(201)
      respuesta_reproduccion_json = JSON.parse(respuesta_reproduccion.body)
      expect(respuesta_reproduccion_json['id_usuario']).to eq(user_handle)
      expect(respuesta_reproduccion_json['id_contenido']).to eq(id_novedad)

      # Usuario da me gusta a novedad
      request_body = { id_usuario: user_handle, id_contenido: id_novedad }.to_json
      respuesta_dar_me_gusta = Faraday.post("#{base_url}/me-gusta", request_body, headers)
      expect(respuesta_dar_me_gusta.status).to eq(201)

      # Usuario obtiene recomendacion según su artista favorito
      respuesta_recomendacion = Faraday.get("#{base_url}/recomendaciones/#{user_handle}", headers)
      expect(respuesta_recomendacion.status).to eq 200
      respuesta = JSON.parse(respuesta_recomendacion.body)
      expect(respuesta['favorito']).not_to be_nil
      expect(respuesta['recomendacion']).not_to be_nil
    ensure
      WebMock.enable!
    end
  end
end
