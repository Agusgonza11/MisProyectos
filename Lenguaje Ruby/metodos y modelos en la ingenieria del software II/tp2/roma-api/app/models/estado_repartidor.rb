class EstadoRepartidorDisponible
  ID_ESTADO = 'disponible'.freeze

  def id
    ID_ESTADO
  end

  def avanzar(repartidor, espacio_ocupado)
    return if espacio_ocupado.zero?

    repartidor.establecer_estado(EstadoRepartidorEnCamino.new)
  end
end

class EstadoRepartidorEnCamino
  ID_ESTADO = 'en_camino'.freeze

  def id
    ID_ESTADO
  end

  def avanzar(repartidor, _espacio_ocupado)
    repartidor.establecer_estado(EstadoRepartidorDisponible.new)
  end
end

class FabricaEstadosRepartidor
  ESTADOS = {'disponible': EstadoRepartidorDisponible, 'en_camino': EstadoRepartidorEnCamino }.freeze

  def self.fabricar(codigo_estado)
    ESTADOS[codigo_estado.to_sym].new
  end
end
