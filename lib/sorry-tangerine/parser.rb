module SorryTangerine
  class Parser
    def initialize(page)
      @page = page
      @data = {}
    end

    def parse
      puts "\n[#{Time.now}] 正在解析：#{@page.url}\n"

      @data[:title] = @page.title
      @data[:url]   = @page.url.to_s

      @data[:company] = {}

      @data[:company][:title]    = get_text_at 'span.title b'
      @data[:company][:scope]    = get_array_at '.info-line .scope a'
      @data[:company][:location] = get_array_at '.info-line .loca a'
      @data[:company][:tags]     = get_array_at '.rowfoot .tagset a tag'
      @data[:company][:desc]     = get_text_at '.block-inc-info .block .des'
      @data[:company][:name]     = get_array_at('.block .des-more div span').first.gsub('公司全称：', '')
      @data[:company][:created_at] = get_array_at('.block .des-more div span')[1].gsub('成立时间：', '')
      @data[:company][:status] = get_array_at('.block .des-more div span')[2].gsub('成立时间：', '')

      puts "\n[#{Time.now}] 解析结束：#{@page.url}\n"
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
