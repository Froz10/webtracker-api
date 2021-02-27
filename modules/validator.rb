module Api
  module Validator

    def working_url?(urls)
      uri = URI.parse(urls)
      uri.is_a?(URI::HTTP)
      rescue URI::InvalidURIError
      false
    end

    def valid_json?(links)
      JSON.parse(links) unless links == nil
      rescue JSON::ParserError
      false
    end

    def validate_link(urls)
      urls.map! { |url| url.include?('http') ? url : 'https://' + url }
      urls.map! { |url| working_url?(url) ? URI(url).host : nil }
      urls.compact.uniq
    end

  end
end