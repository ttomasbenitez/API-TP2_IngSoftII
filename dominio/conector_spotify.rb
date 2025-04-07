require 'faraday'
require 'base64'
require 'dotenv/load'
class ConectorSpotify
  API_OBTENER_ID_ARTISTA = 'https://api.spotify.com/v1/search?type=artist&limit=1&market=AR&q='.freeze

  def initialize(logger)
    @logger = logger
    @client_id = ENV['SPOTIFY_CLIENT_ID'] || 'fake_id'
    @client_secret = ENV['SPOTIFY_CLIENT_SECRET'] || 'fake_secret'
  end

  def obtener_artista_similar(artista)
    id_artista = obtener_id_de_artista(artista)
    @logger.info("Solicitud de artistas similares a Spotify - https://api.spotify.com/v1/artists/#{id_artista}/related-artists")
    connection = Faraday.new('https://run.mocky.io') do |faraday|
      faraday.headers['Authorization'] = "Bearer #{@access_token}"
    end

    response = connection.get('/v3/f3827bd4-56cb-4c77-8045-0f18841b8074')
    body = JSON.parse(response.body)
    @logger.info("Respuesta de solicitud de artistas similares a Spotify - Status: #{response.status} | Body: #{body}")
    Artista.new(body.dig('artists', 0, 'name'))
  end

  private

  def obtener_id_de_artista(artista)
    @access_token = obtener_access_token
    @logger.info("Solicitud de id de artista a Spotify - #{API_OBTENER_ID_ARTISTA}#{artista.nombre}")

    connection = Faraday.new do |faraday|
      faraday.headers['Authorization'] = "Bearer #{@access_token}"
    end
    response = connection.get("#{API_OBTENER_ID_ARTISTA}#{artista.nombre}")

    body = JSON.parse(response.body)
    @logger.info("Respuesta de solicitud de id de artista a Spotify - Status: #{response.status} | Body: #{body}")
    body.dig('artists', 'items', 0, 'id')
  end

  def obtener_access_token
    @logger.info('Solicitud de token a Spotify - https://accounts.spotify.com/api/token')

    connection = Faraday.new('https://accounts.spotify.com/api/token') do |faraday|
      faraday.headers['Authorization'] = "Basic #{Base64.strict_encode64("#{@client_id}:#{@client_secret}")}"
      faraday.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    end

    response = post_request(connection)

    contenidos = JSON.parse(response.body)
    @logger.info("Respuesta de solicitud de token Spotify - Status: #{response.status} | Body: #{contenidos}")

    contenidos['access_token']
  end

  def post_request(connection)
    connection.post do |req|
      req.body = 'grant_type=client_credentials'
    end
  end
end
