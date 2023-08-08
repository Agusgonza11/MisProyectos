Cuando('consulto el menú') do
  menus = consultar_menus
  @menus_disponibles = {}
  JSON.parse(menus.body).each do |menu|
    @menus_disponibles[menu['nombre']] = menu['precio']
  end
end

Entonces('veo el menú {string} con precio "{int}"') do |tipo_de_menu, precio|
  expect(@menus_disponibles[tipo_de_menu]).to eq precio
end
