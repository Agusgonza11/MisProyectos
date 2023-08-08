# rubocop:disable all
ENV['RACK_ENV'] = 'test'
ENV['ENABLE_RESET'] = 'true'
ENV['ENABLE_MOCK_CLIMA'] = 'true'
ENV['LANONNA_API_KEY'] = '79b3d02f-9f78-430e-b0a7-658c29d0d16f'

require File.expand_path("#{File.dirname(__FILE__)}/../../config/boot")

require 'rspec/expectations'

if ENV['BASE_URL']
  BASE_URL = ENV['BASE_URL']
else
  BASE_URL = 'http://localhost:3000'.freeze
  include Rack::Test::Methods
  def app
    Padrino.application
  end
end

def header
  {'Content-Type' => 'application/json'}
end


def reset_url
  "#{BASE_URL}/reset"
end

Before do |_scenario|
  Faraday.post(reset_url)
  Faraday.post("#{BASE_URL}/clima",clima: 'soleado')
end

After do |_scenario|
  Faraday.post(reset_url)
end
