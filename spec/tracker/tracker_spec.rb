require 'spec_helper'

RSpec.describe Api::Tracker do
  def app
    Rack::Builder.parse_file('config.ru').first
  end

  let(:wrong_path) { '/wrong_way' }
  let(:urls) do
    { get: '/visited_domains',
      post: '/visited_links' }
  end

  context 'when GET api path' do
    it 'returns status not found' do
      get wrong_path
      expect(last_response).to be_not_found
    end

    it 'returns status ok' do
      get urls[:get]
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
    end

    it 'returns status ok with params time range' do
      get(urls[:get], {"from" => Time.now.to_i - 10, "to" => Time.now.to_i})
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
    end
  end

  context 'when POST api path' do
    it 'returns status not found' do
      post wrong_path
      expect(last_response).to be_not_found
    end

    it 'returns status ok with params "links"' do
      post(urls[:post], {"links" => ['google.com', 'mail.ru', 'http://ya.ru'].to_json})
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
    end

  end

end




