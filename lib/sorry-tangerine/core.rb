require 'spidr'
require 'sorry-tangerine/parser'

module SorryTangerine
  VERSION = '1.0.0'

  def SorryTangerine.rob
    Core.new().rob
  end

  class Core
    def rob
      Spidr.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36';
      Spidr.robots    = false

      Spidr.host("www.itjuzi.com") do |spidr|
        spidr.every_url_like(/^http:\/\/.+company\/\d+$/) do |url|
          page = spidr.get_page url

          puts "\n[#{Time.now}] 正在解析：#{page.url}\n\n"

          parser = SorryTangerine::Parser.new page
          parser.parse
          parser.store_as_json

          puts parser.data
          puts "\n[#{Time.now}] 解析结束：#{page.url}\n"
        end
      end
    end
  end
end
