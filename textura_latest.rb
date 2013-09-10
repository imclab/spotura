# coding: utf-8

require 'hallon'
require 'pry'
require 'nokogiri'
require 'open-uri'

require_relative './common.rb'

url = 'http://textura.org/pages/reviews.htm'
doc = Nokogiri::HTML(open(url))

result = []

doc.xpath('//a[contains(@href,"../")]').each do |link|
  artist = link.at_xpath('text()[1]')
  album = link.at_xpath('em')
  if artist && album
    artist = artist.text.sub(/:\s*$/,'').strip
    album = album.text.strip
    result.push "artist:\"#{ artist }\" album:\"#{ album }\""
  end
end

session = Hallon::Session.instance

issue = doc.xpath("//p[@class='style9'][1]").text

# Create the playlist
container = session.container
playlist = container.add "#{ issue } (textura.org)"
playlist_tracks = []

# Search for music
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
