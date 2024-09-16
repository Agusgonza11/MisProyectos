require 'spec_helper'
require_relative '../lib/presentador_pedido.rb'
require_relative '../app/models/errors/calificaciones_pendientes.rb'

describe PresentadorPedido do
  subject(:presentador_pedido) { described_class.new }

  PEDIDO_INDIVIDUAL_RESPUESTA = 'Tu pedido de Menu individual fue recibido con exito. Tu numero de pedido es 43'.freeze
  PEDIDO_RECIBIDO_RESPUESTA = 'El pedido 43 esta en estado Recibido.'.freeze
  PEDIDO_EN_PREPARACION_RESPUESTA = 'El pedido 43543 esta en estado En preparacion.'.freeze
  PEDIDO_EN_CAMINO_RESPUESTA = 'El pedido 543 esta en estado En camino.'.freeze
  PEDIDO_ENTREGADO_RESPUESTA = 'El pedido 124 esta en estado Entregado.'.freeze
  PEDIDO_EN_ESPERA_RESPUESTA = 'El pedido 124 esta en estado En espera.'.freeze
  CANCELACION_EXITOSA_RESPUESTA = 'Tu pedido de Menu individual con id 8532 fue cancelado con exito.'.freeze
  PEDIDO_CANCELADO_RESPUESTA = 'El pedido 8532 esta en estado Cancelado.'.freeze
  CALIFICACION_RESPUESTA = 'Tu pedido con id 43 fue calificado con 5.'.freeze
  PEDIDO_NO_ENTREGADO = 'pedido_no_entregado'.freeze
  PEDIDO_YA_CALIFICADO = 'pedido_ya_calificado'.freeze
  PEDIDO_AJENO_A_CONSULTAR = 'consulta_restringida'.freeze
  PEDIDO_AJENO_A_CALIFICAR = 'calificacion_restringida'.freeze
  USUARIO_NECESITA_REGISTRARSE = 'usuario_no_registrado'.freeze
  MENU_INEXISTENTE = 'menu_inexistente'.freeze
  MENU_INEXISTENTE_MENSAJE = 'Menu invalido. Para conocer los menus disponibles ingresa /menus.'.freeze
  PEDIDO_NO_ENTREGADO_MENSAJE = 'No se puede calificar un pedido no entregado!'.freeze
  PEDIDO_YA_CALIFICADO_MENSAJE = 'Este pedido ya está calificado.'.freeze
  PEDIDO_AJENO_NO_CONSULTABLE_MENSAJE = 'No podes operar con el pedido de otro usuario.'.freeze
  PEDIDO_AJENO_NO_CALIFICABLE_MENSAJE = 'No podes operar con el pedido de otro usuario.'.freeze
  USUARIO_NECESITA_REGISTRARSE_MENSAJE = 'Para pedir tenes que estar registrado. Registrate con /registrarse <nombre>, <direccion>, <telefono>'.freeze
  PEDIDO_NO_CALIFICADO_MENSAJE = "Tiene pedidos pendientes de calificación. Califique con /calificar <calificacion>, <comentario-opcional>\nTus Pedididos:\n1 - Menu Familiar - Entregado".freeze

  it 'le dice al cliente que su pedido se recibio exitosamente' do
    pedido_recibido = Pedido.new(43, 'Menu individual', '3213141', 'recibido')
    expect(presentador_pedido.presentar_creacion(pedido_recibido)).to eq PEDIDO_INDIVIDUAL_RESPUESTA
  end

  it 'le dice al cliente que su pedido está en estado recibido' do
    pedido = Pedido.new(43, 'Menu individual', '3213141', 'recibido')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_RECIBIDO_RESPUESTA
  end

  it 'le dice al cliente que su pedido está en estado en preparacion' do
    pedido = Pedido.new(43_543, 'Menu parejas', '151411441', 'en_preparacion')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_EN_PREPARACION_RESPUESTA
  end

  it 'le dice al cliente que su pedido está en estado en camino' do
    pedido = Pedido.new(543, 'Menu parejas', '151441', 'en_camino')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_EN_CAMINO_RESPUESTA
  end

  it 'le dice al cliente que su pedido está en estado entregado' do
    pedido = Pedido.new(124, 'Menu individual', '48523', 'entregado')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_ENTREGADO_RESPUESTA
  end

  it 'le dice al cliente que su pedido esta en estado en espera' do
    pedido = Pedido.new(124, 'Menu individual', '48523', 'en_espera')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_EN_ESPERA_RESPUESTA
  end

  it 'le dice al cliente que la calificacion se efectuo' do
    pedido = Pedido.new(43, 'Menu individual', '48523', 'entregado', 5)
    expect(presentador_pedido.presentar_calificacion(pedido)).to eq CALIFICACION_RESPUESTA
  end

  it 'le dice al cliente que no se pudo calificar un pedido no entregado' do
    expect(presentador_pedido.presentar_error(PedidoError.new(PEDIDO_NO_ENTREGADO))).to eq PEDIDO_NO_ENTREGADO_MENSAJE
  end

  it 'le dice al cliente que no se pudo calificar un pedido ya calificado' do
    expect(presentador_pedido.presentar_error(PedidoError.new(PEDIDO_YA_CALIFICADO))).to eq PEDIDO_YA_CALIFICADO_MENSAJE
  end

  it 'le dice al cliente que no se puede consultar un pedido ajeno' do
    expect(presentador_pedido.presentar_error(PedidoError.new(PEDIDO_AJENO_A_CONSULTAR))).to eq PEDIDO_AJENO_NO_CONSULTABLE_MENSAJE
  end

  it 'le dice al cliente que no se puede calificar un pedido ajeno' do
    expect(presentador_pedido.presentar_error(PedidoError.new(PEDIDO_AJENO_A_CALIFICAR))).to eq PEDIDO_AJENO_NO_CALIFICABLE_MENSAJE
  end

  it 'le dice al cliente que su pedido fue cancelado exitosamente' do
    pedido = Pedido.new(8532, 'Menu individual', '151411441', 'cancelado')
    expect(presentador_pedido.presentar_cancelacion(pedido)).to eq CANCELACION_EXITOSA_RESPUESTA
  end

  it 'le dice al cliente que su pedido está en estado cancelado' do
    pedido = Pedido.new(8532, 'Menu individual', '151411441', 'cancelado')
    expect(presentador_pedido.presentar_estado(pedido)).to eq PEDIDO_CANCELADO_RESPUESTA
  end

  it 'le dice al cliente que tiene que registrarse para hacer un pedido' do
    expect(presentador_pedido.presentar_error(PedidoError.new(USUARIO_NECESITA_REGISTRARSE))).to eq USUARIO_NECESITA_REGISTRARSE_MENSAJE
  end

  it 'le dice al cliente que no existe el pedido solicitado' do
    expect(presentador_pedido.presentar_error(PedidoError.new(MENU_INEXISTENTE))).to eq MENU_INEXISTENTE_MENSAJE
  end

  it 'le dice al cliente que no puede hacer un pedido porque tiene pedidos sin calificar' do
    pedidos_pendientes = []
    pedidos_pendientes << Pedido.new(1, 'Menu Familiar', 'u1', 'Entregado')
    expect(presentador_pedido.presentar_calificaciones_pendientes(CalificacionesPendientes.new(pedidos_pendientes))).to eq PEDIDO_NO_CALIFICADO_MENSAJE
  end
end
