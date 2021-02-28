module Api
  class Tracker
    include Validator

    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
      @store = Api::Storage.new
    end

    def response
      case @request.path
      when '/visited_links' then visited_links
      when '/visited_domains' then visited_domains
      else Rack::Response.new('Not found', 404)
      end
    end

    def visited_links
      if @request.post? && valid_json?
        Rack::Response.new do |response|
          response.headers['Content-Type'] = 'application/json'
          response.body = [{ status: 'ok' }.to_json]
          @store.write_session('links', Time.now.to_i, parse_link(JSON.parse(@request.params['links'])))
        end
      else render_error
      end
    end

    def visited_domains
      if @request.get?
        Rack::Response.new do |response|
          response.headers['Content-Type'] = 'application/json'
          response.status = 200
          uniq_domains = @store.find_session('links', @request.params['from'].to_i, @request.params['to'].to_i)
          response.body = [{ domains: uniq_domains, status: 'ok' }.to_json]
        end
      else Rack::Response.new('Not found', 404)
      end
    end

    def render_error
      Rack::Response.new do |response|
        response.headers['Content-Type'] = 'application/json'
        response.status = 500
        response.body = [{ status: response.status }.to_json]
      end
    end

    def parse_link(urls)
      urls.map! { |url| url.include?('http') ? url : "https://#{url}" }
      urls.map! { |url| working_url?(url) ? URI(url).host : nil }
      urls.compact.uniq
    end
  end
end
