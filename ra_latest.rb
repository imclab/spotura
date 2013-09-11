# coding: utf-8

require 'hallon'
require 'pry'
require 'nokogiri'
require 'open-uri'

require_relative './common.rb'

url = 'http://www.residentadvisor.net/reviews.aspx?format=album'
doc = Nokogiri::HTML(open(url))

result = []

doc.xpath('//a[@class="music" and contains(@href,"/review-view")]').each do |link|
  artist, album = link.text.split(' - ')
  if artist && album
    artist = artist.strip
    album = album.strip
    result.push "artist:\"#{ artist }\" album:\"#{ album }\""
  end
end

session = Hallon::Session.instance

## Create the playlist
container = session.container
playlist = container.add "Latest album reviews (RA)"
playlist_tracks = []

## Search for music
result.each do |query|
  search = Hallon::Search.new(query)

  puts "Searching for #{query}"
  search.load

  unless search.tracks.size.zero?
    search.tracks.each do |track|
      playlist_tracks.push(track)
    end
  end

  sleep 1
end

playlist.insert(0, playlist_tracks)
playlist.upload
