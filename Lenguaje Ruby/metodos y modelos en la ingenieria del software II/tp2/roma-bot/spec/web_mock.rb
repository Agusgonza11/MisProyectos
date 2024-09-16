require 'webmock/rspec'

WebMock.allow_net_connect! if ENV['INTEGRACION'] == 'true'
