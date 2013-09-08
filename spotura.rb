# coding: utf-8

# Require support code, used by all the examples.
require 'hallon'

require "pry"

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
hallon_appkey   = IO.read(appkey_path)

if hallon_username.empty? or hallon_password.empty?
  abort <<-ERROR
    Sorry, you must supply both username and password for Hallon to be able to log in.

    You may also edit examples/common.rb by setting your username and password directly.
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
    Hallon::Error.maybe_raise(error)
  end

  on(:logged_out) do
    abort "[FAIL] Logged out!"
  end
end
session.login!(hallon_username, hallon_password)

puts "Successfully logged in!"


session = Hallon::Session.instance

queries = [
  'Billy Bang Da Bang!',
  'Ben Lukas Boysen Gravity',
  'Esmerine Dalmak',
  'Ex Confusion With Love',
  'Fazio Interiors' ]

container = session.container
playlist = container.add "Sept 2013 (textura.org)"

queries.each do |query|

  search = Hallon::Search.new(query)

  puts "Searching for “#{query}”…"
  search.load

  if search.tracks.size.zero?
    puts "No results for “#{search.query}”."
  else
    tracks = search.tracks[0...10].map(&:load)

    puts "Results for “#{search.query}”: "
    tracks.each_with_index do |track, index|
      puts "  [#{index + 1}] #{track.name} — #{track.artist.name} (#{track.to_link.to_str})"
    end
    playlist.insert(0, tracks)
    playlist.upload
  end

end
