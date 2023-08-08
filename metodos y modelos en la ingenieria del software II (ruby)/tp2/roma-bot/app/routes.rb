require "#{File.dirname(__FILE__)}/../lib/presentador_menu"
require "#{File.dirname(__FILE__)}/../lib/presentador_usuario"
require "#{File.dirname(__FILE__)}/../lib/presentador_pedido"
require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/../lib/team"
require "#{File.dirname(__FILE__)}/../lib/routes_helper"
require "#{File.dirname(__FILE__)}/models/errors/calificaciones_pendientes"

class Routes
  include Routing

  on_message '/start' do |bot, mensaje, _argumentos, _webapi|
    bot.api.send_message(chat_id: mensaje.chat.id, text: "Hola, #{mensaje.from.first_name}")
  end

  on_message '/stop' do |bot, mensaje, _argumentos, _webapi|
    bot.api.send_message(chat_id: mensaje.chat.id, text: "Chau, #{mensaje.from.username}")
  end

  on_message '/version' do |bot, mensaje, _argumentos, _webapi|
    bot.api.send_message(chat_id: mensaje.chat.id, text: Version.current)
  end

  on_message '/version-api' do |bot, mensaje, _argumentos, webapi|
    version = webapi.consultar_version_api
    bot.api.send_message(chat_id: mensaje.chat.id, text: version)
  end

  on_message '/equipo' do |bot, mensaje, _argumentos, _webapi|
    bot.api.send_message(chat_id: mensaje.chat.id, text: Team.name)
  end

  on_message '/menus' do |bot, mensaje, _argumentos, webapi|
    listado_menus = webapi.menus
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorMenu.new.presentar_listado(listado_menus))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorMenu.new.presentar_error(e))
  end

  on_message_pattern %r{/registrarse (?<nombre>.*), (?<direccion>.*), (?<telefono>.*)} do |bot, mensaje, argumentos, webapi|
    usuario = webapi.crear_usuario(usuario_emisor(mensaje),
                                   argumentos['nombre'],
                                   argumentos['direccion'],
                                   argumentos['telefono'])
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorUsuario.new.presentar(usuario))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorUsuario.new.presentar_error(e))
  end

  on_message_pattern %r{/pedir (?<numero_menu>[0-9]+\s*$)} do |bot, mensaje, argumentos, webapi|
    pedido = webapi.pedir_menu(usuario_emisor(mensaje), argumentos['numero_menu'])
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_creacion(pedido))
  rescue CalificacionesPendientes => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_calificaciones_pendientes(e))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_error(e))
  end

  on_message_pattern %r{/consultar (?<numero_pedido>[0-9]+\s*$)} do |bot, mensaje, argumentos, webapi|
    pedido = webapi.consultar_pedido(usuario_emisor(mensaje), argumentos['numero_pedido'])
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_estado(pedido))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_error(e))
  end

  on_message_pattern %r{/calificar (?<numero_pedido>\d+), (?<calificacion>[0-9]{1})(, (?<comentario>.*))?} do |bot, mensaje, argumentos, webapi|
    pedido = webapi.calificar_pedido(usuario_emisor(mensaje),
                                     argumentos['numero_pedido'],
                                     argumentos['calificacion'],
                                     argumentos['comentario'])
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_calificacion(pedido))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_error(e))
  end

  on_message_pattern %r{/cancelar (?<numero_pedido>[0-9]+\s*$)} do |bot, mensaje, argumentos, webapi|
    pedido = webapi.cancelar_pedido(usuario_emisor(mensaje), argumentos['numero_pedido'])
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_cancelacion(pedido))
  rescue PedidoError => e
    bot.api.send_message(chat_id: mensaje.chat.id, text: PresentadorPedido.new.presentar_error(e))
  end

  default do |bot, mensaje, _argumentos, _webapi|
    bot.api.send_message(chat_id: mensaje.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
