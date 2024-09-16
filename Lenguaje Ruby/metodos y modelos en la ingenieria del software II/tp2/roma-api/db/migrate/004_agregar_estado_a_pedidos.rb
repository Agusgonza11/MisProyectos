Sequel.migration do
  up do
    add_column :pedidos, :estado, String
  end

  down do
    drop_column :pedidos, :estado
  end
end
