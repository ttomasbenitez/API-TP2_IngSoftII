require 'webmock/cucumber'

def obtengo_artista_similar(token, _id_artista, artista_similar)
  stub_request(:get, 'https://run.mocky.io/v3/f3827bd4-56cb-4c77-8045-0f18841b8074')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => "Bearer #{token}",
        'User-Agent' => 'Faraday v2.7.5'
      }
    )
    .to_return(status: 200, body: { 'artists' => [{ 'name' => artista_similar }] }.to_json, headers: {})
end

def obtengo_id_de_artista(token, artista, id)
  stub_request(:get, "https://api.spotify.com/v1/search?limit=1&market=AR&q=#{artista}&type=artist")
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => "Bearer #{token}",
        'User-Agent' => 'Faraday v2.7.5'
      }
    )
    .to_return(status: 200, body: { 'artists' => { 'items' => [{ 'id' => id }] } }.to_json, headers: {})
end

def obtengo_token
  client_id = ENV['SPOTIFY_CLIENT_ID'] || 'fake_id'
  client_secret = ENV['SPOTIFY_CLIENT_SECRET'] || 'fake_secret'

  stub_request(:post, 'https://accounts.spotify.com/api/token')
    .with(
      body: { 'grant_type' => 'client_credentials' },
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}",
        'Content-Type' => 'application/x-www-form-urlencoded',
        'User-Agent' => 'Faraday v2.7.5'
      }
    )
    .to_return(status: 200, body: { 'access_token' => 'fake' }.to_json, headers: {})
end
