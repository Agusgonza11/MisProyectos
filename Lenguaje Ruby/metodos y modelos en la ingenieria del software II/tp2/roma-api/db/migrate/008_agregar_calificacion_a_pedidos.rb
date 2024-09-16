Sequel.migration do
  up do
    add_column :pedidos, :calificacion, Integer
  end

  down do
    drop_column :pedidos, :calificacion
  end
end
