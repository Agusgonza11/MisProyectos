Sequel.migration do
  up do
    add_column :repartidores, :espacio_ocupado, Integer
  end

  down do
    drop_column :repartidores, :espacio_ocupado
  end
end
