require 'spec_helper'
require_relative '../lib/presentador_usuario.rb'

describe 'PresentadorUsuario' do
  BIENVENIDO_HERNAN = 'Bienvenido Hernan, tu id de usuario es u1.'.freeze

  it 'da la bienvenida al usuario al recibir sus datos' do
    usuario = Usuario.new('u1', 'Hernan')
    presentador_usuario = PresentadorUsuario.new
    expect(presentador_usuario.presentar(usuario)).to eq BIENVENIDO_HERNAN
  end
end
