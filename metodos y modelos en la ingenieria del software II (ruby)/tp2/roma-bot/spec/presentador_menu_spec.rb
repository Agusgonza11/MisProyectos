require 'spec_helper'
require_relative '../lib/presentador_menu.rb'
require_relative '../app/models/menu.rb'

describe PresentadorMenu do
  MENU_RESPUESTA = "1-Menu individual ($100)\n2-Menu parejas ($175)\n3-Menu familiar ($250)".freeze

  it 'presenta el listado de menus recibido' do
    lista_menus = []
    lista_menus << Menu.new(1, 'Menu individual', 100) << Menu.new(2, 'Menu parejas', 175) << Menu.new(3, 'Menu familiar', 250)
    presentador_menu = described_class.new
    expect(presentador_menu.presentar_listado(lista_menus)).to eq MENU_RESPUESTA
  end
end
