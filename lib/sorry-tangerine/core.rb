require 'spidr'
require 'user_agent_randomizer'
require 'sorry-tangerine/parser'

module SorryTangerine
  VERSION = '1.0.0'

  def SorryTangerine.rob
    Core.new().rob
  end

  class Core
    def rob
      Spidr.user_agent = UserAgentRandomizer::UserAgent.fetch(type: "desktop_browser").string
      Spidr.robots     = false

      links = [
        /http:\/\/www\.itjuzi\.com\/company\?page=\d+$/,
        /http:\/\/www\.itjuzi\.com\/company\/\d+$/
      ];

      Spidr.start_at("http://www.itjuzi.com/company?page=1", links: links) do |spidr|
        pattern = /^http:\/\/.+company\/\d+$/

        spidr.every_url do |url|
          puts "\n[#{Time.now}] 正在解析：#{url}\n"

          unless url.to_s =~ pattern
            puts "[#{Time.now}] 跳过解析：#{url}\n"
          end

          sleep 1
        end

        spidr.every_url_like(pattern) do |url|
          unless url.to_s =~ /redirect=company/
            page = spidr.get_page url

            parser = SorryTangerine::Parser.new page
            parser.parse
            parser.store_as_json

            puts "\n"
            puts parser.data
            puts "\n[#{Time.now}] 解析结束：#{page.url}\n"
          else
            puts "[#{Time.now}] 跳过解析：#{url}\n"
          end
        end
      end
    end
  end
end
