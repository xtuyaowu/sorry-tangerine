require 'anemone'
require 'sorry-tangerine/parser'

module SorryTangerine
  VERSION = '1.0.0'

  def SorryTangerine.rob
    Core.new().rob
  end

  class Core
    def rob
      Anemone.crawl("http://www.itjuzi.com/") do |anemone|
        anemone.on_pages_like(/company\/(\d+)$/) do |page|
          company = new SorryTangerine::Parser(page).parse

          puts company
        end
      end
    end
  end
end
