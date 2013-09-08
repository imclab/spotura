require 'nokogiri'
require 'open-uri'

module Parser

  class Textura
    def parse(url)
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

      result
    end
  end

  def Parser.parse_textura_reviews
    Textura.new.parse "http://textura.org/pages/reviews.htm"
  end

  def Parser.parse_textura_archive(letter)
    Textura.new.parse "http://textura.org/archives/mainpages/archives_#{ letter }.htm"
  end

end
