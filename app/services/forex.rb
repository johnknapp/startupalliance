class Forex

  class << self

    def convert_today(from,to,amount=1)
      raw = Net::HTTP.get(URI("https://api.fixer.io/latest?base=#{from.upcase}"))
      response = JSON.parse(raw, symbolize_names: true)
      amount * response[:rates][to.upcase.to_sym]
    end

    def convert_on(yyyy_mm_dd,from,to,amount=1)
      raw = Net::HTTP.get(URI("https://api.fixer.io/#{yyyy_mm_dd}?base=#{from.upcase}"))
      response = JSON.parse(raw, symbolize_names: true)
      amount * response[:rates][to.upcase.to_sym]
    end

    def rates_today(source)
      raw = Net::HTTP.get(URI("https://api.fixer.io/latest?base=#{source.upcase}"))
      JSON.parse(raw)['rates']
    end

    def rates_on(yyyy_mm_dd,source)
      raw = Net::HTTP.get(URI("https://api.fixer.io/#{yyyy_mm_dd}?base=#{source.upcase}"))
      JSON.parse(raw)['rates']
    end

  end

end