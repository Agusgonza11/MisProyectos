class FabricaPedidos
  MENUS_DISPONIBLES = [{ 'id': 1, 'nombre': 'Menu individual', 'precio': 100, 'volumen': 1},
                       { 'id': 2, 'nombre': 'Menu parejas', 'precio': 175, 'volumen': 2 },
                       { 'id': 3, 'nombre': 'Menu familiar', 'precio': 250, 'volumen': 3 }].freeze

  def self.menus_disponibles
    MENUS_DISPONIBLES
  end

  def self.fabricar(numero_menu, usuario, fecha, api_clima)
    Pedido.crear(obtener_nombre(numero_menu), FabricaEstadosPedido.fabricar('recibido'), usuario, obtener_precio(numero_menu), obtener_volumen(numero_menu), fecha, api_clima)
  end

  def self.obtener_atributo(atributo, numero_menu)
    MENUS_DISPONIBLES.each do |menu|
      return menu[atributo] if menu[:id].to_s == numero_menu
    end
    raise MenuInexistente
  end

  def self.obtener_nombre(numero_menu)
    obtener_atributo('nombre'.to_sym, numero_menu)
  end

  def self.obtener_precio(numero_menu)
    obtener_atributo('precio'.to_sym, numero_menu)
  end

  def self.obtener_volumen(numero_menu)
    obtener_atributo('volumen'.to_sym, numero_menu)
  end
end
