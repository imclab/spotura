require 'test/unit'
require './parser.rb'

class ParserTest < Test::Unit::TestCase
    def test_reviews
      puts Parser.parse_textura_reviews
    end

    def test_archives
      puts Parser.parse_textura_archive
    end
end
