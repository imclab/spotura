# coding: utf-8

require 'hallon'
require 'pry'
require './parser.rb'

# Kill main thread if any other thread dies.
Thread.abort_on_exception = true

# Init Spotify
appkey_path = File.expand_path('./spotify_appkey.key')
unless File.exists?(appkey_path)
  abort <<-ERROR
    Your Spotify application key could not be found at the path:
      #{appkey_path}

    You may download your application key from:
      https://developer.spotify.com/en/libspotify/application-key/
  ERROR
end

hallon_username = ENV.fetch("SPOTIFY_USERNAME") { prompt("Please enter your spotify username") }
hallon_password = ENV.fetch("SPOTIFY_PASSWORD") { prompt("Please enter your spotify password", hide: true) }
hallon_appkey = IO.read(appkey_path)

if hallon_username.empty? or hallon_password.empty?
  abort <<-ERROR
    Sorry, you must supply both username and password for Hallon to be able to log in.
  ERROR
end

session = Hallon::Session.initialize(hallon_appkey) do
  on(:log_message) do |message|
    puts "[LOG] #{message}"
  end

  on(:credentials_blob_updated) do |blob|
    puts "[BLOB] #{blob}"
  end

  on(:connection_error) do |error|
    puts "[LOG] Connection error"
    Hallon::Error.maybe_raise(error)
  end

  on(:offline_error) do |error|
    puts "[LOG] Offline error"
  end

  on(:logged_out) do
    abort "[FAIL] Logged out!"
  end
end
session.login!(hallon_username, hallon_password)
puts "Successfully logged in!"

session = Hallon::Session.instance

# Select the textura.org page by the letter
letter = 'q'

# Parsing
list = Parser.parse_textura_archive(letter)

# Create the playlist
container = session.container
playlist = container.add "#{ letter.capitalize } (textura.org)"
playlist_tracks = []

# Search for music
list.each do |query|
  search = Hallon::Search.new(query)

  puts "Searching for #{query}"
  search.load

  unless search.tracks.size.zero?
    search.tracks.each do |track|
      playlist_tracks.push(track)
    end
  end

  sleep 0.5
end

playlist.insert(0, playlist_tracks)
playlist.upload
