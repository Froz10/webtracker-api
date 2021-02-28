require 'spec_helper'

RSpec.describe Api::Tracker do
  def app
    Rack::Builder.parse_file('config.ru').first
  end

  subject(:storage) { Api::Storage.new }

  let(:wrong_path) { '/wrong_route' }
  let(:params_links) { ['google.com', 'mail.ru', 'http://ya.ru'] }
  let(:params_links_from) { ['google.com', 'mail.ru', 'ya.ru'] }
  let(:params_links_to) { ['funbox.ru', 'stackoverflow.com'] }
  let(:params_domains) do
    { from: Time.now.to_i - 10,
      to: Time.now.to_i }
  end
  let(:urls) do
    { get: '/visited_domains',
      post: '/visited_links' }
  end

  context 'when GET wrong api path' do
    it 'returns status not found' do
      get wrong_path
      expect(last_response).to be_not_found
    end

    it 'returns status ok' do
      get urls[:get]
      expect(last_response).to be_ok
    end

    it 'returns status ok with params time range' do
      get(urls[:get], { 'from' => params_domains[:from], 'to' => params_domains[:to] })
      expect(last_response).to be_ok
    end
  end

  context 'when POST api path' do
    it 'returns status not found' do
      post wrong_path
      expect(last_response).to be_not_found
    end

    it 'returns status ok with params "links"' do
      post(urls[:post], { 'links' => params_links.to_json })
      expect(last_response).to be_ok
    end

    it 'returns status 500 if params nil ' do
      post(urls[:post], { 'links' => nil })
      expect(last_response.status).to eq(500)
    end
  end

  context 'when GET api path' do
    it 'returns domains from storage' do
      storage.write_session('links', params_domains[:from], params_links_from)
      storage.write_session('links', params_domains[:to], params_links_to)
      get(urls[:get], { 'from' => params_domains[:from], 'to' => params_domains[:to] })
      expect(last_response.body).to eq({ domains: params_links_from + params_links_to , status: 'ok' }.to_json)
    end

  end
end
