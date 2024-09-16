Sequel.migration do
  up do
    add_column :pedidos, :fecha, Date
  end

  down do
    drop_column :pedidos, :fecha
  end
end
