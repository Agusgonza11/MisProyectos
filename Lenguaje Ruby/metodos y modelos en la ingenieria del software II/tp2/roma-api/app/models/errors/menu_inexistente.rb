class MenuInexistente < StandardError
  def initialize
    super('menu_inexistente')
  end
end
