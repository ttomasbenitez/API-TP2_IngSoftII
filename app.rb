require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'
require_relative './config/log_middleware'
require_relative './lib/version'
Dir[File.join(__dir__, 'dominio', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'persistencia', '*.rb')].each { |file| require file }

configure do
  customer_logger = Configuration.logger
  DB = Configuration.db # rubocop:disable  Lint/ConstantDefinitionInBlock
  DB.loggers << customer_logger
  set :logger, customer_logger
  set :default_content_type, :json
  set :environment, ENV['APP_MODE'].to_sym
  set :sistema, Sistema.new(ConfiguracionSistemaConPostgres.new)
  use LogMiddleware
end

before do
  if !request.body.nil? && request.body.size.positive?
    request.body.rewind
    @params = JSON.parse(request.body.read, symbolize_names: true)
  end
end

def sistema
  settings.sistema
end

get '/version' do
  logger.debug('Solicitud recibida - GET /version')
  json({ version: Version.current })
end

post '/reset' do
  logger.debug('Solicitud recibida - POST /reset')
  if %w[test development].include?(ENV['APP_MODE'])
    sistema.resetear
    logger.debug('Respuesta - Status: 200')
    status 200
  else
    logger.debug('Respuesta - Status: 403 | Body: Acceso no permitido en este modo')
    status 403
    json({ error: 'Acceso no permitido en este modo' })
  end
end

get '/novedades/:username' do
  logger.debug("Solicitud recibida - GET /novedades/#{params[:username]}")
  novedades = sistema.novedades(@params[:username])
  status 200

  respuesta = novedades.map do |contenido|
    {
      id: contenido.id,
      tipo: contenido.tipo,
      autor: contenido.nombre_autor,
      titulo: contenido.titulo,
      duracion: contenido.duracion,
      fecha_lanzamiento: contenido.fecha_lanzamiento
    }
  end.to_json
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  respuesta
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end

get '/populares/:username' do
  logger.debug("Solicitud recibida - GET /populares/#{params[:username]}")
  populares = sistema.populares(@params[:username])
  status 200

  respuesta = populares.map do |contenido|
    {
      id: contenido.id,
      tipo: contenido.tipo,
      autor: contenido.nombre_autor,
      titulo: contenido.titulo,
      duracion: contenido.duracion,
      fecha_lanzamiento: contenido.fecha_lanzamiento
    }
  end.to_json
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  respuesta
rescue SinReproducciones => e
  logger.debug("Respuesta - Status: 400 | Body: #{e.message}")
  status 400
  { error: e.message }.to_json
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end

get '/usuarios' do
  logger.debug('Solicitud recibida - GET /usuarios')
  usuarios = sistema.usuarios
  respuesta = []
  usuarios.map { |u| respuesta << { email: u.email, id: u.id } }
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  status 200
  json(respuesta)
end

get '/sugerencias/:username' do
  logger.debug("Solicitud recibida - GET /sugerencias/#{params[:username]}")
  artista_sugerido = sistema.sugerencias(@params[:username])
  status 200
  logger.debug("Respuesta - Status: 200 | Body: #{artista_sugerido}")
  return json({}) if artista_sugerido.nil?

  json({ sugerencia: artista_sugerido.nombre })
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  json({ error: e.message })
end

post '/usuarios' do
  logger.debug("Solicitud recibida - POST /usuarios | Email: #{@params[:email]}, Usuario: #{@params[:id]}")
  usuario = sistema.crear_usuario(@params[:email], @params[:id])
  respuesta_body = { id: usuario.id, email: usuario.email }.to_json
  logger.debug("Respuesta - Status: 201 | Body: #{respuesta_body}")
  status 201
  respuesta_body
rescue EmailInvalido, UsuarioYaRegistrado => e
  respuesta_body = { error: e }.to_json
  logger.debug("Respuesta - Status: 400 | Body: #{respuesta_body}")
  status 400
  respuesta_body
end

post '/contenido' do
  logger.debug("Solicitud recibida - POST /contenido | Body: #{@params}")
  contenido = sistema.nuevo_contenido(
    @params[:tipo], @params[:autor], @params[:titulo], @params[:duracion], @params[:fecha_lanzamiento]
  )
  sistema.registrar_contenido(contenido)
  logger.debug('Respuesta - Status: 201')
  status 201
rescue AutorInvalido, TituloInvalido, FechaLanzamientoInvalida, DuracionInvalida, TipoContenidoInvalido => e
  respuesta_body = { error: e }.to_json
  logger.debug("Respuesta - Status: 400 | Body: #{respuesta_body}")
  status 400
  { error: e.message }.to_json
end

post '/reproducciones' do
  logger.debug("Solicitud recibida - POST /reproducciones | Body: #{@params}")
  contenido = sistema.registrar_reproduccion(@params[:id_usuario], @params[:id_contenido])
  logger.debug("Respuesta - Status: 201 | Body: { id_usuario: #{@params[:id_usuario]}, id_contenido: #{contenido.id} }")
  status 201
  { id_usuario: @params[:id_usuario], id_contenido: contenido.id }.to_json
rescue ContenidoInexistente => e
  logger.debug("Respuesta - Status: 400 | Body: #{e.message}")
  status 400
  { error: e.message }.to_json
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end

post '/playlist' do
  logger.debug("Solicitud recibida - POST /playlist | Body: #{@params}")
  contenido = sistema.agregar_a_playlist(
    @params[:id_usuario].to_s, @params[:id_contenido]
  )
  logger.debug("Respuesta - Status: 201 | Body: { tipo: #{contenido.tipo}, autor: #{contenido.nombre_autor}, titulo: #{contenido.titulo} }")
  status 201
  { tipo: contenido.tipo, autor: contenido.nombre_autor, titulo: contenido.titulo }.to_json
rescue ComandoInvalido, ContenidoInexistente, ContenidoDuplicadoEnColeccion, ContenidoNoAgregable => e
  logger.debug("Respuesta - Status: 400 | Body: #{e.message}")
  status 400
  { error: e.message }.to_json
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end

get '/playlist/:username' do
  logger.debug("Solicitud recibida - GET /playlist/#{params[:username]}")
  contenidos = sistema.obtener_canciones_en_playlist(@params[:username])

  status 200
  respuesta = contenidos.map do |contenido|
    {
      id: contenido.id,
      tipo: contenido.tipo,
      autor: contenido.nombre_autor,
      titulo: contenido.titulo,
      duracion: contenido.duracion,
      fecha_lanzamiento: contenido.fecha_lanzamiento
    }
  end.to_json
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  respuesta
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end

get '/contenido/:id_contenido' do
  logger.debug("Solicitud recibida - GET /contenido/#{params[:id_contenido]}")
  contenido = sistema.obtener_informacion_contenido(@params[:id_contenido], @params[:id_usuario])

  status 200
  respuesta = {
    id: contenido.id,
    tipo: contenido.tipo,
    autor: contenido.nombre_autor,
    titulo: contenido.titulo,
    duracion: contenido.duracion,
    fecha_lanzamiento: contenido.fecha_lanzamiento
  }.to_json
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  respuesta
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
rescue ContenidoInexistente => e
  logger.debug("Respuesta - Status: 400 | Body: #{e.message}")
  status 400
  { error: e.message }.to_json
end

post '/me-gusta' do
  logger.debug("Solicitud recibida - POST /me-gusta | Body: #{@params}")
  contenido = sistema.dar_me_gusta(
    @params[:id_usuario].to_s, @params[:id_contenido]
  )
  logger.debug("Respuesta - Status: 201 | Body: { tipo: #{contenido.tipo}, autor: #{contenido.nombre_autor}, titulo: #{contenido.titulo} }")
  status 201
  { tipo: contenido.tipo, autor: contenido.nombre_autor, titulo: contenido.titulo }.to_json
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
rescue ContenidoInexistente, ContenidoDuplicadoEnColeccion, ContenidoSinReproducir => e
  logger.debug("Respuesta - Status: 400 | Body: #{e.message}")
  status 400
  { error: e.message }.to_json
end

get '/recomendaciones/:username' do
  logger.debug("Solicitud recibida - POST /recomendaciones | Parametros: #{@params}")
  artista = sistema.obtener_artista_favorito(@params[:username])
  artista_recomendado = sistema.recomendacion(artista, ConectorSpotify.new(logger))
  respuesta = { favorito: artista.nombre, recomendacion: artista_recomendado.nombre }
  logger.debug("Respuesta - Status: 200 | Body: #{respuesta}")
  status 200
  respuesta.to_json
rescue UsuarioSinFavoritos
  logger.debug('Respuesta - Status: 200 | Body: {}')
  status 200
  {}.to_json
rescue UsuarioInexistente => e
  logger.debug("Respuesta - Status: 401 | Body: #{e.message}")
  status 401
  { error: e.message }.to_json
end
