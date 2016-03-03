require 'json'

module SorryTangerine
  class Parser
    def initialize(page)
      @page = page
      @data = {}
    end

    def parse
      puts "\n[#{Time.now}] 正在解析：#{@page.url}\n"

      @data[:id]    = @page.url.to_s.match(/company\/(\d+)/)[1]
      @data[:title] = @page.title
      @data[:url]   = @page.url.to_s

      @data[:company] = {}

      @data[:company][:title]    = get_text_at('span.title b').gsub(/\/.*/, '')
      @data[:company][:status]   = get_text_at('span.title b').match(/\((.*)\)/)[1]
      @data[:company][:scope]    = get_array_at '.info-line .scope a'
      @data[:company][:location] = get_array_at '.info-line .loca a'
      @data[:company][:tags]     = get_array_at '.rowfoot .tagset a .tag'
      @data[:company][:desc]     = get_text_at '.block-inc-info .block .des'
      @data[:company][:name]     = get_array_at('.block .des-more div span').first.gsub('公司全称：', '')
      @data[:company][:created_at] = get_array_at('.block .des-more div span')[1].gsub('成立时间：', '')
      @data[:company][:operation] = get_array_at('.block .des-more div span')[2]

      puts @data

      puts "\n[#{Time.now}] 解析结束：#{@page.url}\n"
    rescue NoMethodError
    end

    def id
      @data[:id]
    end

    def store_as_json(dir = './data')
      json_str = @data.to_json
      file     = File.expand_path "#{id()}.json", dir
      File.open(file, 'w') { |f| f.write(json_str) }
    end

    protected

    def get_text_at(selector)
      @page.at(selector).text.gsub(/\s+/, '')
    end

    def get_array_at(selector)
      @page.search(selector).map { |node| node.text.gsub(/\s+/, '') }.compact
    end
  end
end
