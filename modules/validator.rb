module Api
  module Validator
    def working_url?(urls)
      uri = URI.parse(urls)
      uri.is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end

    def valid_json?
      JSON.parse(@request.params['links']) unless @request.params['links'].nil?
    rescue JSON::ParserError
      false
    end
  end
end
